WITH scd AS (
    SELECT
        user_key,
        customer_key,
        email,
        gender,
        last_name,
        first_name,
        created_timestamp,
        modified_timestamp,
        airbyte_raw_id,
        airbyte_extracted_at,
        airbyte_errors,
        dbt_valid_from,
        dbt_valid_to
    FROM {{ ref('snapshot_user') }} -- Referencing the snapshot
)

SELECT
    *,
    CASE
        WHEN dbt_valid_to IS NULL THEN 'current'
        ELSE 'historical'
    END as record_status
FROM scd
WHERE record_status = 'current'