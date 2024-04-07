SELECT
    CAST(DATE_START AS DATE) AS date_start_date,
    CAST(ad_id AS INTEGER) AS ad_id,
    CAST(ad_name AS VARCHAR) AS ad_name,
    CAST(adset_id AS INTEGER) AS adset_id,
    CAST(adset_name AS VARCHAR) AS adset_name,
    CAST(campaign_id AS INTEGER) AS campaign_id,
    CAST(campaign_name AS VARCHAR) AS campaign_name,
    CAST(reach AS INTEGER) AS reach,
    CAST(impressions AS INTEGER) AS impressions,
    CAST(frequency AS FLOAT) AS frequency,
    CAST(clicks AS INTEGER) AS clicks,
    CAST(spend AS DECIMAL(10, 2)) AS spend,
    'facebook' as meta_source,
    'cpc' as meta_medium,
    CAST(_airbyte_raw_id AS VARCHAR) AS airbyte_raw_id,
    CAST(_airbyte_extracted_at AS VARCHAR) AS airbyte_extracted_at,
    _airbyte_meta:errors AS airbyte_errors
FROM
    {{ source('novel', 'meta_ads_insights') }}
