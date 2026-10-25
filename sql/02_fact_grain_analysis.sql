/* 
Purpose:
    Investigate the structure and candidate grain of AdventureWorksDW2019 fact tables. Profile key dimensions 
    and measures, identify duplicate candidate keys, and validate whether each table's rows represent the expected 
    business-level records for Power BI data modeling. 
*/

USE AdventureWorksDW2019;

-- 1. Inspect columns in fact tables to identify potential keys and measures.
SELECT
    t.name AS TableName,
    c.column_id,
    c.name AS ColumnName,
    ty.name AS DataType
FROM sys.tables AS t
JOIN sys.columns AS c
    ON t.object_id = c.object_id
JOIN sys.types AS ty
    ON c.user_type_id = ty.user_type_id
WHERE t.name LIKE 'Fact%'
ORDER BY t.name, c.column_id;


-- 2. Profile Internet Sales and compare orders, customers, products, dates, and order lines.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT SalesOrderNumber) AS DistinctOrders,
    COUNT(DISTINCT CustomerKey) AS DistinctCustomers,
    COUNT(DISTINCT ProductKey) AS DistinctProducts,
    COUNT(DISTINCT OrderDateKey) AS DistinctOrderDates,
    COUNT(DISTINCT SalesOrderNumber + '-'
        + CAST(SalesOrderLineNumber AS varchar(10)))
        AS DistinctOrderLines
FROM dbo.FactInternetSales;


-- 3. Find duplicate Internet Sales order-line combinations.
-- Expected result for a unique order-line grain: zero rows.
SELECT TOP (20)
    SalesOrderNumber,
    SalesOrderLineNumber,
    COUNT_BIG(*) AS RowsAtThisGrain
FROM dbo.FactInternetSales
GROUP BY
    SalesOrderNumber,
    SalesOrderLineNumber
HAVING COUNT_BIG(*) > 1
ORDER BY RowsAtThisGrain DESC;


-- 4. Profile Reseller Sales at the order, reseller, product, and date levels.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT SalesOrderNumber) AS DistinctOrders,
    COUNT(DISTINCT ResellerKey) AS DistinctResellers,
    COUNT(DISTINCT ProductKey) AS DistinctProducts,
    COUNT(DISTINCT OrderDateKey) AS DistinctOrderDates
FROM dbo.FactResellerSales;


-- 5. Test whether each reseller sales order-line combination is unique.
-- Expected result for a unique order-line grain: zero rows.
SELECT TOP (20)
    SalesOrderNumber,
    SalesOrderLineNumber,
    COUNT_BIG(*) AS RowsAtThisGrain
FROM dbo.FactResellerSales
GROUP BY
    SalesOrderNumber,
    SalesOrderLineNumber
HAVING COUNT_BIG(*) > 1
ORDER BY RowsAtThisGrain DESC;


-- 6. Profile survey responses across product categories, subcategories, and customers.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT ProductCategoryKey) AS DistinctCategories,
    COUNT(DISTINCT ProductSubcategoryKey) AS DistinctSubCategories,
    COUNT(DISTINCT CustomerKey) AS DistinctCustomers
FROM dbo.FactSurveyResponse;


-- 7. Check whether SurveyResponseKey uniquely identifies each row.
-- Expected result for a unique order-line grain: zero rows.
SELECT TOP (20)
    SurveyResponseKey,
    COUNT_BIG(*) AS RowsAtThisGrain
FROM dbo.FactSurveyResponse
GROUP BY
    SurveyResponseKey
HAVING COUNT_BIG(*) > 1
ORDER BY RowsAtThisGrain DESC;


-- 8. Profile finance records and calculate the total recorded amount.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT OrganizationKey) AS DistinctOrganizations,
    COUNT(DISTINCT DepartmentGroupKey) AS DistinctDepartmentGroup,
    COUNT(DISTINCT AccountKey) AS DistinctAccounts,
    SUM(Amount) AS TotalAmount
FROM dbo.FactFinance;


-- 9. Check whether FinanceKey uniquely identifies each row.
-- Expected result for a unique order-line grain: zero rows.
SELECT TOP (20)
    FinanceKey,
    COUNT_BIG(*) AS RowsAtThisGrain
FROM dbo.FactFinance
GROUP BY
    FinanceKey
HAVING COUNT_BIG(*) > 1
ORDER BY RowsAtThisGrain DESC;


-- 10. Profile sales quotas by employee and calculate the total quota.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT EmployeeKey) AS DistinctEmployees,
    SUM(SalesAmountQuota) AS TotalSalesQuota
FROM dbo.FactSalesQuota;


-- 11. Check whether SalesQuotaKey uniquely identifies each row.
-- Expected result for a unique order-line grain: zero rows.
SELECT TOP (20)
    SalesQuotaKey,
    COUNT_BIG(*) AS RowsAtThisGrain
FROM dbo.FactSalesQuota
GROUP BY
    SalesQuotaKey
HAVING COUNT_BIG(*) > 1
ORDER BY RowsAtThisGrain DESC;


-- 12. Profile inventory records and inspect product-level measures.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT ProductKey) AS DistinctProducts,
    SUM(DISTINCT UnitCost) AS TotalUnitCost,
    SUM(DISTINCT UnitsBalance) AS TotalUnitsBalance
FROM dbo.FactProductInventory;
