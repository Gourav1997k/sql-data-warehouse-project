
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time=GETDATE()
		PRINT '=========================================';
		PRINT 'Loading Data into the Bronze Layer...'
		PRINT '=========================================';

		PRINT '-----------------------------------------';
		PRINT 'Loading the CRM tables...';
		PRINT '-----------------------------------------';

		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting data into table bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);	
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.crm_cust_info- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';


		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;


		PRINT '>> Inserting data into table bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);	
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.crm_prd_info- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';


		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;


		PRINT '>> Inserting data into table bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);	
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.crm_sales_info- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';

		PRINT '----------------------------------------------------';
		PRINT 'Loading the erp tables...';
		print '----------------------------------------------------';


		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting data into table bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);	
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.erp_cust_az12- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';

		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting data into table bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);	
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.erp_loc_a101- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';

		SET @start_time=GETDATE();
		PRINT '>> Truncating data from table bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting data into table bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\DWH course\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration for bronze.erp_px_cat_g1v2- ' + CAST(datediff(millisecond, @start_time, @end_time) AS NVARCHAR) + ' ms.';
		SET @batch_end_time=GETDATE();
		PRINT 'Total Batch loading duration- ' +CAST(datediff(millisecond, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' ms.';
	END TRY
	BEGIN CATCH
		PRINT '==================================================';
		PRINT 'Error message- ' + ERROR_MESSAGE();
		PRINT 'Error number- ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '==================================================';
		
		THROW;
	END CATCH
END
