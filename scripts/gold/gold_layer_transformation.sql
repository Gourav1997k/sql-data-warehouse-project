
--create dimension table - gold.dim_customers

create view gold.dim_customers as 
select
	row_number() over (order by cst_id) as customer_key,
	cst_id as customer_id,
	cst_key as customer_number,
	cst_firstname as first_name,
	cst_lastname as last_name,
		la.cntry as country,
	cst_marital_status,
		case when ci.cst_gndr!='n/a' then ci.cst_gndr
		 else coalesce(ca.gen, 'n/a') 
	end as gender,
		ca.bdate as birthdate,
	cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key=la.cid









--create dimension table gold.dim_products

create view gold.dim_products as 
select
	row_number() over (order by pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id=pc.id
where prd_end_dt is null; -- filtering out historical data





--create fact table gold.fact_sales

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;