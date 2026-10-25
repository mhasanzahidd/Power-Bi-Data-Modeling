/* 
Purpose:
    Profile FactInternetSales and selected DimProduct and DimCustomer fields in AdventureWorksDW2019 to assess 
    missing customer keys, data variety, numeric ranges, sales totals, product color distribution, text cleanliness, 
    and order and shipping date coverage for Power BI data preparation. 
*/

USE AdventureWorksDW2019;

-- 1. Measure missing CustomerKey values in Internet Sales.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT_BIG(CustomerKey) AS NonNullCustomerKeys,
    COUNT_BIG(*) - COUNT_BIG(CustomerKey) AS NullCustomerKeys
FROM dbo.FactInternetSales;


-- 2. Assess the variety of customers, products, and currencies in Internet Sales.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT CustomerKey) AS DistinctCustomers,
    COUNT(DISTINCT ProductKey) AS DistinctProducts,
    COUNT(DISTINCT CurrencyKey) AS DistinctCurrencies
FROM dbo.FactInternetSales;


-- 3. Inspect numeric ranges and total sales to identify unusual values.
SELECT
    MIN(OrderQuantity) AS MinQuantity,
    MAX(OrderQuantity) AS MaxQuantity,
    MIN(UnitPrice) AS MinUnitPrice,
    MAX(UnitPrice) AS MaxUnitPrice,
    MIN(SalesAmount) AS MinSalesAmount,
    MAX(SalesAmount) AS MaxSalesAmount,
    SUM(SalesAmount) AS TotalSales
FROM dbo.FactInternetSales;


-- 4. Examine product color distribution, including NULL or blank color categories.
SELECT
    Color,
    COUNT_BIG(*) AS ProductCount
FROM dbo.DimProduct
GROUP BY Color
ORDER BY ProductCount DESC;


-- 5. Find customer names with leading or trailing spaces.
-- LEN excludes trailing spaces, so the comparison is used to detect whitespace.
SELECT TOP (50)
    CustomerKey,
    FirstName,
    LastName,
    LEN(FirstName) AS FirstNameLength,
    LEN(LastName) AS LastNameLength
FROM dbo.DimCustomer
WHERE FirstName <> LTRIM(RTRIM(FirstName))
   OR LastName <> LTRIM(RTRIM(LastName));


-- 6. Inspect the date coverage of orders and shipments.
SELECT
    MIN(OrderDate) AS EarliestOrderDate,
    MAX(OrderDate) AS LatestOrderDate,
    MIN(ShipDate) AS EarliestShipDate,
    MAX(ShipDate) AS LatestShipDate,
    COUNT_BIG(*) AS TotalRows
FROM dbo.FactInternetSales;
