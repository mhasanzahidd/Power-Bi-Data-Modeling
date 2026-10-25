/* 
Purpose:
    Analyze AdventureWorksDW2019 sales performance and inventory activity. Summarize Internet Sales, 
    inspect individual sales lines, compare Internet and Reseller sales channels, and examine inventory 
    movements and balances by date and product to support Power BI analytics. 
*/

USE AdventureWorksDW2019;

-- 1. Summarize Internet Sales volume, revenue, tax, and freight.
SELECT
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT SalesOrderNumber) AS Orders,
    SUM(OrderQuantity) AS TotalQuantity,
    SUM(SalesAmount) AS TotalSales,
    SUM(TaxAmt) AS TotalTax,
    SUM(Freight) AS TotalFreight
FROM dbo.FactInternetSales;


-- 2. Inspect individual sales lines to understand pricing, discounts, and sales amounts.
SELECT TOP (50)
    SalesOrderNumber,
    SalesOrderLineNumber,
    OrderQuantity,
    UnitPrice,
    UnitPriceDiscountPct,
    DiscountAmount,
    ProductStandardCost,
    SalesAmount
FROM dbo.FactInternetSales
ORDER BY SalesOrderNumber, SalesOrderLineNumber;


-- 3. Compare sales volume, order counts, and revenue across the two sales channels.
SELECT
    'Internet' AS SalesChannel,
    COUNT_BIG(*) AS SalesLines,
    COUNT(DISTINCT SalesOrderNumber) AS Orders,
    SUM(SalesAmount) AS TotalSales
FROM dbo.FactInternetSales

UNION ALL

SELECT
    'Reseller',
    COUNT_BIG(*),
    COUNT(DISTINCT SalesOrderNumber),
    SUM(SalesAmount)
FROM dbo.FactResellerSales;


-- 4. Aggregate inventory movements and balances by date and product.
-- TOP limits the displayed result to 30 grouped records, not 30 source rows.
SELECT TOP (30)
    DateKey,
    ProductKey,
    SUM(UnitsIn) AS UnitsIn,
    SUM(UnitsOut) AS UnitsOut,
    SUM(UnitsBalance) AS UnitsBalance
FROM dbo.FactProductInventory
GROUP BY DateKey, ProductKey
ORDER BY DateKey, ProductKey;
