import json
import os

import google_play_scraper
import pandas as pd

from adscrawler.config import MODULE_DIR, get_logger

logger = get_logger(__name__)


def scrape_app_gp(store_id: str, country: str, language: str = "") -> dict:
    # Note language seems not to change the number of reviews, but country does
    # Note country does not change number of installs
    # NOTE: Histogram, Ratings, score are SOMETIMES country specific
    # NOTE: Reviews are always country specific?
    # NOTE: Installs are never country specific
    # Example: 'ratings'
    # dom_nl = scrape_app_gp('com.nexonm.dominations.adk', 'nl')
    # dom_us = scrape_app_gp('com.nexonm.dominations.adk', 'us')
    # dom_us['ratings']==dom_nl['ratings']
    # In the case above NL and US both have the same number of ratings
    # paw_nl = scrape_app_gp('com.originatorkids.paw', 'nl')
    # paw_us = scrape_app_gp('com.originatorkids.paw', 'us')
    # paw_us['ratings']==paw_nl['ratings']
    # In the case above NL and US both have very different number of ratings

    result: dict = google_play_scraper.app(
        store_id, lang=language, country=country  # defaults to 'en'  # defaults to 'us'
    )
    return result


def clean_google_play_app_df(df: pd.DataFrame) -> pd.DataFrame:
    df = df.rename(
        columns={
            "title": "name",
            "installs": "min_installs",
            "realInstalls": "installs",
            # "appId": "store_id",
            "score": "rating",
            "updated": "store_last_updated",
            "reviews": "review_count",
            "ratings": "rating_count",
            "summary": "short_description",
            "released": "release_date",
            "containsAds": "ad_supported",
            "offersIAP": "in_app_purchases",
            "url": "store_url",
            "icon": "icon_url_512",
            "developerWebsite": "url",
            "developerId": "developer_id",
            "developer": "developer_name",
            "genreId": "category",
        }
    )
    df.loc[df["min_installs"].isnull(), "min_installs"] = df.loc[
        df["min_installs"].isnull(), "installs"
    ].astype(str)
    df = df.assign(
        min_installs=df["min_installs"]
        .str.replace(r"[,+]", "", regex=True)
        .fillna(0)
        .astype(int),
        category=df["category"].str.lower(),
        store_last_updated=pd.to_datetime(
            df["store_last_updated"], unit="s"
        ).dt.strftime("%Y-%m-%d %H:%M"),
        release_date=pd.to_datetime(df["release_date"], format="%b %d, %Y").dt.date,
    )
    return df


def js_update_ids_file(filepath: str, is_developers: bool = False) -> None:
    if os.path.exists(filepath):
        os.remove(filepath)
    cmd = f"node {MODULE_DIR}/pullAppIds.js"
    if is_developers:
        cmd += " --developers"
    os.system(cmd)
    logger.info("Js pull finished")


def get_js_data(filepath: str, is_json: bool = True) -> list[dict] | list:
    with open(filepath, mode="r") as file:
        if is_json:
            data = [json.loads(line) for line in file if line.strip()]
        else:
            data = [line.strip() for line in file]
    return data


def scrape_gp_for_app_ids() -> list[dict]:
    logger.info("Scrape GP frontpage for new apps start")
    filepath = "/tmp/googleplay_json.txt"
    try:
        js_update_ids_file(filepath)
    except Exception as error:
        logger.exception(f"JS pull failed with {error=}")
    ranked_dicts = get_js_data(filepath)
    logger.info("Scrape GP frontpage for new apps finished")
    return ranked_dicts


def scrape_gp_for_developer_app_ids(developer_ids: list[str]) -> list:
    logger.info("Scrape GP developers for new apps start")
    developers_filepath = "/tmp/googleplay_developers.txt"
    if os.path.exists(developers_filepath):
        os.remove(developers_filepath)

    with open(developers_filepath, "w") as file:
        for dev_id in developer_ids:
            file.write(f"{dev_id}\n")

    app_ids_filepath = "/tmp/googleplay_developers_app_ids.txt"
    try:
        js_update_ids_file(app_ids_filepath, is_developers=True)
    except Exception as error:
        logger.exception(f"JS pull failed with {error=}")
    try:
        app_ids = get_js_data(app_ids_filepath, is_json=False)
    except Exception:
        logger.exception("Unable to load scraped js developer app file")
        app_ids = []
    logger.info("Scrape GP developers for new apps finished")
    return app_ids


def crawl_google_developers(
    developer_ids: list[str],
    store_ids: list[str],
) -> pd.DataFrame:
    store = 1
    app_ids = scrape_gp_for_developer_app_ids(developer_ids=developer_ids)
    new_app_ids = [x for x in app_ids if x not in store_ids]
    if len(new_app_ids) > 1:
        apps_df = pd.DataFrame({"store": store, "store_id": new_app_ids})
    else:
        apps_df = pd.DataFrame(columns=["store", "store_id"])
    return apps_df
