WITH unified_products AS (
    SELECT
        l.inv_pk,
        s.brand,
        product_type,
        model_number,
        power_supply_type,
        pv_array_size_w,
        head_value_m,
        water_volume_m3_day,
        cash_price,
        COALESCE(i.ldts, e.ldts) AS load_datetime
    FROM processing.link_stock l
    LEFT JOIN processing.hub_product_inventory i
        ON l.inv_pk = i.inv_pk
    LEFT JOIN processing.sat_inventory s
        ON l.inv_pk = s.inv_pk
    LEFT JOIN processing.hub_product_erp e
        ON l.erp_pk = e.erp_pk
    LEFT JOIN processing.sat_market m
        ON l.erp_pk = m.erp_pk
)
SELECT * FROM unified_products;
