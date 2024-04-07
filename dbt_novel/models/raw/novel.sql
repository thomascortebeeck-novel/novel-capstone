WITH novel_base AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['_id']) }} as novel_key,
        IMAGE,
        PRICE,
        TITLE,
        CATEGORY,
        DESCRIPTION,
        "CREATED BY",
        "CREATED DATE",
        "MODIFIED DATE",
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta
    FROM 
        {{ source('novel', 'bubble_novel') }}
),
flattened_category AS (
    SELECT 
        nb.novel_key,
        nb.IMAGE AS image_url,
        nb.PRICE AS price,
        LOWER(nb.TITLE) AS title,
        nb.DESCRIPTION AS description,
        {{ dbt_utils.generate_surrogate_key(['nb."CREATED BY"']) }} as user_key,
        f.value::VARCHAR as interest,
        TO_TIMESTAMP(nb."CREATED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS created_timestamp,
        TO_TIMESTAMP(nb."MODIFIED DATE", 'YYYY-MM-DD"T"HH24:MI:SS.FF3"Z"') AS modified_timestamp,
        LOWER(nb._airbyte_raw_id) AS airbyte_raw_id,
        LOWER(nb._airbyte_extracted_at) AS airbyte_extracted_at,
        nb._airbyte_meta:errors AS airbyte_errors,
    FROM novel_base nb,
    LATERAL FLATTEN(input => nb.CATEGORY) f
)

SELECT 
    novel_key,
    CAST(image_url AS VARCHAR) AS image_url,
    CAST(price AS DECIMAL(10, 2)) AS price,
    CAST(title AS VARCHAR) AS title,
    {{ dbt_utils.generate_surrogate_key(['interest']) }} as interest_key,
    CAST(LOWER(description) AS VARCHAR) AS description,
    user_key,
    created_timestamp,
    modified_timestamp,
    CAST(airbyte_raw_id AS VARCHAR) AS airbyte_raw_id,
    CAST(airbyte_extracted_at AS VARCHAR) AS airbyte_extracted_at,
    airbyte_errors
FROM flattened_category
