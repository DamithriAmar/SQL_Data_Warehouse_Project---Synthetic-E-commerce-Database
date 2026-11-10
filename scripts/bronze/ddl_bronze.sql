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
		customer_id INT,
		first_name VARCHAR(50),
		last_name VARCHAR(50),
		email VARCHAR(50),
		phone VARCHAR(50),
		country VARCHAR(50),
		city VARCHAR(50),
		signup_date DATE,
		loyalty_tier VARCHAR(50),
		marketing_opt_in VARCHAR(50)	
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
		product_id INT,
		sku VARCHAR(50),
		product_name VARCHAR(50),
		category VARCHAR(50),
		brand VARCHAR(50),
		unit_price FLOAT,
		unit_cost FLOAT,
		weight_kg FLOAT,
		is_active VARCHAR(50),
		created_at DATE
	
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
		order_id INT,
		customer_id INT,
		order_date DATETIME,
		status VARCHAR(50),
		channel VARCHAR(50),
		subtotal FLOAT,
		discount_amount FLOAT,
		shipping_fee FLOAT,
		tax_amount FLOAT,
		total_amount FLOAT,
		currency VARCHAR(50)	
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
		order_item_id INT,
		order_id INT,
		product_id INT,
		quantity INT,
		unit_price FLOAT,
		line_total FLOAT
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
		payment_id INT,
		order_id INT,
		method VARCHAR(50),
		amount FLOAT,
		paid_at DATETIME,
		status VARCHAR(50)
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
		shipment_id INT,
		order_id INT,
		carrier VARCHAR(50),
		tracking_number VARCHAR(50),
		shipped_at DATETIME,
		delivered_at DATETIME,
		status VARCHAR(50)
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
		return_id INT,
		order_item_id INT,
		reason VARCHAR(50),
		refund_amount FLOAT,
		requested_at DATETIME,
		status VARCHAR(50)
);
PRINT 'bronze.returns TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
PRINT 'COMPLETED CREATING ALL THE BRONZE LAYER TABLES!!';
--=================================================================================================
