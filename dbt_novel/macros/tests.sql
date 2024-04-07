{% macro test_unique_user_order_combination(model) %}

SELECT
  user_id,
  order_id,
  COUNT(*) as num_occurrences
FROM {{ model }}
GROUP BY user_id, order_id
HAVING COUNT(*) > 1

{% endmacro %}
