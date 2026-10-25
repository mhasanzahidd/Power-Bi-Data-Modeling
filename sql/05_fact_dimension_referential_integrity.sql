/* Purpose:
    Validate referential integrity between AdventureWorksDW2019 fact and dimension tables, identify unmatched 
    foreign-key values, investigate affected Internet Sales records, check product-key uniqueness, and compare 
    date-key coverage across order, shipping, and due-date roles. These checks support reliable relationship design 
    in Power BI. 
*/

USE AdventureWorksDW2019;

-- 1. Count Internet Sales rows without a matching customer dimension record.
SELECT COUNT_BIG(*) AS UnmatchedCustomerRows
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimCustomer AS d
    ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL;


-- 2. Count Internet Sales rows without a matching product dimension record.
SELECT COUNT_BIG(*) AS UnmatchedProductRows
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimProduct AS d
    ON f.ProductKey = d.ProductKey
WHERE d.ProductKey IS NULL;


-- 3. Check whether every Internet Sales order date matches DimDate.
SELECT COUNT_BIG(*) AS UnmatchedOrderDateRows
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
WHERE d.DateKey IS NULL;


-- 4. Count Reseller Sales rows without a matching reseller dimension record.
SELECT COUNT_BIG(*) AS UnmatchedResellerRows
FROM dbo.FactResellerSales AS f
LEFT JOIN dbo.DimReseller AS d
    ON f.ResellerKey = d.ResellerKey
WHERE d.ResellerKey IS NULL;


-- 5. Check product-key matches in Reseller Sales.
SELECT COUNT_BIG(*) AS UnmatchedProductRows
FROM dbo.FactResellerSales AS f
LEFT JOIN dbo.DimProduct AS d
    ON f.ProductKey = d.ProductKey
WHERE d.ProductKey IS NULL;


-- 6. Identify customer keys associated with unmatched Internet Sales rows.
-- A NULL CustomerKey can also appear here because it cannot match a dimension key.
SELECT
    f.CustomerKey,
    COUNT_BIG(*) AS AffectedSalesRows
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimCustomer AS d
    ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL
GROUP BY f.CustomerKey
ORDER BY AffectedSalesRows DESC;


-- 7. Verify that ProductKey uniquely identifies rows in DimProduct.
SELECT
    ProductKey,
    COUNT_BIG(*) AS KeyCount
FROM dbo.DimProduct
GROUP BY ProductKey
HAVING COUNT_BIG(*) > 1;


-- 8. Identify products appearing in multiple Internet Sales rows.
-- Repeated product keys are expected in a sales fact table and are not
-- evidence of duplicate records by themselves.
SELECT
    ProductKey,
    COUNT_BIG(*) AS SalesRows
FROM dbo.FactInternetSales
GROUP BY ProductKey
HAVING COUNT_BIG(*) > 1
ORDER BY SalesRows DESC;


-- 9. Compare distinct date-key coverage for the three date roles.
SELECT
    'OrderDateKey' AS DateRole,
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT OrderDateKey) AS DistinctDates
FROM dbo.FactInternetSales

UNION ALL

SELECT
    'ShipDateKey',
    COUNT_BIG(*),
    COUNT(DISTINCT ShipDateKey)
FROM dbo.FactInternetSales

UNION ALL

SELECT
    'DueDateKey',
    COUNT_BIG(*),
    COUNT(DISTINCT DueDateKey)
FROM dbo.FactInternetSales;
