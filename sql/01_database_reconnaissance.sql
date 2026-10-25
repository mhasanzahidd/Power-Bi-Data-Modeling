/* 
Purpose:
    Explore the AdventureWorksDW2019 database structure to support initial data discovery and Power BI data modeling. 
    The queries identify database objects, estimate table row counts, inspect column metadata, and provide a 
    preliminary classification of fact and dimension tables. 
*/

USE AdventureWorksDW2019;

-- 1. Inventory tables and views by schema and object type.
SELECT
    s.name AS SchemaName,
    o.name AS ObjectName,
    o.type_desc AS ObjectType
FROM sys.objects AS o
JOIN sys.schemas AS s
    ON o.schema_id = s.schema_id
WHERE o.type IN ('U', 'V')
ORDER BY
    o.type_desc,
    s.name,
    o.name;


-- 2. Estimate row counts to identify table sizes and prioritize exploration.
-- Index IDs 0 and 1 represent heaps and clustered indexes, avoiding duplicate counts.
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS TotalRows
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.partitions AS p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY
    s.name,
    t.name
ORDER BY
    TotalRows DESC,
    TableName;


-- 3. Inspect column metadata to assess data types, nullability, and modeling requirements.
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    c.column_id AS ColumnPosition,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLengthBytes,
    c.precision AS NumericPrecision,
    c.scale AS NumericScale,
    c.is_nullable AS IsNullable
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.columns AS c
    ON t.object_id = c.object_id
JOIN sys.types AS ty
    ON c.user_type_id = ty.user_type_id
ORDER BY
    s.name,
    t.name,
    c.column_id;


-- 4. Classify tables by naming convention as a starting point for data modeling.
-- These labels are provisional; confirm each table's grain and business purpose.
SELECT
    t.name AS TableName,
    CASE
        WHEN t.name LIKE 'Fact%' THEN 'Candidate Fact'
        WHEN t.name LIKE 'Dim%'  THEN 'Candidate Dimension'
        ELSE 'Investigate'
    END AS PreliminaryClassification,
    SUM(p.rows) AS TotalRows
FROM sys.tables AS t
JOIN sys.partitions AS p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY PreliminaryClassification, t.name;
