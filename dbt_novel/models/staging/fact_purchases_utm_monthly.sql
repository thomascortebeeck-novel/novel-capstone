
SELECT 
    d.month_start_date as month_start_date,
    g.traffic_medium,
    g.traffic_source,
    g.traffic_campaign,
    COUNT(c.transaction_key) as number_of_transactions -- Calculate the count of transaction_key
FROM
  {{ ref('charges') }} as c
  inner join {{ ref('ga4_purchase_utm') }} as g on c.transaction_key = g.transaction_key
  inner join {{ ref('dim_date') }} as d on d.date_day = DATE(c.created_timestamp) -- ensure created_timestamp is a date field in order to join correctly
group by
    d.month_start_date,
    g.traffic_medium,
    g.traffic_source,
    g.traffic_campaign