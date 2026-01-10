# 🏛️ Modern SQL Data Warehouse Portfolio Project
### End-to-End Data Engineering & Analytics | SQL Server

This repository contains a full-scale **Modern Data Warehouse** project built using **SQL Server**. The project implements a **Medallion Architecture** to transform raw, messy data from multiple sources (CRM & ERP) into a business-ready **Star Schema**.

---

## 🛠️ Tech Stack & Architecture
- **Engine:** SQL Server (T-SQL)
- **Architecture:** Medallion (Bronze ➡️ Silver ➡️ Gold)
<!--- **Modeling:** Dimensional Modeling (Star Schema)-->
- **Methodology:** ETL (Extract, Transform, Load) with Bulk Inserts
<!--- **Design Tools:** Draw.io (Architecture Diagrams), Notion (Project Tracking)-->

---

## 🏗️ Data Flow & Governance

### 1. Bronze Layer (Raw)
- **Objective:** Ingest raw CSV files from ERP and CRM systems without modification.
- **Process:** Implemented `BULK INSERT` for high-performance loading.
- **Goal:** Maintain 100% data lineage and traceability back to source systems.

### 2. Silver Layer (Cleaned)
- **Objective:** Data cleansing and standardization.
- **Transformations:** - Handled **missing values** and duplicates.
  - Standardized **Gender** and **Marital Status** abbreviations into friendly names.
  - Fixed **invalid date ranges** and performed data type casting.
  - Removed unwanted spaces (Trimming) and handled negative price/sales outliers.

<!--### 3. Gold Layer (Analytics)
- **Objective:** Final business-ready layer for Power BI / Reporting.
- **Modeling:** Created a **Star Schema** with Centrally linked Facts and Dimensions.
- **Key Deliverables:** - `Dim_Customers`: Integrated CRM & ERP data for a 360-degree customer view.
  - `Dim_Products`: Curated product hierarchies and categories.
  - `Fact_Sales`: Transactional table with surrogate keys and calculated metrics (Sales Amount, Quantity).

---

## 📂 Project Structure
```text
├── Scripts
│   ├── Bronze/        # DDL and Bulk Load Stored Procedures
│   ├── Silver/        # Data Cleansing & Transformation Scripts
│   └── Gold/          # Views for Dimensional Modeling (Fact/Dims)
├── Docs
│   ├── Architecture/  # Data Flow & Integration Diagrams
│   └── Data_Catalog/  # Field descriptions and Business Rules
└── README.md-->
