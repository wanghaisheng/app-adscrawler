-- DROP MATERIALIZED VIEW adtech.app_ads_store_apps_companies;
-- store_apps that were found connected to app_ads txt files
-- PARTNER to adtech.store_apps_companies (from SDK)
CREATE MATERIALIZED VIEW adtech.app_ads_store_apps_companies
TABLESPACE pg_default
AS SELECT DISTINCT
    aum.store_app,
    sa.name AS app_name,
    aum.pub_domain,
    pd.url AS pub_domain_url,
    pnv.ad_domain_url,
    pnv.relationship,
    c.id AS company_id,
    c.name AS company_name,
    COALESCE(c.parent_company_id, c.id) AS parent_id
FROM
    app_urls_map AS aum
LEFT JOIN pub_domains AS pd
    ON
        aum.pub_domain = pd.id
LEFT JOIN publisher_network_view AS pnv
    ON
        pd.url = pnv.publisher_domain_url
LEFT JOIN ad_domains AS ad
    ON
        pnv.ad_domain_url = ad.domain
LEFT JOIN adtech.company_domain_mapping AS cdm
    ON
        ad.id = cdm.domain_id
LEFT JOIN adtech.companies AS c
    ON
        cdm.company_id = c.id
LEFT JOIN store_apps AS sa
    ON
        aum.store_app = sa.id
WHERE
    sa.crawl_result = 1 AND (pnv.ad_domain_url IS NOT NULL OR c.id IS NOT NULL)
WITH DATA;

DROP INDEX IF EXISTS idx_app_ads_store_apps_companies;
CREATE UNIQUE INDEX idx_app_ads_store_apps_companies
ON
adtech.app_ads_store_apps_companies (
    store_app,
    app_name,
    pub_domain,
    pub_domain_url,
    ad_domain_url,
    relationship,
    company_id,
    company_name,
    parent_id
);


-- DROP MATERIALIZED VIEW adtech.combined_store_apps_companies CASCADE ;
CREATE MATERIALIZED VIEW adtech.combined_store_apps_companies
TABLESPACE pg_default
AS
WITH sdk_based_companies AS (
    SELECT
        sac.store_app,
        cm.mapped_category AS app_category,
        sac.company_id,
        sac.parent_id,
        ad.domain AS ad_domain,
        'sdk' AS tag_source
    FROM
        adtech.store_apps_companies AS sac
    LEFT JOIN adtech.company_domain_mapping AS cdm
        ON
            COALESCE(sac.company_id, sac.parent_id) = cdm.company_id
    LEFT JOIN ad_domains AS ad
        ON
            cdm.domain_id = ad.id
    LEFT JOIN store_apps AS sa ON sac.store_app = sa.id
    LEFT JOIN category_mapping AS cm ON sa.category = cm.original_category
),

app_ads_based_companies AS (
    SELECT
        aasac.store_app,
        cm.mapped_category AS app_category,
        aasac.company_id,
        aasac.parent_id,
        aasac.ad_domain_url AS ad_domain,
        'app_ads_direct' AS tag_source
    FROM
        adtech.app_ads_store_apps_companies AS aasac
    LEFT JOIN store_apps AS sa ON aasac.store_app = sa.id
    LEFT JOIN category_mapping AS cm ON sa.category = cm.original_category
    WHERE aasac.relationship = 'DIRECT'
),

app_ads_reseller_based_companies AS (
    SELECT
        aasac.store_app,
        cm.mapped_category AS app_category,
        aasac.company_id,
        aasac.parent_id,
        aasac.ad_domain_url AS ad_domain,
        'app_ads_reseller' AS tag_source
    FROM
        adtech.app_ads_store_apps_companies AS aasac
    LEFT JOIN store_apps AS sa ON aasac.store_app = sa.id
    LEFT JOIN category_mapping AS cm ON sa.category = cm.original_category
    WHERE aasac.relationship = 'RESELLER'
)

SELECT *
FROM
    sdk_based_companies
UNION
SELECT *
FROM
    app_ads_based_companies
UNION
SELECT *
FROM
    app_ads_reseller_based_companies
WITH DATA;


-- DROP INDEX IF EXISTS idx_combined_store_apps_companies;
-- CREATE UNIQUE INDEX idx_combined_store_apps_companies
-- ON adtech.combined_store_apps_companies (
--     store_app, app_category, company_id, parent_id, ad_domain, tag_source
-- );

