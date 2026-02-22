{% macro clean_string(column_name, format='lower') %}
    {% if format == 'lower' %}
        trim(lower({{ column_name }}))
    {% elif format == 'title' %}
        initcap(trim({{ column_name }}))
    {% else %}
        trim({{ column_name }})
    {% endif %}
{% endmacro %}