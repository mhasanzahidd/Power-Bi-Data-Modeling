/* 
Purpose:
    Explore additional AdventureWorksDW2019 fact and dimension tables to understand sales reasons, 
    employee sales quotas, currency exchange rates, financial records, and employee reporting hierarchies. 
    The results support data-grain validation, relationship design, and business analysis in Power BI. 
*/

USE AdventureWorksDW2019;

-- 1. Inspect sales reasons associated with individual Internet Sales order lines.
SELECT TOP (50)
    r.SalesOrderNumber,
    r.SalesOrderLineNumber,
    r.SalesReasonKey,
    s.SalesReasonName,
    s.SalesReasonReasonType
FROM dbo.FactInternetSalesReason AS r
LEFT JOIN dbo.DimSalesReason AS s
    ON r.SalesReasonKey = s.SalesReasonKey
ORDER BY
    r.SalesOrderNumber,
    r.SalesOrderLineNumber;


-- 2. Profile quota records by employee, date, and quota-value variety.
SELECT
    COUNT_BIG(*) AS TotalRows,
    COUNT(DISTINCT EmployeeKey) AS Employees,
    COUNT(DISTINCT DateKey) AS Dates,
    COUNT(DISTINCT SalesAmountQuota) AS DistinctQuotaValues
FROM dbo.FactSalesQuota;


-- 3. Inspect individual employee sales quotas over time.
SELECT TOP (30)
    EmployeeKey,
    DateKey,
    SalesAmountQuota
FROM dbo.FactSalesQuota
ORDER BY EmployeeKey, DateKey;


-- 4. Examine daily currency exchange rates by currency.
SELECT TOP (30)
    CurrencyKey,
    DateKey,
    AverageRate,
    EndOfDayRate
FROM dbo.FactCurrencyRate
ORDER BY CurrencyKey, DateKey;


-- 5. Inspect financial amounts across dates, organizations, accounts, and scenarios.
SELECT TOP (30)
    DateKey,
    OrganizationKey,
    DepartmentGroupKey,
    AccountKey,
    ScenarioKey,
    Amount
FROM dbo.FactFinance
ORDER BY DateKey, OrganizationKey, AccountKey;


-- 6. Explore the employee-manager hierarchy using each employee's parent key.
-- ParentEmployeeKey identifies the reporting manager, where a manager is assigned.
SELECT
    EmployeeKey,
    ParentEmployeeKey,
    FirstName,
    LastName,
    Title
FROM dbo.DimEmployee
ORDER BY ParentEmployeeKey, EmployeeKey;
