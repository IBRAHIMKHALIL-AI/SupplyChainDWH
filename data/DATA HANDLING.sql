-- 1. Create the Database
CREATE DATABASE supplychaindwh;

-- Connect to the database (if using psql)
-- \c supplychaindwh;

-- 2. Create the Bronze Schema
CREATE SCHEMA bronze;


CREATE TABLE bronze.customers (
    "Customer Id" VARCHAR,
    "Customer Fname" VARCHAR,
    "Customer Lname" VARCHAR,
    "Customer Email" VARCHAR,
    "Customer Password" VARCHAR,
    "Customer Segment" VARCHAR,
    "Customer City" VARCHAR,
    "Customer State" VARCHAR,
    "Customer Street" VARCHAR,
    "Customer Zipcode" VARCHAR,
    "Customer Country" VARCHAR,
    "Latitude" VARCHAR,
    "Longitude" VARCHAR,
    "Customer Birth Date" VARCHAR
);

CREATE TABLE bronze.products (
    "Product Card Id" VARCHAR,
    "Product Name" VARCHAR,
    "Product Price" VARCHAR,
    "Product Status" VARCHAR,
    "Product Description" VARCHAR,
    "Category Id" VARCHAR,
    "Category Name" VARCHAR,
    "Department Id" VARCHAR,
    "Department Name" VARCHAR
);

CREATE TABLE bronze.salesman (
    "Salesman Id" VARCHAR,
    "Salesman Fname" VARCHAR,
    "Salesman Lname" VARCHAR,
    "Salesman Email" VARCHAR,
    "Market" VARCHAR,
    "Region" VARCHAR,
    "Hire Date" VARCHAR,
    "Commission Rate" VARCHAR
);

CREATE TABLE bronze.orders (
    "Order Id" VARCHAR,
    "Order Item Id" VARCHAR,
    "Customer Id" VARCHAR,
    "Product Card Id" VARCHAR,
    "Type" VARCHAR,
    "Days for shipping (real)" VARCHAR,
    "Days for shipment (scheduled)" VARCHAR,
    "Benefit per order" VARCHAR,
    "Delivery Status" VARCHAR,
    "Late_delivery_risk" VARCHAR,
    "Market" VARCHAR,
    "Order Region" VARCHAR,
    "Order State" VARCHAR,
    "Order Status" VARCHAR,
    "Order Zipcode" VARCHAR,
    "order date (DateOrders)" VARCHAR,
    "shipping date (DateOrders)" VARCHAR,
    "Shipping Mode" VARCHAR,
    "Order Item Discount" VARCHAR,
    "Order Item Profit Ratio" VARCHAR,
    "Order Item Quantity" VARCHAR,
    "Order Item Total" VARCHAR,
    "salesman_id" VARCHAR
);



COPY bronze.customers
FROM 'C:\Users\hemak\Instant\DWH2\data\Customers.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.products
FROM 'C:\Users\hemak\Instant\DWH2\data\Products.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.salesman
FROM 'C:\Users\hemak\Instant\DWH2\data\Salesman.csv'
DELIMITER ','
CSV HEADER;

COPY bronze.orders
FROM 'C:\Users\hemak\Instant\DWH2\data\Orders.csv'
DELIMITER ','
CSV HEADER;


SELECT 'Customers' AS table_name, COUNT(*) AS row_count FROM bronze.customers
UNION ALL
SELECT 'Products', COUNT(*) FROM bronze.products
UNION ALL
SELECT 'Salesman', COUNT(*) FROM bronze.salesman
UNION ALL
SELECT 'Orders', COUNT(*) FROM bronze.orders;

