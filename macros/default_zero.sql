{% macro default_zero(column_name) %}
    coalesce({{ column_name }}, 0)
{% endmacro %}