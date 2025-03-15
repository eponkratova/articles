{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        erp_id,
        REPLACE(
        REGEXP_REPLACE(
            REPLACE(brand, 'Pump', ''),   
            '[()]',                 
            ''
        ),
        ' ', '-'                      
        ) AS brand,
        cash_price,
        '2025-01-01' AS created_at,
        CURRENT_TIMESTAMP+1 AS modified_at,
        'erp_source' AS record_source
    FROM {{ source('raw_erp', 'products') }}
)
SELECT * FROM source_data

