/*-------------------------------------------------------------------------------------------------
===================================================================================================
Stored Procedure: Load the silver layer

Purpose: Cleanses and inserts date from the tables of the bronze layer.
         Performs TRUNCATE and INSERT commands to load the data to the tables.

How to execute:
		EXEC silver.load_silver
===================================================================================================
-------------------------------------------------------------------------------------------------*/

USE Synth_E_Commerce_Database;
GO

--=================================================================================================
-- Create the stored procedure or
-- Re-load data into already existing tables
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

-- Declare time variables to calculate the duration of operations
	DECLARE @start_time DATETIME, @end_time DATETIME, 
			@load_start_time DATETIME, @load_end_time DATETIME

-- Start the TRY clause
BEGIN TRY
	PRINT '========================================================='
	PRINT 'STARTED LOADING SILVER LAYER!!'
	PRINT '========================================================='

	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.customers'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @load_start_time = GETDATE();
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.customers';
	TRUNCATE TABLE silver.customers ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.customers ';
	INSERT INTO silver.customers (
		customer_id,
		first_name,
		last_name,
		email,
		phone,
		country,
		city,
		signup_date,
		loyalty_tier,
		marketing_opt_in 
	)

-- Cleansing bronze.customers table
	SELECT 
	new_customer_id,
	new_first_name,
	new_last_name,
	new_email,
	new_phone,

	-- Creating new_country
	CASE WHEN CHARINDEX(',', new_address) > 0  THEN SUBSTRING(new_address, 1, (CHARINDEX(',', new_address)-1))
		 ELSE 'unknown'
	END AS new_country,

	-- Creating the new_city
	CASE WHEN new_city_02 LIKE 'unknown' THEN new_address
		 ELSE new_city_02
	END AS new_city,

	new_signup_date,
	new_loyalty_tier,
	new_marketing_opt_in
	FROM
		(SELECT *,
			-- Cleaning the address
			CAST(CASE WHEN address LIKE '%, unknown' THEN REPLACE(address, ', unknown', '')
				 ELSE address
			END AS NVARCHAR) AS new_address
		FROM
			(SELECT *,
				-- Casting customer_id
				CAST(customer_id AS INT) AS new_customer_id,
				-- Creating the address
				CONCAT(country, ', ', new_city_02) AS address
			FROM
				(SELECT *,
				-- Cleaning the first_name
					CASE WHEN TRIM(first_name) IS NULL THEN ''
						 ELSE TRIM(first_name)
					END AS new_first_name,

				-- Cleaning the last_name
					CASE WHEN TRIM(last_name) IS NULL OR TRIM(last_name) LIKE '%@example.com' THEN ''
						 ELSE TRIM(last_name)
					END AS new_last_name,

				-- Cleaning the email
					CASE WHEN LOWER(TRIM(last_name)) LIKE '%@example.com' THEN  LOWER(TRIM(last_name))
						 WHEN TRIM(email) IS NULL THEN 'unknown'
						 ELSE LOWER(TRIM(email))
					END AS new_email,

				-- Cleaning the phone
					CASE WHEN TRIM(phone) NOT LIKE '+%' OR TRIM(phone) IS NULL THEN 'unknown'
						 ELSE REPLACE(REPLACE(phone, '-', ''), ' ', '')
					END AS new_phone,

				-- Cleaning the city
					CASE WHEN TRIM(city) LIKE '2%' OR TRIM(city) IS NULL THEN 'unknown'
						 ELSE TRIM(city)
					END AS new_city_02,

				-- Cleaning the signup_date
					CAST(CASE WHEN TRIM(signup_date) NOT LIKE '2%' THEN city
						 WHEN TRIM(signup_date) IS NULL THEN 'unknown'
						 ELSE TRIM(signup_date)
					END AS DATE) AS new_signup_date,

				-- Cleaning the loyalty_tier
					CASE WHEN LOWER(TRIM(loyalty_tier)) NOT IN ('none', 'silver', 'gold', 'platinum') THEN 'none'
						 ELSE LOWER(TRIM(loyalty_tier))
					END AS new_loyalty_tier,

				-- Cleaning the marketing_opt_in
					CASE WHEN marketing_opt_in NOT IN ('0', '1') THEN loyalty_tier
						 ELSE marketing_opt_in
					END AS new_marketing_opt_in
				FROM bronze.customers)t)t1)t2;

	PRINT '<<<< COMPLETED LOADING TABLE: silver.customers';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.products'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.products';
	TRUNCATE TABLE silver.products ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.products';
	INSERT INTO silver.products (
		product_id,
		sku,
		product_name,
		product_color,
		category,
		brand,
		unit_price,
		unit_cost,
		weight_kg,
		is_active,
		created_at
	)

