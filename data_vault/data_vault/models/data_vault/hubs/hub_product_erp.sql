{%- set yaml_metadata -%}
hashkey: 'ERP_PK'
business_keys: 'erp_id'
source_models: 'prep_product'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}