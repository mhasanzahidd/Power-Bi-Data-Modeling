/* 
Purpose:
    Validate the DimDate dimension in AdventureWorksDW2019 for date coverage, key uniqueness, calendar continuity, 
    and referential integrity with Internet Sales order dates. These checks help ensure reliable date-based 
    filtering and time intelligence in Power BI. 
*/

USE AdventureWorksDW2019;

-- 1. Profile the date dimension's size and calendar coverage.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT DateKey) AS DistinctDateKeys,
    MIN(FullDateAlternateKey) AS FirstDate,
    MAX(FullDateAlternateKey) AS LastDate
FROM dbo.DimDate;


-- 2. Identify duplicate date keys that could affect relationship integrity.
SELECT
    DateKey,
    COUNT_BIG(*) AS KeyCount
FROM dbo.DimDate
GROUP BY DateKey
HAVING COUNT_BIG(*) > 1;


-- 3. Detect gaps or irregular intervals between consecutive calendar dates.
WITH Calendar AS
(
    SELECT
        FullDateAlternateKey,
        LEAD(FullDateAlternateKey) OVER (
            ORDER BY FullDateAlternateKey
        ) AS NextDate
    FROM dbo.DimDate
)
SELECT
    FullDateAlternateKey,
    NextDate
FROM Calendar
WHERE NextDate IS NOT NULL
  AND DATEDIFF(DAY, FullDateAlternateKey, NextDate) <> 1
ORDER BY FullDateAlternateKey;


-- 4. Count Internet Sales rows whose order-date keys do not match DimDate.
SELECT COUNT_BIG(*) AS UnmatchedOrderDates
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
WHERE d.DateKey IS NULL;
