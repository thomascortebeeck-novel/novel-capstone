{% macro divide_by_hundred(amount) %}
  CAST({{ amount }} / 100 AS DECIMAL(10,2))
{% endmacro %}
