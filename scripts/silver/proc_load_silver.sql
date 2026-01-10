
create or alter procedure silver.load_silver as
begin
	print '>> Truncating Table: silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	print '>> Inserting into Table: silver.crm_cust_info';
	insert into silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)
	select 
		cst_id,
		cst_key,
		TRIM(cst_firstname) as cst_firstname,
		TRIM(cst_lastname) as cst_lastname,
		case when upper(trim(cst_marital_status)) = 'S' then 'Single'
			 when upper(trim(cst_marital_status)) = 'M' then 'Married'
			 else 'n/a' end as cst_marital_status,
		case when upper(trim(cst_gndr)) = 'M' then 'Male'
			 when upper(trim(cst_gndr)) = 'F' then 'Female'
			 else 'n/a' end as cst_gndr,
		cst_create_date
	from (
	select *,
	ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_latest_date
	from bronze.crm_cust_info) a
	where flag_latest_date=1;

	-- inserting in silver.crm_prd_info

	print '>> Truncating Table: silver.crm_prd_info';
	truncate table silver.crm_prd_info;
	print '>> Inserting into Table: silver.crm_prd_info';
	insert into silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	select
		prd_id,
		replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
		SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost, 0) as prd_cost,
		case when upper(trim(prd_line)) = 'M' then 'Mountain'
			 when upper(trim(prd_line)) = 'R' then 'Road'
			 when upper(trim(prd_line)) = 'S' then 'Other Sales'
			 when upper(trim(prd_line)) = 'T' then 'Touring'
			 else 'n/a' end as prd_line,
		cast(prd_start_dt as date) prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_date
	from bronze.crm_prd_info;




	-- inserting into silver.crm_sales_details
	print '>> Truncating Table: silver.crm_sales_details';
	truncate table silver.crm_sales_details;
	print '>> Inserting into Table: silver.crm_sales_details';
	insert into silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case when sls_order_dt=0 or len(sls_order_dt)!=8 then NULL
			 else cast(cast(sls_order_dt as varchar) as DATE)
		end as sls_order_dt,
		case when sls_ship_dt=0 or len(sls_ship_dt)!=8 then NULL
			 else cast(cast(sls_ship_dt as varchar) as DATE)
		end as sls_ship_dt,
		case when sls_due_dt=0 or len(sls_due_dt)!=8 then NULL
			 else cast(cast(sls_due_dt as varchar) as DATE)
		end as sls_due_dt,
		case when sls_sales is null or sls_sales != sls_quantity * abs(sls_price)
			 then sls_quantity * abs(sls_price)
			 else sls_sales
		end as sls_sales,
		sls_quantity,
		case when sls_price is null or sls_price <= 0
			 then sls_sales / nullif(sls_quantity,0)
			 else sls_price
		end as sls_price
	from bronze.crm_sales_details;




	-- insert into silver.erp_cust_az12

	print '>> Truncating Table: silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	print '>> Inserting into Table: silver.erp_cust_az12';
	insert into silver.erp_cust_az12 (cid, bdate, gen)
	select 
		case when cid like 'NAS%' then SUBSTRING(cid, 4, len(cid))
			 else cid
		end as cid,
		case when bdate > GETDATE() then NULL
			 else bdate
		end as bdate,
		case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			 when upper(trim(gen)) in ('M', 'MALE') then 'Male'
			 else 'n/a'
		end as gen
	from bronze.erp_cust_az12;




	--inserting into silver.erp_loc_a101
	print '>> Truncating Table: silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;
	print '>> Inserting into Table: silver.erp_loc_a101';
	insert into silver.erp_loc_a101 (cid, cntry)
	select replace(cid, '-', '') as cid,
		   case when trim(cntry)='DE' then 'Germany'
				when trim(cntry) in ('US', 'USA') then 'United States'
				when TRIM(cntry) = '' or TRIM(cntry) is null then 'n/a'
				else trim(cntry)
			end as cntry
	from bronze.erp_loc_a101;



	--inserting into silver.erp_px_cat_g1v2
	print '>> Truncating Table: silver.erp_px_cat_g1v2';
	truncate table silver.erp_px_cat_g1v2;
	print '>> Inserting into Table: silver.erp_px_cat_g1v2';
	insert into silver.erp_px_cat_g1v2
	(id, cat, subcat, maintenance)
	select
		id,
		cat,
		subcat,
		maintenance
	from bronze.erp_px_cat_g1v2;
end
