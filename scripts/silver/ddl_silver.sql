-- 📦 Project: Data Warehouse Staging Layer (Silver)
-- 🗂️ Script: Create Silver Tables in DWH
-- 🧾 Description: Cleaned, standardized data tables

USE DWH;

-- --------------------------------------------------------
-- 🧾 CRM TABLES
-- --------------------------------------------------------

-- 👤 Customer Info
DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),	
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date DATETIME, -- standardized from VARCHAR
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

-- 📦 Product Info
DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost DECIMAL(10,2), -- standardized to decimal
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

-- 💰 Sales Transactions
DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(10,2),
    sls_quantity INT,
    sls_price DECIMAL(10,2),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 🧾 ERP TABLES
-- --------------------------------------------------------

-- 👤 ERP Customer Info
DROP TABLE IF EXISTS silver_erp_cust_az12;
CREATE TABLE silver_erp_cust_az12 (
    cid  VARCHAR(50),
    bdate DATE,
    gen VARCHAR(10),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

-- 🌍 ERP Location Info
DROP TABLE IF EXISTS silver_erp_loc_a101;
CREATE TABLE silver_erp_loc_a101 (
    cid  VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

-- 🧾 Product Category Info
DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2 (
    id  VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintainance VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP 
                      ON UPDATE CURRENT_TIMESTAMP
);

