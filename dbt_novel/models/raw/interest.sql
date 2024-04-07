SELECT
    {{ dbt_utils.generate_surrogate_key(['_id']) }} as interest_key,
    {{ dbt_utils.generate_surrogate_key(['"CREATED BY"']) }} as user_key,
    CAST(LOWER(name) AS VARCHAR) AS interest_name,
    TO_TIMESTAMP("CREATED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS created_timestamp,
    TO_TIMESTAMP("MODIFIED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS modified_timestamp,\
    CAST(LOWER(_airbyte_raw_id) AS VARCHAR) AS airbyte_raw_id,
    CAST(LOWER(_airbyte_extracted_at) AS VARCHAR) AS airbyte_extracted_at,
    _airbyte_meta:errors AS airbyte_errors
FROM
  {{ source('novel', 'bubble_category') }}


-- WHERE
--  PARSE_JSON(AIRBYTE_META):errors IS NOT NULL 
--  AND ARRAY_SIZE(PARSE_JSON(AIRBYTE_META):errors) > 0;