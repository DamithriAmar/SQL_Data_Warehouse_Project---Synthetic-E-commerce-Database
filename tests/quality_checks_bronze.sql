/*-------------------------------------------------------------------------------------------------
===================================================================================================
Tests for bronze layer tables
===================================================================================================
-------------------------------------------------------------------------------------------------*/

---------------------------------------------------------------------------------------------------
-- Testing bronze.customers
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.customers


-- Checking for NULL or empty customer_id
SELECT
	customer_id
FROM bronze.customers
WHERE customer_id IS NULL OR customer_id = ''


-- Checking duplicate customer_id
SELECT
	COUNT(*) AS duplicate_customer_id
FROM bronze.customers
HAVING (COUNT(customer_id)) > (SELECT DISTINCT COUNT(customer_id))


-- Checking for NULL or empty first_name
SELECT
	customer_id,
	first_name
FROM bronze.customers
WHERE TRIM(first_name) IS NULL OR TRIM(first_name) = ''


--  Checking for NULL or empty last_name
SELECT
	customer_id,
	last_name
FROM bronze.customers
WHERE TRIM(last_name) IS NULL OR TRIM(last_name) = '' OR LOWER(TRIM(last_name)) LIKE '%@example.com'


-- Checking the email format
SELECT *
FROM bronze.customers
WHERE LOWER(email) NOT LIKE '%@example.com'


-- Checking the phone
SELECT DISTINCT
	phone
FROM bronze.customers
WHERE TRIM(phone) NOT LIKE '+%'

-- Checking the latest and earlies signup_date
SELECT
	city,
	signup_date
FROM bronze.customers
ORDER BY city, signup_date


-- Checking the loyality tier
SELECT DISTINCT
	loyalty_tier
FROM bronze.customers

---------------------------------------------------------------------------------------------------
-- Testing bronze.products
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.products


-- Checking duplicate product_id
SELECT
	COUNT(product_id) - COUNT(DISTINCT product_id)
FROM bronze.products


-- Checking sku format
SELECT 
	sku
FROM bronze.products
WHERE TRIM(UPPER(sku)) NOT LIKE 'OUT-%'


-- Checking product_name
SELECT DISTINCT
	product_name
FROM bronze.products


-- Checking category
SELECT DISTINCT
	category
FROM bronze.products


-- Checking brand
SELECT DISTINCT
	brand
FROM bronze.products


-- Checking unit_price, unit_cost
SELECT
	product_id,
	unit_price,
	unit_cost
FROM bronze.products
WHERE CAST(unit_price AS FLOAT) < CAST(unit_cost AS FLOAT)


-- Checking is_active
SELECT DISTINCT
	is_active
FROM bronze.products

-- Checking created_at
SELECT DISTINCT
	created_at
FROM bronze.products
WHERE created_at NOT LIKE '2%'

---------------------------------------------------------------------------------------------------
-- Testing bronze.orders
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.orders


 -- Checking order_id
SELECT
	COUNT(*)
FROM bronze.orders
HAVING (COUNT(order_id)) > (COUNT(DISTINCT order_id))


-- Checking customer_id
SELECT
	COUNT(*)
FROM bronze.orders
HAVING (COUNT(customer_id)) > (COUNT(DISTINCT customer_id))


-- Checking order_date
SELECT
	order_date
FROM bronze.orders
WHERE order_date NOT LIKE '2%'


-- Checking the status
SELECT DISTINCT
	status
FROM BRONZE.orders

-- Checking the channels
SELECT DISTINCT
	channel
FROM bronze.orders

