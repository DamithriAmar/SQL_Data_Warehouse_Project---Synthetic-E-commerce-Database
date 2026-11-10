/* ------------------------------------------------------------------------------------------------
===================================================================================================
Create the database and the schemas.
===================================================================================================
-------------------------------------------------------------------------------------------------*/

-- Check for existing Synth_E_Commerce_Database and
-- Drop it if already exists
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Synth_E_Commerce_Database')
BEGIN
	DROP DATABASE Synth_E_Commerce_Database
END;
GO


-- Create the database 'Synth_E_Commerce_Database'
CREATE DATABASE Synth_E_Commerce_Database;
GO
PRINT '''Synth_E_Commerce_Database'' DATABASE CREATED!!'''


-- Use the Synth_E_Commerce_Database database
USE Synth_E_Commerce_Database;
GO


-- Create the schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
