-- Check for Nulls or Duplicates 
-- Expectations: No Results
SELECT 
  cst_id, 
  COUNT(*) AS count_duplicates
FROM bronze_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT 
  prd_id, 
  COUNT(*) AS count_duplicates
FROM bronze_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT prd_cost
FROM bronze_crm_prd_info
WHERE prd_cost <= 0;




-- Check for unwanted spaces 
-- Expectations = No Results
SELECT cst_firstname
FROM bronze_crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);
SELECT cst_lastname
FROM bronze_crm_cust_info
WHERE cst_firstname <> TRIM(cst_lastname);

SELECT prd_nm
FROM bronze_crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

SELECT*
FROM bronze_erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
	 OR subcat <> TRIM(subcat)
     OR maintainance <> TRIM(maintainance);



-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze_crm_cust_info;

SELECT DISTINCT prd_line
FROM bronze_crm_prd_info;

SELECT DISTINCT gen,
    CASE WHEN UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M' , 'MALE') THEN 'Male'
         ELSE 'n/a'
    END AS gen
FROM bronze_erp_cust_az12;
SELECT DISTINCT 
    gen,
   CASE 
        WHEN REPLACE(UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))), '.', '') 
             IN ('F','FEMALE') 
             THEN 'Female'
        WHEN REPLACE(UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))), '.', '') 
             IN ('M','MALE') 
             THEN 'Male'
        ELSE 'n/a'
     END AS gen
FROM bronze_erp_cust_az12;

-- SELECT for invalid Date 
SELECT *
FROM bronze_crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT sls_order_dt
FROM bronze_crm_sales_details
WHERE sls_order_dt = '0000-00-00'
   OR sls_order_dt IS NULL;
DESCRIBE bronze_crm_sales_details;

SELECT sls_order_dt
FROM bronze_crm_sales_details
WHERE sls_order_dt IS NULL
   OR DATE_FORMAT(sls_order_dt, '%Y-%m-%d') = '0000-00-00';
   

SELECT*
FROM bronze_crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

SELECT * 
FROM bronze_erp_cust_az12
WHERE bdate > CURDATE();

-- Check Data Consistency : Between Sales, Quality and Price
-- >> Sales = Quantity * Price 
-- >> Values must not be NULL, zero or negative

SELECT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    -- Fix sls_sales if it's invalid
	CASE 
        WHEN sls_sales IS NULL 
             OR sls_sales <= 0 
             OR sls_sales <> sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS corrected_sls_sales,

    -- Fix sls_price if it's invalid
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
  END AS corrected_sls_price
  FROM bronze_crm_sales_details;





SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         ELSE TRIM(cntry)
	END AS cntry
FROM bronze_erp_loc_a101;

-- Data Standardization and Consistency

SELECT DISTINCT HEX(cntry) 
FROM bronze_erp_loc_a101;

SELECT DISTINCT 
    cntry,
	CASE 
        WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') = 'DE' 
            THEN 'Germany'
        WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') IN ('US', 'USA') 
            THEN 'United States'
        WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') = '' 
            OR cntry IS NULL 
            THEN 'n/a'
        ELSE REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '')
    END AS cleaned_cntry
FROM bronze_erp_loc_a101
ORDER BY cleaned_cntry;



SELECT DISTINCT
cat,
subcat,
maintainance
FROM bronze_erp_px_cat_g1v2;
