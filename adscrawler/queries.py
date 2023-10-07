import datetime
import uuid

import numpy as np
import pandas as pd
from sqlalchemy import text

from adscrawler.config import get_logger
from adscrawler.connection import PostgresCon

logger = get_logger(__name__)

"""Database Quries
Most queries attempt to stay simple without significant processing
"""


def upsert_df(
    df: pd.DataFrame,
    table_name: str,
    database_connection: PostgresCon,
    key_columns: list[str],
    insert_columns: list[str],
    return_rows: bool = False,
    schema: str | None = None,
    log: bool = False,
) -> pd.DataFrame | None:
    """
    Perform an "upsert" on a PostgreSQL table from a DataFrame.
    Constructs an INSERT … ON CONFLICT statement, uploads the DataFrame to a
    temporary table, and then executes the INSERT.
    Parameters
    ----------
    data_frame : pandas.DataFrame
        The DataFrame to be upserted.
    table_name : str
        The name of the target table.
    engine : sqlalchemy.engine.Engine
        The SQLAlchemy Engine to use.
    schema : str, optional
        The name of the schema containing the target table.
    key_columns : list of str, optional
        A list of the column name(s) on which to match. If omitted, the
        primary key columns of the target table will be used.
    """
    table_spec = ""
    if schema:
        table_spec += '"' + schema.replace('"', '""') + '".'
    table_spec += '"' + table_name.replace('"', '""') + '"'

    all_columns = list(set(key_columns + insert_columns))

    insert_col_list = ", ".join([f'"{col_name}"' for col_name in all_columns])
    match_col_list = ", ".join([f'"{col}"' for col in key_columns])
    update_on = ", ".join([f'"{col}" = EXCLUDED."{col}"' for col in all_columns])

    if return_rows:
        returning_str = " RETURNING * ;"
    else:
        returning_str = ""
    temp_table = f"temp_{uuid.uuid4().hex[:6]}"
    sql_query = f"""INSERT INTO {table_spec} ({insert_col_list})
                SELECT {insert_col_list} FROM {temp_table}
                ON CONFLICT ({match_col_list}) 
                DO UPDATE SET
                    {update_on}
                {returning_str}
    """

    if log:
        logger.info(sql_query)

    with database_connection.engine.begin() as conn:
        conn.exec_driver_sql(f"DROP TABLE IF EXISTS {temp_table}")
        conn.exec_driver_sql(
            f"""CREATE TEMPORARY TABLE {temp_table} 
            AS SELECT * FROM {table_spec} WHERE false"""
        )
        df[all_columns].to_sql(
            temp_table,
            con=conn,
            if_exists="append",
            index=False,
        )
        result = conn.exec_driver_sql(sql_query)
        if return_rows:
            if result.returns_rows:
                get_df = pd.DataFrame(result.mappings().all())
            else:
                logger.warning("Sqlalchemy result did not have rows")
                get_df = pd.DataFrame()
        conn.execute(text(f'DROP TABLE "{temp_table}";'))
    if return_rows:
        return get_df
    else:
        return None


def query_developers(
    database_connection: PostgresCon, store: int, limit: int = 1000
) -> pd.DataFrame:
    before_date = (datetime.datetime.today() - datetime.timedelta(days=7)).strftime(
        "%Y-%m-%d"
    )
    sel_query = f"""SELECT
        *
        FROM
        developers d
        LEFT JOIN logging.developers_crawled_at dc
        ON d.id = dc.developer
        WHERE store = {store} 
            AND (apps_crawled_at <= '{before_date}' OR apps_crawled_at IS NULL)
        ORDER BY apps_crawled_at NULLS FIRST
        limit {limit}
        ;
        """
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def query_store_id_map(
    database_connection: PostgresCon, store: int, store_ids: list[str] | None = None
) -> pd.DataFrame:
    if store_ids:
        store_ids_list = "'" + "','".join(store_ids) + "'"
        store_ids_str = f"""AND store_id in ({store_ids_list}) """
    else:
        store_ids_str = ""
    sel_query = f"""SELECT
        id, store, store_id
        FROM
        store_apps
        WHERE store = {store}
        {store_ids_str}
        ;
        """
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def query_collections(database_connection: PostgresCon) -> pd.DataFrame:
    sel_query = """SELECT
        *
        FROM
        store_collections
        ;
        """
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def query_categories(database_connection: PostgresCon) -> pd.DataFrame:
    sel_query = """SELECT
        *
        FROM
        store_categories
        ;
        """
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def query_store_ids(
    database_connection: PostgresCon, store: int, store_ids: list[str] | None = None
) -> list[str]:
    df = query_store_id_map(
        database_connection=database_connection, store=store, store_ids=store_ids
    )
    ids: list = []
    if not df.empty:
        ids = df["store_id"].tolist()
    else:
        ids = []
    return ids


