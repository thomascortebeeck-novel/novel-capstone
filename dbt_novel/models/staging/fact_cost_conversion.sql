WITH fb_cost AS (
    SELECT
        DATE_START_DATE as date,
        META_SOURCE,
        META_MEDIUM,
        SUM(SPEND) as total_spend
    FROM
        {{ ref('meta_insights') }}
    GROUP BY
        DATE_START_DATE,
        META_SOURCE,
        META_MEDIUM
),
ga_conversions AS (
    SELECT
        EVENT_TIMESTAMP::DATE as date,
        TRAFFIC_SOURCE,
        TRAFFIC_MEDIUM,
        COUNT(EVENT_NAME) as conversions
    FROM
        {{ ref('ga4_purchase_utm') }}
    GROUP BY
        EVENT_TIMESTAMP::DATE,
        TRAFFIC_SOURCE,
        TRAFFIC_MEDIUM
)
SELECT
    fb.date,
    fb.total_spend,
    ga.conversions,
    CASE
        WHEN ga.conversions = 0 THEN NULL
        ELSE fb.total_spend / ga.conversions
    END as cost_per_conversion
FROM
    fb_cost fb
INNER JOIN
    ga_conversions ga
ON
    fb.date = ga.date
    AND fb.META_SOURCE = ga.TRAFFIC_SOURCE
    AND fb.META_MEDIUM = ga.TRAFFIC_MEDIUM
ORDER BY
    fb.date