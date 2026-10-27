# Data Modeling Decisions

## 1. Overview

This document explains the modeling decisions used to organize AdventureWorksDW2019 in Power BI.

The model includes multiple fact tables and dimension tables to support analysis across sales, products, customers, geography, dates, finance, and other business areas.

The objective is to preserve data integrity while making the model understandable and suitable for analysis.

## 2. Modeling Approach

**Approach:** Primarily a star-schema model with limited snowflake relationships. Most dimension tables connect directly to fact tables, while some selected dimension-to-dimension relationships preserve the source database's normalized structure.

The model contains:

- **Fact tables:** Store business events and measurable values.
- **Dimension tables:** Provide descriptive information for analyzing facts.
- **Dimension-to-dimension relationships:** Connect related descriptive entities where the source data uses a hierarchy or shared reference.

Rather than forcing every table into one flat star schema, the model retains relationships that reflect the source data structure.

## 3. Fact and Dimension Relationships

### Dimension-to-fact relationships

Dimension tables have one-to-many relationships with the relevant fact tables.

- The dimension side represents the `1` side.
- The fact side represents the `*` side.
- A dimension record can be associated with multiple fact records.

This structure allows dimension attributes to filter and categorize transactional data.

Examples include customer, product, date, and other applicable dimensions connected to sales facts.

### Dimension-to-dimension relationships

Some relationships connect one dimension to another through a one-to-many relationship.

Example:

`DimGeography (1) → DimCustomer (*)`

A geography record can be associated with multiple customer records.

This creates a snowflake-style structure because geographic attributes are stored separately from customer attributes.

The same principle applies to other dimension-to-dimension relationships where the source structure and validated keys support them.

## 4. Snowflake Relationships

The model retains certain dimension-to-dimension relationships rather than automatically flattening all descriptive attributes into one table.

Potential benefits include:

- Reducing repeated descriptive data.
- Preserving the source database's dimensional structure.
- Keeping geographic and other shared attributes in their relevant tables.

Potential trade-offs include:

- More relationships to understand and maintain.
- Longer filter paths.
- Greater need to validate filter propagation and avoid ambiguous paths.

These relationships should remain only where they support the intended analytical behavior and have been validated.

## 5. Relationship Cardinality

The model uses one-to-many relationships where the data supports a unique key on the `1` side.

| Relationship pattern        | Cardinality                         | Meaning                                               |
|-----------------------------|-------------------------------------|-------------------------------------------------------|
| Dimension → Fact            | One-to-many (`1:*`)                 | One dimension record can relate to many fact records  |
| Geography → Customer        | One-to-many (`1:*`)                 | One geography record can relate to multiple customers |
| Other Dimension → Dimension | One-to-many (`1:*`) where validated | One parent dimension record can relate to multiple records in the related dimension |

Cardinality must be supported by key uniqueness and the underlying data. Relationships should not be assumed correct solely because Power BI allows them to be created.

## 6. Filter Direction

Filter direction should be selected according to the intended analytical behavior.

Single-direction filtering from the `1` side to the `*` side is the preferred starting point for dimension-to-fact relationships.

For dimension-to-dimension relationships, confirm that filters propagate through the model as intended. Avoid enabling bidirectional filtering by default because it can introduce ambiguity or unexpected results.

## 7. Date Modeling

`DimDate` provides calendar attributes for time-based analysis.

The date dimension should support consistent reporting by year, quarter, month, and day.

Modeling considerations:

- Connect the appropriate date keys to their corresponding fact tables.
- Mark `DimDate` as the date table when its date column meets Power BI's requirements.
- Review fact tables with multiple date columns and determine which date relationship should be active.
- Validate date filtering across each relevant fact table.

## 8. Data Integrity and Validation

The relationship structure should be validated using SQL Server and Power BI.

Validation should include:

- Confirming uniqueness of keys on the `1` side.
- Checking for unmatched foreign keys.
- Reviewing null relationship keys.
- Confirming that filters reach the intended fact tables.
- Checking for ambiguous relationship paths.
- Comparing selected Power BI totals with SQL query results.

Detailed SQL queries and grain-validation results are maintained separately in the SQL project rather than duplicated in this document.

## 9. Final Modeling Principles

The model follows these principles:

1. Use one-to-many relationships when supported by the data.
2. Keep fact tables at their validated grain.
3. Use dimensions to provide descriptive context for analysis.
4. Retain dimension-to-dimension relationships where they serve a clear purpose.
5. Prefer simple, predictable filter propagation.
6. Validate relationship integrity and analytical results before finalizing the model.

The goal is not simply to reproduce the source database, but to create a Power BI model that produces reliable results and remains understandable and maintainable.