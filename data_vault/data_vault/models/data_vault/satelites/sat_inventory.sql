{%- set yaml_metadata -%}
parent_hashkey: 'INV_PK'
src_hashdiff: 'INV_HASHDIFF'
src_payload:
    - "brand"
    - "product_type"
    - "model_number"
    - "power_supply_type"
    - "pv_array_size_w"
    - "head_value_m"
    - "water_volume_m3_day"
source_model: 'prep_stock'
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set parent_hashkey = metadata_dict['parent_hashkey'] -%}
{%- set src_hashdiff = metadata_dict['src_hashdiff'] -%}
{%- set source_model = metadata_dict['source_model'] -%}
{%- set src_payload = metadata_dict['src_payload'] -%}


{{ datavault4dbt.sat_v0(parent_hashkey=parent_hashkey,
                        src_hashdiff=src_hashdiff,
                        source_model=source_model,
                        src_payload=src_payload) }}