CREATE SCHEMA silver;
-- 1. Silver Customers
CREATE TABLE silver.customers AS
SELECT 
    CAST("Customer Id" AS INTEGER) AS customer_id,
    TRIM("Customer Fname") AS customer_fname,
    TRIM("Customer Lname") AS customer_lname,
    TRIM("Customer Email") AS customer_email,
    "Customer Password" AS customer_password,
    TRIM("Customer Segment") AS customer_segment,
    TRIM("Customer City") AS customer_city,
    TRIM("Customer State") AS customer_state,
    TRIM("Customer Street") AS customer_street,
    TRIM("Customer Zipcode") AS customer_zipcode, -- Kept as string to preserve leading zeros
    TRIM("Customer Country") AS customer_country,
    CAST("Latitude" AS NUMERIC) AS latitude,
    CAST("Longitude" AS NUMERIC) AS longitude,
    CAST("Customer Birth Date" AS DATE) AS customer_birth_date
FROM bronze.customers;

-- 2. Silver Products
-- (We omit "Product Description" entirely here because it is 100% NULL)
CREATE TABLE silver.products AS
SELECT 
    CAST("Product Card Id" AS INTEGER) AS product_card_id,
    TRIM("Product Name") AS product_name,
    CAST("Product Price" AS NUMERIC(10,2)) AS product_price,
    CAST("Product Status" AS INTEGER) AS product_status,
    CAST("Category Id" AS INTEGER) AS category_id,
    TRIM("Category Name") AS category_name,
    CAST("Department Id" AS INTEGER) AS department_id,
    TRIM("Department Name") AS department_name
FROM bronze.products;

-- 3. Silver Salesman
CREATE TABLE silver.salesman AS
SELECT 
    CAST("Salesman Id" AS INTEGER) AS salesman_id,
    TRIM("Salesman Fname") AS salesman_fname,
    TRIM("Salesman Lname") AS salesman_lname,
    TRIM("Salesman Email") AS salesman_email,
    TRIM(UPPER("Market")) AS market, -- UPPER applied to standardize casing
    TRIM(UPPER("Region")) AS region,
    CAST("Hire Date" AS DATE) AS hire_date,
    CAST("Commission Rate" AS NUMERIC(5,4)) AS commission_rate
FROM bronze.salesman;

CREATE TABLE silver.orders AS
SELECT 
    CAST("Order Id" AS INTEGER) AS order_id,
    CAST("Order Item Id" AS INTEGER) AS order_item_id,
    CAST("Customer Id" AS INTEGER) AS customer_id,
    CAST("Product Card Id" AS INTEGER) AS product_card_id,
    CAST("salesman_id" AS INTEGER) AS salesman_id,
    
    -- Categorical Standardization (Cleans invisible spaces and forces uppercase)
    TRIM(UPPER("Type")) AS order_type,
    TRIM(UPPER("Delivery Status")) AS delivery_status,
    TRIM(UPPER("Order Status")) AS order_status,
    TRIM(UPPER("Market")) AS market,
    
    -- Shipping Mode Standardization (Resolves spelling/abbreviation anomalies)
    CASE 
        WHEN TRIM(UPPER("Shipping Mode")) IN ('STD CLASS', 'STANDARD CLASS', 'STANDARD', 'STANDARD  CLASS') THEN 'STANDARD CLASS'
        WHEN TRIM(UPPER("Shipping Mode")) IN ('1ST CLASS', 'FIRST CLASS', 'FIRST  CLASS') THEN 'FIRST CLASS'
        WHEN TRIM(UPPER("Shipping Mode")) IN ('2ND CLASS', 'SECOND CLASS', 'SECOND  CLASS') THEN 'SECOND CLASS'
        WHEN TRIM(UPPER("Shipping Mode")) IN ('SAME DAY', 'SAME-DAY', 'SAME  DAY') THEN 'SAME DAY'
        ELSE TRIM(UPPER("Shipping Mode"))
    END AS shipping_mode,

    -- Dates
    CAST("order date (DateOrders)" AS TIMESTAMP) AS order_date,
    CAST("shipping date (DateOrders)" AS TIMESTAMP) AS shipping_date,
    
    -- Numeric Metrics
    CAST("Days for shipping (real)" AS INTEGER) AS days_for_shipping_real,
    CAST("Days for shipment (scheduled)" AS INTEGER) AS days_for_shipment_scheduled,
    CAST("Benefit per order" AS NUMERIC) AS benefit_per_order,
    CAST("Late_delivery_risk" AS INTEGER) AS late_delivery_risk,
    CAST("Order Item Discount" AS NUMERIC) AS order_item_discount,
    CAST("Order Item Profit Ratio" AS NUMERIC) AS order_item_profit_ratio,
    CAST("Order Item Quantity" AS INTEGER) AS order_item_quantity,
    CAST("Order Item Total" AS NUMERIC) AS order_item_total,
    
    -- Location Details
    TRIM("Order Region") AS order_region,
    TRIM("Order State") AS order_state,
    TRIM("Order Zipcode") AS order_zipcode 
