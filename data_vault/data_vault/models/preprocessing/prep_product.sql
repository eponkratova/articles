{%- set yaml_metadata -%}
source_model: 'stg_product'
ldts: 'created_at'
--rsrc: '!ERP_PRODUCTS'
rsrc: record_source
hashed_columns: 
    ERP_PK: "erp_id"
    ERP_HASHDIFF:
      is_hashdiff: true
      columns:
        - "brand"
        - "cash_price"
derived_columns:
    EFFECTIVE_FROM: "modified_at"
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set derived_columns = metadata_dict['derived_columns'] -%}

{{ datavault4dbt.stage(source_model=source_model,
                    ldts=ldts,
                    rsrc=rsrc,
                    hashed_columns=hashed_columns,
                    derived_columns=derived_columns,
                    prejoined_columns=none,
                    missing_columns=none,
                    multi_active_config=none) }}