-- Checking the subtotal, discount_amount, shipping_fee, tax_amount, and total_amount
SELECT *
FROM (
    SELECT 
        TRY_CAST(REPLACE(REPLACE(total_amount, '$', ''), ',', '') AS DECIMAL(18, 2)) AS total_amounts,
        COALESCE(TRY_CAST(REPLACE(REPLACE(subtotal, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00)
        - COALESCE(TRY_CAST(REPLACE(REPLACE(discount_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00)
        + COALESCE(TRY_CAST(REPLACE(REPLACE(shipping_fee, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00)
        + COALESCE(TRY_CAST(REPLACE(REPLACE(tax_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_total_amount
    FROM bronze.orders
) t
WHERE ABS(new_total_amount - total_amounts) > 0
   OR total_amounts IS NULL;


-- Checking currency
SELECT DISTINCT
    currency
FROM bronze.orders

---------------------------------------------------------------------------------------------------
-- Testing bronze.order_items
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.order_items

-- Checking for nulls
SELECT *
FROM bronze.order_items
WHERE LOWER(order_item_id) IN('null') OR 
	  LOWER(order_id) IN('null') OR 
	  LOWER(product_id) IN('null') OR
	  LOWER(quantity) IN('null') OR
	  LOWER(unit_price) IN('null') OR
	  LOWER(line_total) IN('null')

-- Checking line_total
SELECT *
FROM
	(SELECT
		COALESCE(TRY_CAST(REPLACE(REPLACE(quantity, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_quantity,
		COALESCE(TRY_CAST(REPLACE(REPLACE(unit_price, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_unit_price,
		COALESCE(TRY_CAST(REPLACE(REPLACE(line_total, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_line_total
	FROM bronze.order_items)t
WHERE new_quantity * new_unit_price > new_line_total OR new_quantity * new_unit_price < new_line_total

---------------------------------------------------------------------------------------------------
-- Testing bronze.payments
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.payments


-- Checking for nulls
SELECT *
FROM bronze.payments
WHERE LOWER(payment_id) IN('null') OR
	  LOWER(order_id) IN('null') OR
	  LOWER(method) IN('null') OR
	  LOWER(amount) IN('null') OR
	  LOWER(paid_at) IN('null') OR
	  LOWER(status) IN('null')

-- Checking method
SELECT DISTINCT
	method
FROM bronze.payments


-- Checking status
SELECT DISTINCT
	status
FROM bronze.payments

---------------------------------------------------------------------------------------------------
-- Testing bronze.shipments
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.shipments


-- Checking for nulls
SELECT *
FROM bronze.shipments
WHERE LOWER(shipment_id) IN('null') OR 
	  LOWER(order_id) IN('null') OR 
	  LOWER(carrier) IN('null') OR
	  LOWER(tracking_number) IN('null') OR
	  LOWER(shipped_at) IN('null') OR
	  LOWER(delivered_at) IN('null') OR
	  LOWER(status) IN('null')


-- Checking duplicates
SELECT
	COUNT(shipment_id) - COUNT(DISTINCT shipment_id) AS dup_shipping_id,
	COUNT(order_id) - COUNT(DISTINCT order_id) AS dup_order_id,
	COUNT(tracking_number) - COUNT(DISTINCT tracking_number) AS dup_tracking_number
FROM bronze.shipments


-- Checking carrier
SELECT DISTINCT
	carrier
FROM bronze.shipments


-- Checking status
SELECT DISTINCT
	status
FROM bronze.shipments

-- Checking the dates
SELECT 
	shipped_at, 
	delivered_at
FROM bronze.shipments
WHERE SUBSTRING(shipped_at, 1, 10) NOT LIKE '____-__-__' OR
	  SUBSTRING(delivered_at, 1, 10) NOT LIKE '____-__-__'

SELECT DISTINCT
	delivered_at
FROM bronze.shipments
WHERE delivered_at NOT LIKE '%00:00:00'

---------------------------------------------------------------------------------------------------
-- Testing bronze.returns
---------------------------------------------------------------------------------------------------

SELECT *
FROM bronze.returns


-- Checking duplicates in ids
SELECT
	COUNT(return_id) - COUNT(DISTINCT return_id) AS dup_return_id,
	COUNT(order_item_id) - COUNT(DISTINCT order_item_id) AS dup_order_item_id
FROM bronze.returns


-- Checking reason
SELECT DISTINCT
	reason
FROM bronze.returns

-- Checking status
SELECT DISTINCT
	status
FROM bronze.returns


-- Checking for nulls
SELECT
	status
FROM bronze.returns
WHERE status IN('Null')
