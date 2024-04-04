SELECT
    {{ dbt_utils.generate_surrogate_key(['id']) }} as customer_key,
    ADDRESS:country::STRING AS country,
    TO_TIMESTAMP("CREATED") AS created_timestamp,
    TO_TIMESTAMP("UPDATED") AS updated_timestamp
FROM
  {{ source('novel', 'stripe_customers') }}