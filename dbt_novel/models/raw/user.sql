SELECT
    {{ dbt_utils.generate_surrogate_key(['_id']) }} as user_key,
    {{ dbt_utils.generate_surrogate_key(['stripecustomerid']) }} as customer_key,
    CAST(LOWER(email) AS VARCHAR) AS email,
    CAST(LOWER(gender) AS VARCHAR) AS gender,
    CAST(LOWER("LAST NAME") AS VARCHAR) AS last_name,
    CAST(LOWER("FIRST NAME") AS VARCHAR) AS first_name,
    f.value::VARCHAR AS interest_id,
    TO_TIMESTAMP("CREATED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS created_timestamp,
    TO_TIMESTAMP("MODIFIED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS modified_timestamp,
    CAST(LOWER(_airbyte_raw_id) AS VARCHAR) AS airbyte_raw_id,
    CAST(LOWER(_airbyte_extracted_at) AS VARCHAR) AS airbyte_extracted_at,
    _airbyte_meta:errors AS airbyte_errors,
FROM
    {{ source('novel', 'bubble_user') }},
    LATERAL FLATTEN(input => {{ source('novel', 'bubble_user') }}.interest) f
