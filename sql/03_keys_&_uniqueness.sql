/* 
Purpose:
    Inspect primary and foreign key relationships in AdventureWorksDW2019, validate key uniqueness and nullability 
    in selected dimension tables, and identify repeated customer-product combinations in Internet Sales. 
    These checks support data-quality assessment and relationship design for the Power BI data model. 
*/

USE AdventureWorksDW2019;

-- 1. Identify primary keys and their column order, including composite keys.
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    kc.name AS PrimaryKeyName,
    c.name AS PrimaryKeyColumn,
    ic.key_ordinal AS KeyPosition
FROM sys.key_constraints AS kc
JOIN sys.tables AS t
    ON kc.parent_object_id = t.object_id
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.index_columns AS ic
    ON kc.parent_object_id = ic.object_id
   AND kc.unique_index_id = ic.index_id
JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE kc.type = 'PK'
ORDER BY s.name, t.name, ic.key_ordinal;


-- 2. Map declared foreign keys to identify database-enforced relationships.
SELECT
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.parent_object_id)
        AS ReferencingSchema,
    OBJECT_NAME(fk.parent_object_id)
        AS ReferencingTable,
    pc.name AS ReferencingColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id)
        AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id)
        AS ReferencedTable,
    rc.name AS ReferencedColumn
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.columns AS pc
    ON fkc.parent_object_id = pc.object_id
   AND fkc.parent_column_id = pc.column_id
JOIN sys.columns AS rc
    ON fkc.referenced_object_id = rc.object_id
   AND fkc.referenced_column_id = rc.column_id
ORDER BY ReferencingTable, ForeignKeyName;


-- 3. Check for duplicate customer keys that could prevent a one-to-many relationship.
SELECT
    CustomerKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimCustomer
GROUP BY CustomerKey
HAVING COUNT_BIG(*) > 1;


-- 4. Check product key uniqueness.
SELECT
    ProductKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimProduct
GROUP BY ProductKey
HAVING COUNT_BIG(*) > 1;


-- 5. Check date key uniqueness.
SELECT
    DateKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimDate
GROUP BY DateKey
HAVING COUNT_BIG(*) > 1;


-- 6. Check reseller key uniqueness.
SELECT
    ResellerKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimReseller
GROUP BY ResellerKey
HAVING COUNT_BIG(*) > 1;


-- 7. Check employee key uniqueness.
SELECT
    EmployeeKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimEmployee
GROUP BY EmployeeKey
HAVING COUNT_BIG(*) > 1;


-- 8. Check geography key uniqueness.
SELECT
    GeographyKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimGeography
GROUP BY GeographyKey
HAVING COUNT_BIG(*) > 1;


-- 9. Check sales territory key uniqueness.
SELECT
    SalesTerritoryKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimSalesTerritory
GROUP BY SalesTerritoryKey
HAVING COUNT_BIG(*) > 1;


-- 10. Check currency key uniqueness.
SELECT
    CurrencyKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimCurrency
GROUP BY CurrencyKey
HAVING COUNT_BIG(*) > 1;


-- 11. Check promotion key uniqueness.
SELECT
    PromotionKey,
    COUNT_BIG(*) AS DuplicateCount
FROM dbo.DimPromotion
GROUP BY PromotionKey
HAVING COUNT_BIG(*) > 1;


-- 12. Count null values in selected dimension keys.
-- A zero count indicates no missing key values in the checked column.
SELECT
    'DimCustomer' AS TableName,
    SUM(CASE WHEN CustomerKey IS NULL
        THEN 1 ELSE 0 END) AS NullKeyRows
FROM dbo.DimCustomer

UNION ALL

SELECT
    'DimProduct',
    SUM(CASE WHEN ProductKey IS NULL
        THEN 1 ELSE 0 END)
FROM dbo.DimProduct

UNION ALL

SELECT
    'DimDate',
    SUM(CASE WHEN DateKey IS NULL
        THEN 1 ELSE 0 END)
FROM dbo.DimDate;


-- 13. Find repeated customer-product combinations in Internet Sales.
-- Repeated combinations can be valid when customers purchase the same product
-- on different orders or order lines; this is not automatically a data-quality issue.
SELECT TOP (20)
    CustomerKey,
    ProductKey,
    COUNT_BIG(*) AS TotalRows
FROM dbo.FactInternetSales
GROUP BY CustomerKey, ProductKey
HAVING COUNT_BIG(*) > 1
ORDER BY TotalRows DESC;