FROM bronze.orders;


CREATE SCHEMA gold;

-- 1. Gold DimCustomers
CREATE TABLE gold.dim_customers AS
SELECT 
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment,
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode
FROM silver.customers;

-- 2. Gold DimProducts
CREATE TABLE gold.dim_products AS
SELECT 
    product_card_id,
    product_name,
    product_price,
    category_name,
    department_name
FROM silver.products;

-- 3. Gold DimSalesman
CREATE TABLE gold.dim_salesman AS
SELECT 
    salesman_id,
    salesman_fname,
    salesman_lname,
    market,
    region,
    commission_rate
FROM silver.salesman;

-- 4. Gold DimDate (Generated dynamically)
CREATE TABLE gold.dim_date AS
SELECT 
    CAST(TO_CHAR(datum, 'YYYYMMDD') AS INTEGER) AS date_key,
    datum AS full_date,
    EXTRACT(YEAR FROM datum) AS year,
    EXTRACT(QUARTER FROM datum) AS quarter,
    EXTRACT(MONTH FROM datum) AS month,
    TRIM(TO_CHAR(datum, 'Month')) AS month_name,
    EXTRACT(DAY FROM datum) AS day,
    EXTRACT(ISODOW FROM datum) AS day_of_week,
    TRIM(TO_CHAR(datum, 'Day')) AS day_name
FROM (
    -- Generates a continuous sequence of dates to cover all possible order/shipping dates
    SELECT datum::DATE 
    FROM generate_series(
        '2014-01-01'::DATE, 
        '2026-12-31'::DATE, 
        '1 day'::INTERVAL
    ) datum
) d;

CREATE TABLE gold.fact_orders AS
SELECT 
    order_item_id,
    order_id,
    customer_id,
    product_card_id,
    salesman_id,
    
    -- Date Keys for DimDate
    CAST(TO_CHAR(order_date, 'YYYYMMDD') AS INTEGER) AS order_date_key,
    CAST(TO_CHAR(shipping_date, 'YYYYMMDD') AS INTEGER) AS shipping_date_key,
    
    -- Degenerate Dimensions (Categorical data kept in the fact table)
    order_type,
    delivery_status,
    order_status,
    market,
    shipping_mode,
    
    -- Metrics / Facts
    days_for_shipping_real,
    days_for_shipment_scheduled,
    benefit_per_order,
    late_delivery_risk,
    order_item_discount,
    order_item_profit_ratio,
    order_item_quantity,
    order_item_total
FROM silver.orders;


-- Add Primary Keys to Dimensions
ALTER TABLE gold.dim_customers ADD PRIMARY KEY (customer_id);
ALTER TABLE gold.dim_products ADD PRIMARY KEY (product_card_id);
ALTER TABLE gold.dim_salesman ADD PRIMARY KEY (salesman_id);
ALTER TABLE gold.dim_date ADD PRIMARY KEY (date_key);

-- Add Primary Key to Fact Table
ALTER TABLE gold.fact_orders ADD PRIMARY KEY (order_item_id);

