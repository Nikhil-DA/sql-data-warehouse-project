/*
===============================================================================
Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema tables by:
        - Truncating the Silver tables before load to ensure fresh data.
        - Applying data cleansing and transformation logic during inserts.
        - Handling data consistency and correcting common data issues.

Parameters:
    None.
    This stored procedure does not accept parameters or return values.

Usage Example:
    CALL sp_bronze_to_silver_etl();
    -- Or depending on your schema and naming conventions:
    -- EXEC Silver.sp_bronze_to_silver_etl;

Notes:
    - Ensure you have appropriate privileges to truncate and insert data.
    - Run this procedure after the Bronze tables are fully loaded and ready.
===============================================================================
*/



    -- ============================================
    -- CRM: Customer Info
    -- ============================================
    SELECT 'Truncating table: silver_crm_cust_info...' AS msg;
    TRUNCATE TABLE silver_crm_cust_info;

    SELECT 'Inserting data into: silver_crm_cust_info...' AS msg;
    INSERT INTO silver_crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname), -- remove leading/trailing spaces
        TRIM(cst_lastname),  -- remove leading/trailing spaces
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'   -- standardize marital status
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'   -- standardize gender
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *, ROW_NUMBER() OVER (
                PARTITION BY cst_id
                ORDER BY cst_create_date DESC -- latest record wins
        ) AS flag_last
        FROM bronze_crm_cust_info
        WHERE cst_id IS NOT NULL AND cst_id != 0
    ) t
    WHERE flag_last = 1;

    -- ============================================
    -- CRM: Product Info
    -- ============================================
    SELECT 'Truncating table: silver_crm_prd_info...' AS msg;
    TRUNCATE TABLE silver_crm_prd_info;

    SELECT 'Inserting data into: silver_crm_prd_info...' AS msg;
    INSERT INTO silver_crm_prd_info(
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'), -- fix category id format
        SUBSTRING(prd_key, 7, LENGTH(prd_key)), -- extract product key part
        prd_nm,
        prd_cost,
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'   -- standardize product line
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        prd_start_dt,
        DATE_SUB(
            CASE 
                WHEN DATE_FORMAT(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), '%Y-%m-%d') = '0000-00-00'
                THEN '2099-12-31' -- set far future date if invalid
                ELSE LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)
            END,
            INTERVAL 1 DAY
        )
    FROM bronze_crm_prd_info;

    -- ============================================
    -- CRM: Sales Details
    -- ============================================
    SELECT 'Truncating table: silver_crm_sales_details...' AS msg;
    TRUNCATE TABLE silver_crm_sales_details;

    SELECT 'Inserting data into: silver_crm_sales_details...' AS msg;
    INSERT INTO silver_crm_sales_details(
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
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 
                OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price) -- recalculate sales if invalid
            ELSE sls_sales
        END,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity, 0) -- recalculate price if invalid
            ELSE sls_price
        END
    FROM bronze_crm_sales_details;

    -- ============================================
    -- ERP: Customer Info
    -- ============================================
    SELECT 'Truncating table: silver_erp_cust_az12...' AS msg;
    TRUNCATE TABLE silver_erp_cust_az12;

    SELECT 'Inserting data into: silver_erp_cust_az12...' AS msg;
    INSERT INTO silver_erp_cust_az12(
        cid,
        bdate,
        gen
    )
    SELECT 
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) -- remove NAS prefix
            ELSE cid
        END,
        CASE 
            WHEN bdate > CURRENT_DATE() THEN NULL -- remove future birthdates
            ELSE bdate
        END,
        CASE 
            WHEN REPLACE(UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))), '.', '') IN ('F','FEMALE') 
            THEN 'Female'
            WHEN REPLACE(UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))), '.', '') IN ('M','MALE') 
            THEN 'Male'
            ELSE 'n/a'
        END
    FROM bronze_erp_cust_az12;

    -- ============================================
    -- ERP: Location Info
    -- ============================================
    SELECT 'Truncating table: silver_erp_loc_a101...' AS msg;
    TRUNCATE TABLE silver_erp_loc_a101;

    SELECT 'Inserting data into: silver_erp_loc_a101...' AS msg;
    INSERT INTO silver_erp_loc_a101(
        cid,
        cntry
    )
    SELECT 
        REPLACE(cid, '-', ''), -- remove dashes from cid
        CASE 
            WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') = 'DE' 
            THEN 'Germany'
            WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') IN ('US', 'USA') 
            THEN 'United States'
            WHEN REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') = '' OR cntry IS NULL 
            THEN 'n/a'
            ELSE REPLACE(REPLACE(TRIM(cntry), '\r', ''), '\n', '') -- remove extra line breaks
        END
    FROM bronze_erp_loc_a101;

    -- ============================================
    -- ERP: Product Category Info
    -- ============================================
    SELECT 'Truncating table: silver_erp_px_cat_g1v2...' AS msg;
    TRUNCATE TABLE silver_erp_px_cat_g1v2;

    SELECT 'Inserting data into: silver_erp_px_cat_g1v2...' AS msg;
    INSERT INTO silver_erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintainance
    )
    SELECT 
        id,
        TRIM(cat), -- remove spaces
        TRIM(subcat),
        TRIM(maintainance)
    FROM bronze_erp_px_cat_g1v2;

    -- ============================================
    -- Final Completion Message
    -- ============================================
    SELECT '✅ ETL process completed successfully! All Silver tables have been refreshed.' AS msg;