-- Cleansing bronze.products table
	SELECT
		-- Casting product_id
		CAST(product_id AS INT) AS new_product_id,

		sku,

		-- Creating new_product_name
		CASE WHEN CHARINDEX('(', product_name) > 0 
			 THEN SUBSTRING(product_name, 1, CHARINDEX('(', product_name) - 1)
			 ELSE 'unknown'
		END AS new_product_name,

		-- Creating the product_color
		CASE WHEN CHARINDEX('(', product_name) > 0 
			 THEN SUBSTRING(
					product_name, 
					(CHARINDEX('(', product_name)+1),
					CHARINDEX(')', product_name) - CHARINDEX('(', product_name) - 1)
			 ELSE 'unknown'
		END AS product_color,

		category,
		brand,

		-- Casting unit_price and unit_cost
		CAST(unit_price AS FLOAT) AS new_unit_price,
		CAST(unit_cost AS FLOAT) AS new_unit_cost,

		-- Cleaning wight_kg
		CAST(CASE WHEN is_active LIKE '2%' THEN NULL
			 ELSE weight_kg
		END AS FLOAT) AS new_weight_kg,

		-- Cleaning is_active
		CASE WHEN is_active LIKE '2%' THEN weight_kg
			 ELSE is_active
		END AS new_is_active,

		-- Cleaning created_at
		CAST(CASE WHEN created_at IN('Null') THEN is_active
			 ELSE created_at
		END AS DATE) AS new_created_at
	FROM bronze.products

	PRINT '<<<< COMPLETED LOADING TABLE: silver.products';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.order_items'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.order_items';
	TRUNCATE TABLE silver.order_items ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.order_items';
	INSERT INTO silver.order_items (
		order_item_id,
		order_id,
		product_id,
		quantity,
		unit_price,
		line_total
	)

