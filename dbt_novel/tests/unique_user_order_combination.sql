SELECT
  user_id,
  order_id,
  COUNT(*) as num_occurrences
FROM {{ model }}
GROUP BY user_id, order_id
HAVING COUNT(*) > 1
