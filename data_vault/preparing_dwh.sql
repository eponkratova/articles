
-- Create schemas
create schema raw_inventory;
create schema raw_erp;
create schema processing;

-- Create the stock table
CREATE TABLE raw_inventory.stock (
    inv_id                VARCHAR(20)    NOT NULL,   
    brand                 VARCHAR(100),
    product_type          VARCHAR(100),
    model_number          VARCHAR(100),
    power_supply_type     VARCHAR(50),
    pv_array_size_w       NUMERIC(10, 0),  
    head_value_m          NUMERIC(10, 0),  
    water_volume_m3_day   NUMERIC(10, 1),  
    PRIMARY KEY (inv_id)
);

-- Create the ERP table
CREATE TABLE raw_erp.products (
    erp_id      NUMERIC(10, 0) NOT NULL,  
    brand       VARCHAR(100),
    cash_price  NUMERIC(10, 2),          
    PRIMARY KEY (erp_id)
);

-- Load the stock data
INSERT INTO raw_inventory.stock (
    inv_id,
    brand,
    product_type,
    model_number,
    power_supply_type,
    pv_array_size_w,
    head_value_m,
    water_volume_m3_day
)
VALUES
('PU1', 'Simusolar-Kina', 'Submersible Pump', 'Kina', 'DC', 2250, 80, 13.5),
('PU2', 'Sunculture-2SP', 'Surface Pump', '2SP', 'DC', 420, 10, 11.5),
('PU3', 'Amped Innovation-WOWsolar Pump', 'Surface Pump', 'WOWsolar Pump', 'DC', 80, 6, 5.9),
('PU4', 'Solartech', 'Submersible Pump', 'SPM600HS', 'DC', 600, 40, 14.2);

-- Load the market info data
INSERT INTO raw_erp.products (
    erp_id,
    brand,
    cash_price
)
VALUES
(1001, 'Simusolar-Kina', 1500),
(1002, 'Sunculture (2SP)', 1000),
(1003, 'Amped Innovation (WOWsolar)', 600),
(1004, 'Ecozen Solutions (HP- 50 m)', 1000);