-- Add Foreign Keys to Fact Table
ALTER TABLE gold.fact_orders 
    ADD CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id) REFERENCES gold.dim_customers (customer_id);

ALTER TABLE gold.fact_orders 
    ADD CONSTRAINT fk_fact_product FOREIGN KEY (product_card_id) REFERENCES gold.dim_products (product_card_id);

ALTER TABLE gold.fact_orders 
    ADD CONSTRAINT fk_fact_salesman FOREIGN KEY (salesman_id) REFERENCES gold.dim_salesman (salesman_id);

ALTER TABLE gold.fact_orders 
    ADD CONSTRAINT fk_fact_order_date FOREIGN KEY (order_date_key) REFERENCES gold.dim_date (date_key);

ALTER TABLE gold.fact_orders 
    ADD CONSTRAINT fk_fact_shipping_date FOREIGN KEY (shipping_date_key) REFERENCES gold.dim_date (date_key);

-- Create Indexes on Foreign Keys for Performance
CREATE INDEX idx_fact_customer ON gold.fact_orders(customer_id);
CREATE INDEX idx_fact_product ON gold.fact_orders(product_card_id);
CREATE INDEX idx_fact_salesman ON gold.fact_orders(salesman_id);
CREATE INDEX idx_fact_order_date ON gold.fact_orders(order_date_key);
CREATE INDEX idx_fact_shipping_date ON gold.fact_orders(shipping_date_key);



-- 1. Check Gold Row Counts (Should match your Bronze/Silver counts)
SELECT 'DimCustomers' AS table_name, COUNT(*) AS row_count FROM gold.dim_customers
UNION ALL
SELECT 'DimProducts', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'DimSalesman', COUNT(*) FROM gold.dim_salesman
UNION ALL
SELECT 'FactOrders', COUNT(*) FROM gold.fact_orders;

-- 2. Verify Referential Integrity (Should return 0)
SELECT COUNT(*) AS orphan_orders
FROM gold.fact_orders f
LEFT JOIN gold.dim_customers c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;




-- Clean the Market column in the Fact table
UPDATE gold.fact_orders
SET market = CASE 
    -- REPLACE() removes any hidden double spaces before matching
    WHEN REPLACE(market, '  ', ' ') IN ('AFR', 'AFRICA') THEN 'Africa'
    WHEN REPLACE(market, '  ', ' ') IN ('APAC', 'ASIA-PACIFIC', 'PACIFIC ASIA') THEN 'Asia Pacific'
    WHEN REPLACE(market, '  ', ' ') IN ('EU', 'EUROPE') THEN 'Europe'
    WHEN REPLACE(market, '  ', ' ') IN ('LATAM', 'LATIN AMERICA') THEN 'LATAM'
    WHEN REPLACE(market, '  ', ' ') IN ('USCA', 'U.S.-CANADA', 'US & CANADA', 'US AND CANADA') THEN 'USCA'
    ELSE REPLACE(market, '  ', ' ')
END;

-- Clean the Market column in the Salesman dimension
UPDATE gold.dim_salesman
SET market = CASE 
    WHEN REPLACE(market, '  ', ' ') IN ('AFR', 'AFRICA') THEN 'Africa'
    WHEN REPLACE(market, '  ', ' ') IN ('APAC', 'ASIA-PACIFIC', 'PACIFIC ASIA') THEN 'Asia Pacific'
    WHEN REPLACE(market, '  ', ' ') IN ('EU', 'EUROPE') THEN 'Europe'
    WHEN REPLACE(market, '  ', ' ') IN ('LATAM', 'LATIN AMERICA') THEN 'LATAM'
    WHEN REPLACE(market, '  ', ' ') IN ('USCA', 'U.S.-CANADA', 'US & CANADA', 'US AND CANADA') THEN 'USCA'
    ELSE REPLACE(market, '  ', ' ')
END;


UPDATE gold.fact_orders
SET delivery_status = TRIM(REPLACE(UPPER(delivery_status), '  ', ' '));