/*
-- --------------------------------------------------------
-- 📦 Project: Data Warehouse Staging Layer
-- 🗂️ Script: Create Bronze Tables in DataWarehouse2
-- 🧾 Description: This script creates staging (bronze-layer) tables 
--                to hold raw CRM and ERP data.
-- --------------------------------------------------------
*/

-- 🔹 Step 1: Create a new database for staging
CREATE DATABASE DataWarehouse2;

-- 🔹 Step 2: Switch to the new database
USE DataWarehouse2;

-- --------------------------------------------------------
-- 🧾 CRM TABLES (Customer Relationship Management System)
-- --------------------------------------------------------


-- 👤 Customer Info (Basic customer profile from CRM)
CREATE TABLE bronze_crm_cust_info(
    cust_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),	
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(50)
);

-- 📦 Product Info (Product metadata from CRM)
CREATE TABLE bronze_crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    prd_nm VARCHAR(100) CHARACTER SET utf8mb4,
    prd_cost INT,
    prd_line VARCHAR(50) CHARACTER SET utf8mb4,
    prd_start_dt DATE,
    prd_end_dt DATE
);

-- 💰 Sales Transactions (Sales orders and details)
CREATE TABLE bronze_crm_sales_details (
    sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- --------------------------------------------------------
-- 🧾 ERP TABLES (Enterprise Resource Planning System)
-- --------------------------------------------------------

-- 👤 ERP Customer Info (Demographics like DOB and gender)
CREATE TABLE bronze_erp_cust_az12 (
    cid  VARCHAR(50) CHARACTER SET utf8mb4,
    bdate DATE,
    gen VARCHAR(10) CHARACTER SET utf8mb4
);

-- 🌍 ERP Location Info (Customer country-level data)
CREATE TABLE bronze_erp_loc_a101 (
    cid  VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4
);

-- 🧾 Product Category Info (Categorization of products)
CREATE TABLE bronze_erp_px_cat_g1v2 (
    id  VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintainance VARCHAR(50) CHARACTER SET utf8mb4
);

-- --------------------------------------------------------
-- ✅ End of Script
-- --------------------------------------------------------


