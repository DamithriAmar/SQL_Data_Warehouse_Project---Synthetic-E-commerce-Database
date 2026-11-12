/*-------------------------------------------------------------------------------------------------
===================================================================================================
Stored Procedure: Load the bronze layer

Purpose: Load data from external csv files
		 Perform TRUNCATE and BULK INSERT commands to load data to the tables.

How to execute:
		EXEC bronze.load_bronze
===================================================================================================
-------------------------------------------------------------------------------------------------*/

USE Synth_E_Commerce_Database;
GO

--=================================================================================================
-- Create the stored procedure or
-- Re-load data into already existing tables
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

-- Declare time variables to calculate the duration of operations
	DECLARE @start_time DATETIME, @end_time DATETIME, 
			@load_start_time DATETIME, @load_end_time DATETIME

-- Start the TRY clause
BEGIN TRY
	PRINT '========================================================='
	PRINT 'STARTED LOADING BRONZE LAYER!!'
	PRINT '========================================================='

	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.customers'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @load_start_time = GETDATE();
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.customers ';
	TRUNCATE TABLE bronze.customers ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.customers ';
	BULK INSERT bronze.customers 
	FROM 'C:\Users\damit\Desktop\new_customers.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.customers ';
-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.products'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.products';
	TRUNCATE TABLE bronze.products ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.products';
	BULK INSERT bronze.products
	FROM 'C:\Users\damit\Desktop\new_products.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.products';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.order_items'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.order_items';
	TRUNCATE TABLE bronze.order_items ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.order_items';
	BULK INSERT bronze.order_items
	FROM 'C:\Users\damit\Desktop\new_order_items.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.order_items';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.payments'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.payments';
	TRUNCATE TABLE bronze.payments ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.payments';
	BULK INSERT bronze.payments
	FROM 'C:\Users\damit\Desktop\new_payments.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.payments';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.orders'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.orders';
	TRUNCATE TABLE bronze.orders ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.orders';
	BULK INSERT bronze.orders
	FROM 'C:\Users\damit\Desktop\new_orders.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.orders';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.shipments'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.shipments';
	TRUNCATE TABLE bronze.shipments ;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.shipments';
	BULK INSERT bronze.shipments
	FROM 'C:\Users\damit\Desktop\new_shipments.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.shipments';

-- Assign the ending time variables
	SET @end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';
--=================================================================================================


--=================================================================================================
	PRINT '---------------------------------------------------------'
	PRINT 'STARTED LOADING TABLE: bronze.returns'
	PRINT '========================================================='

-- Assign the starting time variables
	SET @start_time = GETDATE();

-- TRUNCATE the table
	PRINT '>>>> TRUNCATING TABLE: bronze.returns';
	TRUNCATE TABLE bronze.returns;

-- LOAD the data to the table
	PRINT '<<<< LOADING TABLE: bronze.returns';
	BULK INSERT bronze.returns
	FROM 'C:\Users\damit\Desktop\new_returns.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '<<<< COMPLETED LOADING TABLE: bronze.returns';

-- Assign the ending time variables
	SET @end_time = GETDATE();
	SET @load_end_time = GETDATE();

-- Calculate the load duration
	PRINT 'LOAD DURATION: ' + 
		  CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

	PRINT '========================================================='
	PRINT 'FINISHED LOADING BRONZE LAYER!!'
	PRINT '========================================================='

-- Calculate the load duration
	PRINT 'TOTAL BRONZE LAYER LOAD DURATION: ' + 
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
