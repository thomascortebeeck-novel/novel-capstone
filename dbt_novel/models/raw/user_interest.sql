SELECT
    {{ dbt_utils.generate_surrogate_key(['_id', 'FLATTENED.VALUE::STRING']) }} as user_interest_key,
    {{ dbt_utils.generate_surrogate_key(['_id']) }} as user_key,
    {{ dbt_utils.generate_surrogate_key(['FLATTENED.VALUE::STRING']) }} as interest_key,
FROM
  {{ source('novel', 'bubble_user') }},
   LATERAL FLATTEN(input => bubble_user.INTEREST) AS FLATTENED
