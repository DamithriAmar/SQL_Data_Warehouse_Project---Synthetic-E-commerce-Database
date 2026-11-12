/*-------------------------------------------------------------------------------------------------
===================================================================================================
DDL script: Create bronze tables

Purpose: Create tables in the bronze schema
===================================================================================================
-------------------------------------------------------------------------------------------------*/

USE Synth_E_Commerce_Database;
GO

--=================================================================================================
-- Check if the bronze.customers table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.customers', 'U') IS NOT NULL
	DROP TABLE bronze.customers;
CREATE TABLE bronze.customers
(
		customer_id VARCHAR(50) NULL,
		first_name VARCHAR(50) NULL,
		last_name VARCHAR(50) NULL,
		email VARCHAR(50) NULL,
		phone VARCHAR(50) NULL,
		country VARCHAR(50) NULL,
		city VARCHAR(50) NULL,
		signup_date VARCHAR(50) NULL,
		loyalty_tier VARCHAR(50) NULL,
		marketing_opt_in VARCHAR(50) NULL	
);
PRINT 'bronze.customers TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.products table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.products', 'U') IS NOT NULL
	DROP TABLE bronze.products;
CREATE TABLE bronze.products
(
		product_id VARCHAR(50) NULL,
		sku VARCHAR(50) NULL,
		product_name VARCHAR(50) NULL,
		category VARCHAR(50) NULL,
		brand VARCHAR(50) NULL,
		unit_price VARCHAR(50) NULL,
		unit_cost VARCHAR(50) NULL,
		weight_kg VARCHAR(50) NULL,
		is_active VARCHAR(50) NULL,
		created_at VARCHAR(50) NULL
	
);
PRINT 'bronze.products TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.orders table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.orders', 'U') IS NOT NULL
	DROP TABLE bronze.orders;
CREATE TABLE bronze.orders
(
		order_id VARCHAR(50) NULL,
		customer_id VARCHAR(50) NULL,
		order_date VARCHAR(50) NULL,
		status VARCHAR(50) NULL,
		channel VARCHAR(50) NULL,
		subtotal VARCHAR(50) NULL,
		discount_amount VARCHAR(50) NULL,
		shipping_fee VARCHAR(50) NULL,
		tax_amount VARCHAR(50) NULL,
		total_amount VARCHAR(50) NULL,
		currency VARCHAR(50) NULL	
);
PRINT 'bronze.orders TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.order_items table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.order_items', 'U') IS NOT NULL
	DROP TABLE bronze.order_items;
CREATE TABLE bronze.order_items
(
		order_item_id VARCHAR(50) NULL,
		order_id VARCHAR(50) NULL,
		product_id VARCHAR(50) NULL,
		quantity VARCHAR(50) NULL,
		unit_price VARCHAR(50) NULL,
		line_total VARCHAR(50) NULL
);
PRINT 'bronze.order_items TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.payments table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.payments', 'U') IS NOT NULL
	DROP TABLE bronze.payments;
CREATE TABLE bronze.payments
(
		payment_id VARCHAR(50) NULL,
		order_id VARCHAR(50) NULL,
		method VARCHAR(50) NULL,
		amount VARCHAR(50) NULL,
		paid_at VARCHAR(50) NULL,
		status VARCHAR(50) NULL
);
PRINT 'bronze.payments TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.shipments table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.shipments', 'U') IS NOT NULL
	DROP TABLE bronze.shipments;
CREATE TABLE bronze.shipments
(
		shipment_id VARCHAR(50) NULL,
		order_id VARCHAR(50) NULL,
		carrier VARCHAR(50) NULL,
		tracking_number VARCHAR(50) NULL,
		shipped_at VARCHAR(50) NULL,
		delivered_at VARCHAR(50) NULL,
		status VARCHAR(50) NULL
);
PRINT 'bronze.shipments TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the bronze.returns table exists and
-- Drop it if already exists
IF OBJECT_ID ('bronze.returns', 'U') IS NOT NULL
	DROP TABLE bronze.returns;
CREATE TABLE bronze.returns
(
		return_id VARCHAR(50) NULL,
		order_item_id VARCHAR(50) NULL,
		reason VARCHAR(50) NULL,
		refund_amount VARCHAR(50) NULL,
		requested_at VARCHAR(50) NULL,
		status VARCHAR(50) NULL
);
PRINT 'bronze.returns TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
PRINT 'COMPLETED CREATING ALL THE BRONZE LAYER TABLES!!';
--=================================================================================================
