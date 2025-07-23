-- 📦 Project: Data Warehouse Staging Layer
-- 🗂️ Script: Create Silver Tables in DataWarehouse2
-- 🧾 Description: This script creates staging (silver-layer) tables 
--                to hold raw CRM and ERP data. It drops any existing tables before recreating.
-- --------------------------------------------------------

-- 🔹 Step 1: Switch to the main database (skip creating new one)
USE DataWarehouse2;

-- --------------------------------------------------------
-- 🧾 CRM TABLES (Customer Relationship Management System)
-- --------------------------------------------------------

-- 👤 Customer Info
DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
    cust_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),	
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

);

-- 📦 Product Info
DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    prd_nm VARCHAR(100) CHARACTER SET utf8mb4,
    prd_cost INT,
    prd_line VARCHAR(50) CHARACTER SET utf8mb4,
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 💰 Sales Transactions
DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
    sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 🧾 ERP TABLES (Enterprise Resource Planning System)
-- --------------------------------------------------------

-- 👤 ERP Customer Info
DROP TABLE IF EXISTS silver_erp_cust_az12;
CREATE TABLE silver_erp_cust_az12 (
    cid  VARCHAR(50) CHARACTER SET utf8mb4,
    bdate DATE,
    gen VARCHAR(10) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 🌍 ERP Location Info
DROP TABLE IF EXISTS silver_erp_loc_a101;
CREATE TABLE silver_erp_loc_a101 (
    cid  VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 🧾 Product Category Info
DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2 (
    id  VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintainance VARCHAR(50) CHARACTER SET utf8mb4,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- ✅ End of Script
-- --------------------------------------------------------
