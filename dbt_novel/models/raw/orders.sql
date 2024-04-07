SELECT
    {{ dbt_utils.generate_surrogate_key(['_id']) }} as order_key,
    {{ dbt_utils.generate_surrogate_key(['"CREATED BY"']) }} as user_key,
    {{ dbt_utils.generate_surrogate_key(['novel']) }} as novel_key,
    status,
    TO_TIMESTAMP("CREATED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS created_timestamp,
    TO_TIMESTAMP("MODIFIED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS modified_timestamp,
    CAST(LOWER(_airbyte_raw_id) AS VARCHAR) AS airbyte_raw_id,
    CAST(LOWER(_airbyte_extracted_at) AS VARCHAR) AS airbyte_extracted_at,
    _airbyte_meta:errors AS airbyte_errors
FROM
    {{ source('novel', 'bubble_order') }}
