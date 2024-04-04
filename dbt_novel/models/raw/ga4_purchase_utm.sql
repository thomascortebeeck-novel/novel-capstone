SELECT 
  {{ dbt_utils.generate_surrogate_key(['ECOMMERCE:transaction_id::STRING']) }} as charge_key,
  event_date,
  event_timestamp as event_timestamp_unix,
  TO_TIMESTAMP(event_timestamp / 1000000) AS event_timestamp,
  CAST(LOWER(event_name) AS VARCHAR) AS event_name,
  ECOMMERCE:purchase_revenue::FLOAT AS purchase_revenue,
  TRAFFIC_SOURCE:medium::STRING AS traffc_medium,
  TRAFFIC_SOURCE:source::STRING AS traffc_source,
  TRAFFIC_SOURCE:campaign::STRING AS traffc_campaign,
  CAST(LOWER(_airbyte_raw_id) AS VARCHAR) AS airbyte_raw_id,
  CAST(LOWER(_airbyte_extracted_at) AS VARCHAR) AS airbyte_extracted_at,
  _airbyte_meta:errors AS airbyte_errors
FROM
  {{ source('novel', 'ga4_bigquery_events') }}
WHERE 
  event_name='purchase'