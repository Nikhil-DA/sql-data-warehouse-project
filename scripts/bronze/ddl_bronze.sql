/*
-- --------------------------------------------------------
-- 📦 Project: Data Warehouse Staging Layer
-- 🗂️ Script: Create Bronze Tables in DataWarehouse2
-- 🧾 Description: This script creates staging (bronze-layer) tables 
--                to hold raw CRM and ERP data.
-- --------------------------------------------------------
*/

-- 🔹 Step 1: Create a new database for staging
CREATE DATABASE IF NOT EXISTS DWH 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_general_ci;

-- 🔹 Step 2: Switch to the new database
USE DWH;

-- --------------------------------------------------------
-- 🧾 CRM TABLES (Customer Relationship Management System)
-- --------------------------------------------------------

-- 👤 Customer Info (Basic customer profile from CRM)
CREATE TABLE IF NOT EXISTS bronze_crm_cust_info (
    cst_id INT, -- renamed cust_id to cst_id for consistency
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),	
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATETIME -- 
);

-- 📦 Product Info (Product metadata from CRM)
CREATE TABLE IF NOT EXISTS bronze_crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost DECIMAL(10,2), -- 
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

-- 💰 Sales Transactions (Sales orders and details)
CREATE TABLE IF NOT EXISTS bronze_crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(10,2),
    sls_quantity INT,
    sls_price DECIMAL(10,2)
);

-- --------------------------------------------------------
-- 🧾 ERP TABLES (Enterprise Resource Planning System)
-- --------------------------------------------------------

-- 👤 ERP Customer Info (Demographics like DOB and gender)
CREATE TABLE IF NOT EXISTS bronze_erp_cust_az12 (
    cid  VARCHAR(50),
    bdate DATE,
    gen VARCHAR(10)
);

-- 🌍 ERP Location Info (Customer country-level data)
CREATE TABLE IF NOT EXISTS bronze_erp_loc_a101 (
    cid  VARCHAR(50),
    cntry VARCHAR(50)
);

-- 🧾 Product Category Info (Categorization of products)
CREATE TABLE IF NOT EXISTS bronze_erp_px_cat_g1v2 (
    id  VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintainance VARCHAR(50)
);

-- --------------------------------------------------------
-- ✅ End of Script
-- --------------------------------------------------------


