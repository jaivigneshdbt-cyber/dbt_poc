-- macros/cleansing_macros.sql
{% macro standardize_case(column_name, case_type='lower') %}
    {% if case_type == 'lower' %}
        lower({{ column_name }})
    {% elif case_type == 'upper' %}
        upper({{ column_name }})
    {% elif case_type == 'initcap' %}
        initcap({{ column_name }}) -- Not all databases support initcap. Adjust if needed.
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid case_type. Must be 'lower', 'upper', or 'initcap'.") }}
    {% endif %}
{% endmacro %}


{% macro trim_whitespace(column_name) %}
    trim({{ column_name }})
{% endmacro %}


-- macros/cleansing_macros.sql
{% macro remove_non_alphanumeric(column_name, allow_spaces=False) %}
    {% if target.type == 'snowflake' or target.type == 'postgres' or target.type == 'redshift' %}
        {% if allow_spaces %}
            regexp_replace({{ column_name }}, '[^a-zA-Z0-9 ]', '', 'g')
        {% else %}
            regexp_replace({{ column_name }}, '[^a-zA-Z0-9]', '', 'g')
        {% endif %}
    {% elif target.type == 'bigquery' %}
        {% if allow_spaces %}
            regexp_replace({{ column_name }}, r'[^a-zA-Z0-9 ]', '')
        {% else %}
            regexp_replace({{ column_name }}, r'[^a-zA-Z0-9]', '')
        {% endif %}
    {% else %}
        {{ exceptions.raise_compiler_error("remove_non_alphanumeric macro not implemented for " ~ target.type ~ ". Please add a database-specific implementation.") }}
    {% endif %}
{% endmacro %}


-- macros/cleansing_macros.sql
{% macro coalesce_nulls(column_name, default_value="'N/A'") %}
    coalesce({{ column_name }}, {{ default_value }})
{% endmacro %}


{% macro to_timestamp(column_name) %}
    cast({{ column_name }} as timestamp)
{% endmacro %}