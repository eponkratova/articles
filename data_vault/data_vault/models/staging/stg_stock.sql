{{ config(materialized='view') }}

WITH source_product_data as (
    select erp_id,
           brand
    from {{ ref('stg_product') }} 
),
source_stock_data AS (
    SELECT
        inv_id,
        REPLACE(
        REGEXP_REPLACE(
            REPLACE(brand, 'Pump', ''),   
            '[()]',                 
            ''
        ),
        ' ', '-'                      
        ) AS brand,
        product_type,
        model_number,
        power_supply_type,
        pv_array_size_w,
        head_value_m,
        water_volume_m3_day,
        '2025-01-01' AS created_at,
        CURRENT_TIMESTAMP AS modified_at,
        'inventory_source' AS record_source
    FROM {{ source('raw_inventory', 'stock') }}
)

SELECT sp.erp_id, ss.* FROM source_stock_data ss
left join source_product_data sp on ss.brand = sp.brand