-- Cleansing bronze.order_items table
	SELECT
		-- Casting order_item_id, product_id, order_id, quantity, unit_price, and line_total
		CAST(order_item_id AS INT) AS new_order_item_id,
		CAST(order_id AS INT) AS new_order_id,
		CAST(product_id AS INT) AS new_product_id,
		COALESCE(TRY_CAST(REPLACE(REPLACE(quantity, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_quantity,
		COALESCE(TRY_CAST(REPLACE(REPLACE(unit_price, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_unit_price,
		COALESCE(TRY_CAST(REPLACE(REPLACE(line_total, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_line_total
	FROM bronze.order_items

	PRINT '<<<< COMPLETED LOADING TABLE: silver.order_items';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.payments'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.payments';
	TRUNCATE TABLE silver.payments ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.payments';
	INSERT INTO silver.payments (
		payment_id,
		order_id,
		method,
		amount,
		paid_at,
		status
	)

-- Cleansing bronze.payments table
	SELECT
		-- Casting payment_id and order_id
		CAST(payment_id AS INT) AS new_payment_id,
		CAST(order_id AS INT) AS new_order_id,

		method, 

		-- Casting amount
		COALESCE(TRY_CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_amount,

		-- Casting paid_at
		CAST(paid_at AS DATETIME) AS new_paid_at,

		status
	FROM bronze.payments

	PRINT '<<<< COMPLETED LOADING TABLE: silver.payments';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.orders'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.orders';
	TRUNCATE TABLE silver.orders ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.orders';
	INSERT INTO silver.orders (
		order_id,
		customer_id,
		order_date,
		status,
		channel,
		subtotal,
		discount_amount,
		shipping_fee,
		tax_amount,
		total_amount,
		currency
	)

-- Cleansing bronze.orders table
	SELECT
		-- Casting the order_id and customer_id
		CAST(order_id AS INT) AS new_order_id,
		CAST(customer_id AS INT) AS new_customer_id,

		-- Casting order_date
		CAST(order_date AS DATETIME) AS new_order_date,

		status,
		channel,

		-- Casting subtotal, discount_amount, shipping_fee, tax_amount, and total_amount
		COALESCE(TRY_CAST(REPLACE(REPLACE(subtotal, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_subtotal,
		COALESCE(TRY_CAST(REPLACE(REPLACE(discount_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_dicount_amount,
		COALESCE(TRY_CAST(REPLACE(REPLACE(shipping_fee, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_shipping_fee,
		COALESCE(TRY_CAST(REPLACE(REPLACE(tax_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_tax_amount,
		COALESCE(TRY_CAST(REPLACE(REPLACE(total_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_total_amount,
    
		currency
	FROM bronze.orders

	PRINT '<<<< COMPLETED LOADING TABLE: silver.orders';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.shipments'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.shipments';
	TRUNCATE TABLE silver.shipments ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.shipments';
	INSERT INTO silver.shipments (
		shipment_id,
		order_id,
		carrier,
		tracking_number,
		shipped_at,
		delivered_at,
		status
	)

-- Cleansing bronze.shipments table
	SELECT
		-- Casting shipment_id and order_id
		CAST(shipment_id AS INT) AS new_shipment_id,
		CAST(order_id AS INT) AS new_order_id,

		carrier,

		-- Cleaning tracking_number
		UPPER(tracking_number) AS new_tracking_number,

		-- Cleaning shipped_at and delivered_at
		CAST(SUBSTRING(shipped_at, 1, 10) AS DATE) AS new_shipped_at,
	
		CASE WHEN delivered_at NOT LIKE '2%' THEN NULL
			 ELSE CAST(delivered_at AS DATETIME)
		END AS new_delivered_at,

		-- Cleaning status
		CASE WHEN UPPER(status) IN('NULL') THEN delivered_at
			 ELSE status
		END AS new_shipment_status
	FROM bronze.shipments

	PRINT '<<<< COMPLETED LOADING TABLE: silver.shipments';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: silver.returns'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: silver.returns';
	TRUNCATE TABLE silver.returns;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: silver.returns';
	INSERT INTO silver.returns (
		return_id,
		order_item_id,
		reason,
		refund_amount,
		requested_at,
		status
	)

-- Cleansing bronze.returns table
	SELECT
		-- Casting return_id, order_item_id
		CAST(return_id AS INT) AS new_return_id,
		CAST(order_item_id AS INT) AS new_order_item_id,

		reason,

		-- Casting refund_amount
		COALESCE(TRY_CAST(REPLACE(REPLACE(refund_amount, '$', ''), ',', '') AS DECIMAL(18, 2)), 0.00) AS new_refund_amount,

		-- Casting requested_at
		CAST(requested_at AS DATETIME) AS new_requested_at,

		status
	FROM bronze.returns

	PRINT '<<<< COMPLETED LOADING TABLE: silver.returns';

-- Assign the ending time variables
	SET @end_time = GETDATE();
	SET @load_end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

	PRINT '========================================================='
	PRINT 'FINISHED LOADING SILVER LAYER!!'
	PRINT '========================================================='

-- Calculate the load duration
	PRINT 'TOTAL SILVER LAYER LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @load_start_time, @load_end_time) AS NVARCHAR) + 's';
END TRY

-- Start the CATCH clause
BEGIN CATCH
	PRINT '===========================================================================';
	PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
	PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '===========================================================================';
END CATCH;
END;
--=================================================================================================
