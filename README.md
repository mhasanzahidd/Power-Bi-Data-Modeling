# AdventureWorksDW | Power BI Data Modeling & Analytics

A Power BI project focused on dimensional modeling, data integrity, relationship design, and business-oriented sales analysis using the AdventureWorks Data Warehouse.

## Project Overview

This project explores how a dimensional data warehouse can be structured and used to build a reliable Power BI semantic model. Using AdventureWorksDW2019, I examined the source tables, validated data structures, configured table relationships, and developed reports to analyze business performance.

The project emphasizes not only report development but also the data modeling decisions and validation processes behind the reports.

## Objectives

- Explore and understand the AdventureWorksDW2019 data warehouse.
- Analyze fact-table grain and key relationships using SQL.
- Examine data quality and referential integrity.
- Build and validate a Power BI semantic model.
- Apply dimensional modeling principles, including star-schema patterns and selected snowflake relationships.
- Develop DAX measures for sales analysis.
- Create interactive reports for customer and product analysis.
- Document important modeling decisions and analytical findings.

## Tools & Technologies

| Tool             | Purpose                                             |
|------------------|-----------------------------------------------------|
| SQL Server       | Data exploration, validation, and SQL analysis      |
| Power BI Desktop | Semantic modeling, DAX, and report development      |
| DAX              | Business measures and analytical calculations       |
| Power Query      | Data preparation and transformation, where required |
| Git & GitHub     | Version control and project documentation           |

## Data Source

**Database:** AdventureWorksDW2019

AdventureWorksDW is a sample data warehouse representing a business with Internet sales, reseller sales, products, customers, and supporting business dimensions.

The project uses multiple fact and dimension tables from the warehouse, selected according to the modeling and reporting requirements.

## Data Modeling

The Power BI model uses a **primarily star-schema structure with selected snowflake relationships**.

Key modeling considerations include:

- One-to-many relationships between dimensions and fact tables.
- Dimension-to-dimension relationships where appropriate, such as `DimGeography` to `DimCustomer`.
- Key uniqueness and referential integrity.
- Filter propagation and relationship behavior.
- Fact-table grain and the risk of incorrect aggregations.
- Clear and maintainable model structure.

The model's overall structure also accommodates multiple fact tables that support different business processes.

### Data Model

![Power BI Data Model](screenshots/model_view.png)

*The model view illustrates the relationships between the imported fact and dimension tables.*

## SQL Analysis & Validation

SQL Server was used to investigate the warehouse structure and validate important modeling assumptions.

The analysis covered:

- Table and column exploration.
- Fact-table grain and uniqueness.
- Primary and foreign key relationships.
- Missing values and duplicate keys.
- Referential integrity and unmatched keys.
- Row counts and fact-table summaries.

The results informed the Power BI modeling process. Detailed SQL queries and their results are maintained separately in the SQL project.

## Power BI Reports

The report pages provide different perspectives on the business data.

### Customer Analysis

Analyzes customer-related information to support exploration of customer characteristics and sales performance.

### Product Analysis

Explores product-related information and supports analysis across relevant product attributes.

## DAX Measures

DAX measures support the analytical calculations used in the reports, with an initial focus on sales-related metrics.

The measures are maintained separately to keep the calculation logic organized and easier to review.

## Repository Structure

```text
Power-Bi-Data-Modeling/
│
├── README.md
│
├── dax/
│   └── sales_measures.dax
|
├── docs/
│   ├── data_modeling_decisions.md
|   ├── customer_analysis.pdf
│   └── product_analysis.pdf
│
├── powerbi/
│   └── adventureworks_powerbi.pbix
│
├── screenshots/
│   ├── data_model.png
│   ├── customer_overview.png
│   ├── customer_purchasing_behavior.png
|   ├── product_overview.png
│   ├── product_performance.png
│   └── product_trends.png
│
└── sql/
    └── validation-queries.sql
```

## Key Learnings

This project provides practical experience in:

- Understanding dimensional data warehouse structures.
- Validating fact-table grain and relationship keys.
- Evaluating star-schema and snowflake modeling patterns.
- Designing relationships in Power BI.
- Writing DAX measures for business analysis.
- Connecting SQL validation results with Power BI reporting.
- Documenting technical decisions and building a reproducible analytics workflow.

Developed using SQL Server and Microsoft Power BI.
