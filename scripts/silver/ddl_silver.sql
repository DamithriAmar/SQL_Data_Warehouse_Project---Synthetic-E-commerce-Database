/*-------------------------------------------------------------------------------------------------
===================================================================================================
DDL script: Create silver tables

Purpose: Create tables in the silver schema
===================================================================================================
-------------------------------------------------------------------------------------------------*/

USE Synth_E_Commerce_Database;
GO

--=================================================================================================
-- Check if the silver.customers table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.customers', 'U') IS NOT NULL
	DROP TABLE silver.customers;
CREATE TABLE silver.customers
(
		customer_id INT,
		first_name VARCHAR(50) ,
		last_name VARCHAR(50) ,
		email VARCHAR(50) ,
		phone VARCHAR(50) ,
		country VARCHAR(50) ,
		city VARCHAR(50) ,
		signup_date DATE ,
		loyalty_tier VARCHAR(50) ,
		marketing_opt_in VARCHAR(50) ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.customers TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.products table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.products', 'U') IS NOT NULL
	DROP TABLE silver.products;
CREATE TABLE silver.products
(
		product_id INT ,
		sku VARCHAR(50) ,
		product_name VARCHAR(50) ,
		product_color VARCHAR(50) ,
		category VARCHAR(50) ,
		brand VARCHAR(50) ,
		unit_price FLOAT ,
		unit_cost FLOAT ,
		weight_kg VARCHAR(50) ,
		is_active VARCHAR(50) ,
		created_at DATE ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
	
);
PRINT 'silver.products TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.orders table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.orders', 'U') IS NOT NULL
	DROP TABLE silver.orders;
CREATE TABLE silver.orders
(
		order_id INT ,
		customer_id INT ,
		order_date DATETIME ,
		status VARCHAR(50) ,
		channel VARCHAR(50) ,
		subtotal FLOAT ,
		discount_amount FLOAT ,
		shipping_fee FLOAT ,
		tax_amount FLOAT ,
		total_amount FLOAT ,
		currency VARCHAR(50) ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.orders TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.order_items table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.order_items', 'U') IS NOT NULL
	DROP TABLE silver.order_items;
CREATE TABLE silver.order_items
(
		order_item_id INT ,
		order_id INT ,
		product_id INT ,
		quantity FLOAT ,
		unit_price FLOAT ,
		line_total FLOAT ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.order_items TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.payments table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.payments', 'U') IS NOT NULL
	DROP TABLE silver.payments;
CREATE TABLE silver.payments
(
		payment_id INT ,
		order_id INT ,
		method VARCHAR(50) ,
		amount FLOAT ,
		paid_at DATETIME ,
		status VARCHAR(50) ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.payments TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.shipments table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.shipments', 'U') IS NOT NULL
	DROP TABLE silver.shipments;
CREATE TABLE silver.shipments
(
		shipment_id INT ,
		order_id INT ,
		carrier VARCHAR(50) ,
		tracking_number VARCHAR(50) ,
		shipped_at DATE ,
		delivered_at DATETIME,
		status VARCHAR(50) ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.shipments TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
-- Check if the silver.returns table exists and
-- Drop it if already exists
IF OBJECT_ID ('silver.returns', 'U') IS NOT NULL
	DROP TABLE silver.returns;
CREATE TABLE silver.returns
(
		return_id INT ,
		order_item_id INT ,
		reason VARCHAR(50) ,
		refund_amount FLOAT ,
		requested_at DATETIME ,
		status VARCHAR(50) ,
		dwhp_create_date DATETIME2 DEFAULT GETDATE()
);
PRINT 'silver.returns TABLE CREATED!!';
--=================================================================================================


--=================================================================================================
PRINT 'COMPLETED CREATING ALL THE SILVER LAYER TABLES!!';
--=================================================================================================
