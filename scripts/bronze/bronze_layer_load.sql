-- =============================================================================
-- 📦 Script: bronze_layer_load.sql
-- =============================================================================
-- 🔍 Description:
--     This SQL script loads raw data from CRM and ERP CSV files into the
--     Bronze Layer of the Data Warehouse (`bronze` schema).
--     It performs truncation of existing data and loads new data using
--     `LOAD DATA LOCAL INFILE`. ETL logging is optionally included.
--
-- ⚙️ Operations Performed:
--     - Enables LOCAL INFILE for MySQL
--     - Truncates Bronze Layer tables before loading
--     - Loads CSV files from local paths into MySQL tables
--     - (Optional) Logs load times to `etl_log` if the table exists
--
-- 📁 Files Imported:
--     - cust_info.csv         → bronze_crm_cust_info
--     - prd_info.csv          → bronze_crm_prd_info
--     - sales_details.csv     → bronze_crm_sales_details
--     - CUST_AZ12.csv         → bronze_erp_cust_az12
--     - LOC_A101.csv          → bronze_erp_loc_a101
--     - PX_CAT_G1V2.csv       → bronze_erp_px_cat_g1v2
--
-- 🚫 Parameters:
--     None – this is a flat script, not a stored procedure.
--
-- 💡 Usage:
--     Open in MySQL Workbench and execute to load Bronze Layer.
--
-- 📌 Tip:
--     Consider converting this script to a stored procedure for better reusability.
-- =============================================================================


USE DWH;

-- ---------------------- ETL LOG TABLE ----------------------
CREATE TABLE IF NOT EXISTS etl_log (
    table_name VARCHAR(100),
    started_at DATETIME,
    ended_at DATETIME,
    duration TIME
);

-- Enable local file loading
SET GLOBAL local_infile = 1;

-- =============================================================================
-- ================== CRM TABLES LOAD ==========================================
-- =============================================================================

-- ==================== STEP 1: bronze_crm_cust_info ====================
SET @start_cust_info = NOW();

TRUNCATE TABLE bronze_crm_cust_info;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, @cst_create_date)
SET cst_create_date = STR_TO_DATE(@cst_create_date, '%Y-%m-%d %H:%i:%s');

SET @end_cust_info = NOW();

INSERT INTO etl_log VALUES (
  'bronze_crm_cust_info', @start_cust_info, @end_cust_info, TIMEDIFF(@end_cust_info, @start_cust_info)
);

-- ==================== STEP 2: bronze_crm_prd_info ====================
SET @start_prd_info = NOW();

TRUNCATE TABLE bronze_crm_prd_info;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_prd_info = NOW();

INSERT INTO etl_log VALUES (
  'bronze_crm_prd_info', @start_prd_info, @end_prd_info, TIMEDIFF(@end_prd_info, @start_prd_info)
);

-- ==================== STEP 3: bronze_crm_sales_details ====================
SET @start_sales_details = NOW();

TRUNCATE TABLE bronze_crm_sales_details;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sls_ord_num, sls_prd_key, sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, sls_sales, sls_quantity, sls_price)
SET 
    sls_order_dt = STR_TO_DATE(@sls_order_dt, '%Y%m%d'),
    sls_ship_dt = STR_TO_DATE(@sls_ship_dt, '%Y%m%d'),
    sls_due_dt = STR_TO_DATE(@sls_due_dt, '%Y%m%d');

SET @end_sales_details = NOW();

INSERT INTO etl_log VALUES (
  'bronze_crm_sales_details', @start_sales_details, @end_sales_details, TIMEDIFF(@end_sales_details, @start_sales_details)
);

-- =============================================================================
-- ================== ERP TABLES LOAD ==========================================
-- =============================================================================

-- ==================== STEP 4: bronze_erp_cust_az12 ====================
SET @start_cust_az12 = NOW();

TRUNCATE TABLE bronze_erp_cust_az12;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cid, @bdate, gen)
SET bdate = STR_TO_DATE(@bdate, '%Y%m%d');

SET @end_cust_az12 = NOW();

INSERT INTO etl_log VALUES (
  'bronze_erp_cust_az12', @start_cust_az12, @end_cust_az12, TIMEDIFF(@end_cust_az12, @start_cust_az12)
);

-- ==================== STEP 5: bronze_erp_loc_a101 ====================
SET @start_loc_a101 = NOW();

TRUNCATE TABLE bronze_erp_loc_a101;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_loc_a101 = NOW();

INSERT INTO etl_log VALUES (
  'bronze_erp_loc_a101', @start_loc_a101, @end_loc_a101, TIMEDIFF(@end_loc_a101, @start_loc_a101)
);

-- ==================== STEP 6: bronze_erp_px_cat_g1v2 ====================
SET @start_px_cat = NOW();

TRUNCATE TABLE bronze_erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE 'D:/Data Analytics/End to End SQL/SQL Data Warehouse/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_px_cat = NOW();

INSERT INTO etl_log VALUES (
  'bronze_erp_px_cat_g1v2', @start_px_cat, @end_px_cat, TIMEDIFF(@end_px_cat, @start_px_cat)
);

-- =============================================================================
-- FINAL: View ETL log
-- =============================================================================

SELECT * FROM etl_log ORDER BY started_at DESC;

