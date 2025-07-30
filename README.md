

---

## **📊 Data Warehouse and Analytics Project**

Welcome to the **Data Warehouse and Analytics Project repository!** 🚀
This project demonstrates how to build a complete data warehouse and analytics solution using **SQL (MySQL Workbench)**, following the **Medallion Architecture (Bronze, Silver, Gold)** and applying **ETL best practices**.

---

## **🏗️ Data Architecture**

This project follows the **Medallion Architecture** with three layers:

* **Bronze Layer:**
  Stores raw data ingested from CSV source files (ERP and CRM systems) into the staging area as-is.

* **Silver Layer:**
  Cleansed and standardized data. Includes removing duplicates, handling nulls, applying transformations, and building normalized tables.

* **Gold Layer:**
  Business-ready, analytical models in a **Star Schema** with dimension and fact tables. This layer supports reporting and dashboards.

![Data Architecture](docs/data_architecture.drawio)

---

## **📖 Project Overview**

This project showcases:

1. **Data Architecture:** Designing a data warehouse using the Medallion approach.
2. **ETL Pipelines:** Loading and transforming raw CSV data into the data warehouse.
3. **Data Modeling:** Creating **fact** and **dimension** tables for analytics.
4. **Analytics & Reporting:** Querying business metrics such as sales, product performance, and customer insights.

---

## **🎯 Skills Demonstrated**

This repository is perfect for demonstrating skills in:

* **SQL Development (MySQL)**
* **Data Engineering & ETL**
* **Data Modeling (Star Schema)**
* **Analytics & Reporting**
* **Data Architecture Design**

---

## **🛠️ Tools & Datasets**

* **MySQL Workbench**: For database design, ETL scripts, and transformations.
* **CSV Datasets**: ERP and CRM sales data used as raw inputs.
* **Draw\.io (diagrams)**: For architecture and data modeling diagrams.
* **Git & GitHub**: Version control and project hosting.

---

## **🚀 Project Requirements**

### ** Data Engineering - Data Warehouse**

* **Data Sources:**
  Two systems:

  * ERP System (Product, Sales details, Location data)
  * CRM System (Customer information)
* **ETL:**

  * Load data into Bronze Layer (raw tables).
  * Cleanse, standardize, and integrate data in Silver Layer.
  * Create Star Schema models (Fact & Dimensions) in Gold Layer.
* **Data Quality:**

  * Remove duplicates, fill missing values, and unify reference data.


---

## **📂 Repository Structure**

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets (ERP and CRM data)
│
├── docs/                               # Documentation & diagrams
│   ├── data_architecture.drawio        # Data warehouse architecture diagram
│   ├── data_models.drawio              # Star schema diagram
│   ├── data_flow.drawio                # ETL data flow diagram
│   ├── data_catalog.md                 # Gold layer data catalog (fields & metadata)
│   ├── naming-conventions.md           # Naming standards for tables/columns
│
├── scripts/                            # SQL scripts for each layer
│   ├── bronze/                         # Raw load scripts
│   ├── silver/                         # Cleansing & transformation scripts
│   ├── gold/                           # Analytical model (dimension & fact tables)
│       └── gold_views.sql              # Final views for gold layer
│
├── tests/                              # Data quality & validation scripts
│
├── README.md                           # Project documentation (this file)
```

---

## **📜 Gold Layer (Star Schema)**

The Gold Layer consists of:

1. **`gold_dim_customers`** – Customer dimension (demographics, location, etc.)
2. **`gold_dim_products`** – Product dimension (category, cost, product line)
3. **`gold_fact_sales`** – Fact table storing sales transactions


---

## **📈 Example Insights**

Using the Gold Layer, you can answer questions like:

* Who are our **top customers** by revenue?
* Which **products and categories** perform best?
* What are the **monthly sales trends**?
* Which countries or regions contribute the most sales?


---

## **🛡️ License**

This project is licensed under the **MIT License**. You are free to use, modify, and share it with attribution.

---