--DROP MATERIALIZED VIEW adtech.companies_app_counts ;
-- A FINAL TABLE FOR company_overviews
CREATE MATERIALIZED VIEW adtech.companies_app_counts AS
WITH my_counts AS (
    SELECT DISTINCT
        csac.store_app,
        sa.store,
        cm.mapped_category AS app_category,
        csac.tag_source,
        csac.ad_domain AS company_domain,
        c.name AS company_name
    FROM
        adtech.combined_store_apps_companies AS csac
    LEFT JOIN adtech.companies AS c
        ON
            csac.company_id = c.id
    LEFT JOIN store_apps AS sa
        ON
            csac.store_app = sa.id
    LEFT JOIN category_mapping AS cm ON
        sa.category = cm.original_category
),

app_counts AS (
    SELECT
        store,
        app_category,
        tag_source,
        company_domain,
        company_name,
        COUNT(*) AS app_count
    FROM
        my_counts
    GROUP BY
        store,
        app_category,
        tag_source,
        company_domain,
        company_name
)

SELECT
    ac.app_count,
    ac.store,
    ac.app_category,
    ac.tag_source,
    ac.company_domain,
    ac.company_name
FROM
    app_counts AS ac
ORDER BY
    ac.app_count DESC
WITH DATA;

DROP INDEX IF EXISTS idx_companies_app_counts;
CREATE UNIQUE INDEX idx_companies_app_counts
ON adtech.companies_app_counts (
    store, app_category, tag_source, company_domain, company_name
);

DROP MATERIALIZED VIEW adtech.companies_parent_app_counts;
CREATE MATERIALIZED VIEW adtech.companies_parent_app_counts AS
WITH my_counts AS (
    SELECT DISTINCT
        csac.store_app,
        sa.store,
        cm.mapped_category AS app_category,
        csac.tag_source,
        csac.ad_domain AS company_domain,
        c.name AS company_name
    FROM
        adtech.combined_store_apps_companies AS csac
    LEFT JOIN adtech.companies AS c
        ON
            csac.parent_id = c.id
    LEFT JOIN store_apps AS sa
        ON
            csac.store_app = sa.id
    LEFT JOIN category_mapping AS cm ON
        sa.category = cm.original_category
),
app_counts AS (
    SELECT
        store,
        app_category,
        tag_source,
        company_domain,
        company_name,
        COUNT(*) AS app_count
    FROM
        my_counts
    GROUP BY
        store,
        app_category,
        tag_source,
        company_domain,
        company_name
)

SELECT
    ac.app_count,
    ac.store,
    ac.app_category,
    ac.tag_source,
    ac.company_domain,
    ac.company_name
FROM
    app_counts AS ac
ORDER BY
    ac.app_count DESC
WITH DATA;


DROP INDEX IF EXISTS idx_companies_parent_app_counts;
CREATE UNIQUE INDEX idx_companies_parent_app_counts
ON adtech.companies_parent_app_counts (
    store, app_category, tag_source, company_domain, company_name
);

DROP MATERIALIZED VIEW adtech.company_top_apps;
-- THIS IS ONLY FOR FRONTEND QUERIES
CREATE MATERIALIZED VIEW adtech.company_top_apps
TABLESPACE pg_default
AS
WITH ranked_apps AS (
    SELECT
        sa.store,
        cac.tag_source,
        sa.name,
        sa.store_id,
        cac.app_category AS category,
        sa.rating_count,
        sa.installs,
        cac.ad_domain AS company_domain,
        c.name AS company_name,
        ROW_NUMBER() OVER (
            PARTITION BY
                sa.store,
                cac.ad_domain,
                c.name,
                cac.tag_source
            ORDER BY
                GREATEST(
                    COALESCE(sa.rating_count, 0), COALESCE(sa.installs, 0)
                ) DESC
        ) AS app_company_rank,
        ROW_NUMBER() OVER (
            PARTITION BY
                sa.store,
                cac.app_category,
                cac.ad_domain,
                c.name,
                cac.tag_source
            ORDER BY
                GREATEST(
                    COALESCE(sa.rating_count, 0), COALESCE(sa.installs, 0)
                ) DESC
        ) AS app_company_category_rank
    FROM
        adtech.combined_store_apps_companies AS cac
    LEFT JOIN store_apps AS sa
        ON
            cac.store_app = sa.id
    LEFT JOIN adtech.companies AS c ON
        cac.company_id = c.id
)

