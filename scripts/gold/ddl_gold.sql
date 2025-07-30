/*
=====================================================================
   GOLD LAYER VIEWS
   This script creates the dimension and fact views for the 
   Gold Layer of the Data Warehouse.
=====================================================================
*/

/* -------------------------------------------------------------
   1️⃣ Customer Dimension - gold_dim_customers
   Purpose: Stores enriched customer details (CRM + ERP + Location)
--------------------------------------------------------------- */
DROP VIEW IF EXISTS gold_dim_customers;

CREATE VIEW gold_dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,          -- Surrogate key
    ci.cst_id AS customer_id,                                        -- Business key from CRM
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,                                             -- Country from location table
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr                   -- CRM is master for gender
        ELSE COALESCE(ca.gen, 'n/a')                                 -- Else fallback to ERP
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
    ON ci.cst_key = la.cid;


/* -------------------------------------------------------------
   2️⃣ Product Dimension - gold_dim_products
   Purpose: Stores product details and category hierarchy
--------------------------------------------------------------- */
DROP VIEW IF EXISTS gold_dim_products;

CREATE VIEW gold_dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,   -- Surrogate key
    pn.prd_id AS product_id,                                                   -- Business key
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintainance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver_crm_prd_info pn
LEFT JOIN silver_erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;   -- Exclude historical/inactive products


/* -------------------------------------------------------------
   3️⃣ Sales Fact - gold_fact_sales
   Purpose: Stores sales transactions linked to product & customer dimensions
--------------------------------------------------------------- */
DROP VIEW IF EXISTS gold_fact_sales;

CREATE VIEW gold_fact_sales AS
SELECT 
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver_crm_sales_details sd
LEFT JOIN gold_dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold_dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
