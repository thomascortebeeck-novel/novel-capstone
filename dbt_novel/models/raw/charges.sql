{{
    config(
        materialized="incremental",
        unique_key=["transaction_id"],
        incremental_strategy="delete+insert"
    )
}}


WITH extracted_transactions AS (
    SELECT
        *,
        TRIM(SPLIT_PART("DESCRIPTION", '- ', 2)) AS transaction_id
    FROM
        {{ source('novel', 'stripe_charges') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['transaction_id']) }} as transaction_key,
    extracted.transaction_id,
    {{ dbt_utils.generate_surrogate_key(['customer']) }} as customer_key,
    TO_TIMESTAMP(extracted."CREATED") AS created_timestamp,
    TO_TIMESTAMP(extracted."UPDATED") AS updated_timestamp,
    {{ divide_by_hundred("AMOUNT") }} as amount,
    CAST(LOWER(extracted.paid) AS VARCHAR) AS is_paid,
    CAST(LOWER(extracted.status) AS VARCHAR) AS status,
    CAST(LOWER(extracted.currency) AS VARCHAR) AS currency,
    CAST(LOWER(extracted.refunded) AS BOOLEAN) AS is_refunded,
    CAST(LOWER(extracted._airbyte_raw_id) AS VARCHAR) AS airbyte_raw_id,
    CAST(LOWER(extracted._airbyte_extracted_at) AS VARCHAR) AS airbyte_extracted_at,
    extracted._airbyte_meta:errors AS airbyte_errors
FROM
    extracted_transactions AS extracted
WHERE
    transaction_id != '' -- filter only when transaction id is filled in, otherwise not unique. Reason, no id in the first transctions 

-- Only include this part in the incremental run
{% if is_incremental() %}
  and updated_timestamp > (SELECT MAX(updated_timestamp) FROM {{ this }}) -- not where since already a where statement before 
{% endif %}