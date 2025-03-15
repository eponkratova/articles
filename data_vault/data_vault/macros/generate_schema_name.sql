{% macro generate_schema_name(custom_schema_name=None, node=None) -%}
    {%- set default_schema = target.schema -%}
    {%- if target.name == "dev" -%}
        {{ default_schema }}
    {%- else -%}
        {{ (custom_schema_name | default('')) | trim }}
    {%- endif -%}
{%- endmacro %}