def query_pub_domains(
    database_connection: PostgresCon,
    limit: None | int = 10000,
    exclude_recent_days: int = 2,
) -> pd.DataFrame:
    """Query pub domains
    that have apps which are ad supported and still on store
    params: limit: int number of rows to return
    """
    limit_str = ""
    exclude_str = ""
    if exclude_recent_days:
        before_date = (
            datetime.datetime.today() - datetime.timedelta(days=exclude_recent_days)
        ).strftime("%Y-%m-%d")
        exclude_str = f"AND (pd.crawled_at <= '{before_date}' OR pd.crawled_at IS NULL)"
    if limit:
        limit_str = f"LIMIT {limit}"
    sel_query = f"""SELECT
            DISTINCT pd.id, pd.url, pd.crawled_at
        FROM
            app_urls_map aum
        LEFT JOIN pub_domains pd ON
            pd.id = aum.pub_domain
        LEFT JOIN store_apps sa ON
            sa.id = aum.store_app
        WHERE
            sa.ad_supported
            AND sa.crawl_result = 1
            {exclude_str}
        ORDER BY
            pd.crawled_at NULLS FIRST
        {limit_str}
        ; 
        """
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def delete_app_url_mapping(store_app: int, database_connection: PostgresCon) -> None:
    del_query = f"""DELETE
        FROM app_urls_map
        WHERE store_app = {store_app}
        ;
        """
    logger.info("delete app_urls_map")
    with database_connection.engine.begin() as conn:
        conn.exec_driver_sql(del_query)


def query_store_apps(
    stores: list[int], database_connection: PostgresCon, limit: int | None = 1000
) -> pd.DataFrame:
    short_update_days = 7
    short_update_installs = 1000
    short_update_reviews = 100
    short_update_date = (
        datetime.datetime.today() - datetime.timedelta(days=short_update_days)
    ).strftime("%Y-%m-%d")
    long_update_days = 20
    bad_crawl_result_days = 30
    long_update_date = (
        datetime.datetime.today() - datetime.timedelta(days=long_update_days)
    ).strftime("%Y-%m-%d")
    recrawl_404_date = (
        datetime.datetime.today() - datetime.timedelta(days=bad_crawl_result_days)
    ).strftime("%Y-%m-%d")
    installs_and_dates_str = f""" AND (
                            (
                            (installs >= {short_update_installs}
                                OR review_count >= {short_update_reviews})
                            AND updated_at <= '{short_update_date}'
                            AND crawl_result = 1 OR crawl_result IS NULL
                            ) 
                        OR (
                            updated_at <= '{long_update_date}'
                            AND crawl_result = 1
                            )
                            OR (
                            updated_at <= '{recrawl_404_date}'
                            )
                        )
                        """
    where_str = "store IN (" + (", ").join([str(x) for x in stores]) + ")"
    where_str += installs_and_dates_str
    where_str += " OR crawl_result IS NULL "
    limit_str = ""
    if limit:
        limit_str = f"LIMIT {limit}"
    sel_query = f"""SELECT store, id as store_app, store_id, updated_at  
        FROM store_apps
        WHERE {where_str}
        ORDER BY
            (CASE
                WHEN crawl_result IS NULL THEN 0
                ELSE 1
            END),
            --updated_at
            (installs + review_count) DESC NULLS LAST
        {limit_str}
        """
    print(sel_query)
    df = pd.read_sql(sel_query, database_connection.engine)
    return df


def query_all(
    table_name: str,
    key_cols: list[str] | str,
    df: pd.DataFrame,
    database_connection: PostgresCon,
) -> pd.DataFrame:
    if isinstance(key_cols, str):
        key_cols = [key_cols]
    wheres = []
    for key_col in key_cols:
        keys = df[key_col].unique().tolist()
        if all([isinstance(x, (np.integer, int)) for x in keys]):
            values_str = "(" + (", ").join([str(x) for x in keys]) + ")"
        else:
            values_str = "('" + ("', '").join(keys) + "')"
            values_str = values_str.replace("%", "%%")
        where = f"{key_col} IN {values_str}"
        wheres.append(where)
    where_str = " AND ".join(wheres)
    sel_query = f"""SELECT *
    FROM {table_name}
    WHERE {where_str}
    """
    # logger.info(sel_query)
    df = pd.read_sql(sel_query, database_connection.engine)
    return df