SELECT
    company_domain,
    company_name,
    store,
    tag_source,
    name,
    store_id,
    category,
    app_company_rank,
    app_company_category_rank,
    rating_count,
    installs
FROM
    ranked_apps
WHERE
    app_company_category_rank <= 100
ORDER BY
    store,
    tag_source,
    app_company_category_rank
WITH DATA;


CREATE INDEX idx_company_top_apps_category
ON adtech.company_top_apps (company_domain, category);


DROP INDEX IF EXISTS idx_company_top_apps;
CREATE UNIQUE INDEX idx_company_top_apps
ON adtech.company_top_apps (
    company_domain, company_name, store, tag_source, name, store_id, category
);

-- DROP MATERIALIZED VIEW adtech.companies_parent_categories_app_counts;
CREATE MATERIALIZED VIEW adtech.companies_parent_categories_app_counts AS
SELECT
    csac.ad_domain AS company_domain,
    c.name AS company_name,
    csac.app_category,
    COUNT(DISTINCT csac.store_app) AS app_count
FROM
    adtech.combined_store_apps_companies AS csac
LEFT JOIN adtech.companies AS c ON csac.parent_id = c.id
GROUP BY
    csac.ad_domain, c.name, csac.app_category
ORDER BY c.name ASC, app_count DESC
WITH DATA;

DROP INDEX IF EXISTS idx_companies_parent_categories_app_counts;
CREATE UNIQUE INDEX idx_companies_parent_categories_app_counts
ON adtech.companies_parent_categories_app_counts (
    company_domain, company_name, app_category
);




-- DROP MATERIALIZED VIEW adtech.companies_categories_app_counts;
CREATE MATERIALIZED VIEW adtech.companies_categories_app_counts AS
SELECT
    csac.ad_domain AS company_domain,
    c.name AS company_name,
    csac.app_category,
    COUNT(DISTINCT csac.store_app) AS app_count
FROM
    adtech.combined_store_apps_companies AS csac
LEFT JOIN adtech.companies AS c ON csac.company_id = c.id
GROUP BY
    csac.ad_domain, c.name, csac.app_category
ORDER BY c.name ASC, app_count DESC
WITH DATA;

DROP INDEX IF EXISTS idx_companies_categories_app_counts;
CREATE UNIQUE INDEX idx_companies_categories_app_counts
ON adtech.companies_categories_app_counts (
    company_domain, company_name, app_category
);


DROP MATERIALIZED VIEW adtech.total_categories_app_counts;
CREATE MATERIALIZED VIEW adtech.total_categories_app_counts AS
SELECT
    sa.store,
    tag_source,
    csac.app_category,
    COUNT(DISTINCT csac.store_app) AS app_count
FROM
    adtech.combined_store_apps_companies AS csac
LEFT JOIN store_apps AS sa
    ON
        csac.store_app = sa.id
GROUP BY
    sa.store,
    tag_source,
    csac.app_category
WITH DATA;


DROP MATERIALIZED VIEW adtech.companies_categories_types_app_counts;
CREATE MATERIALIZED VIEW adtech.companies_categories_types_app_counts AS
SELECT
    sa.store,
    csac.app_category,
    csac.tag_source,
    csac.ad_domain AS company_domain,
    c.name AS company_name,
    cats.url_slug AS type_url_slug,
    COUNT(DISTINCT store_app) AS app_count
FROM
    adtech.combined_store_apps_companies AS csac
LEFT JOIN adtech.company_categories AS ccats
    ON
        csac.company_id = ccats.company_id
LEFT JOIN adtech.categories AS cats
    ON
        ccats.category_id = cats.id
LEFT JOIN adtech.companies AS c
    ON
        csac.company_id = c.id
LEFT JOIN store_apps AS sa
    ON
        csac.store_app = sa.id
GROUP BY
    sa.store,
    csac.app_category,
    csac.tag_source,
    csac.ad_domain,
    c.name,
    cats.url_slug
WITH DATA;
