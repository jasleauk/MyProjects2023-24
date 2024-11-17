/** Create Table for Monthly Sales Comparison **/
SELECT 
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
INTO MonthlySalesComparison
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY MonthYear;


/** Create Table for Monthly Profit Comparison **/
SELECT 
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOD.OrderQty * (SOD.UnitPrice - SOD.UnitPriceDiscount)) AS TotalProfit
INTO MonthlyProfitComparison
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY MonthYear;


/** Create Table for Sales Shift by Region **/
SELECT 
    ST.Name AS Region,
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
INTO SalesShiftByRegion
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY 
    ST.Name, 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY Region, MonthYear;


/** Create Table for Sales Shift by Product Categories **/
SELECT 
    PC.Name AS ProductCategory,
    PSC.Name AS ProductSubcategory,
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
INTO SalesShiftByProductCategories
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product P ON SOD.ProductID = P.ProductID
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY 
    PC.Name, 
    PSC.Name, 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY ProductCategory, ProductSubcategory, MonthYear;




/** Create Table for Online Customer Data **/
SELECT 
    A.CustomerID,
    A.OnlineOrderFlag,
    A.OrderDate,
    B.FirstName,
    B.LastName,
    B.EmailAddress,
    B.Gender,
    B.MaritalStatus,
    B.YearlyIncome,
    B.BirthDate
INTO OnlineCustomerData
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1;


/** Create Table for Age Distribution Over Time **/
SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    DATEDIFF(YEAR, B.BirthDate, GETDATE()) AS CustomerAge,
    COUNT(*) AS CustomerCount
INTO AgeDistributionOverTime
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    DATEDIFF(YEAR, B.BirthDate, GETDATE())
ORDER BY OrderYear, CustomerAge;


/** Create Table for Gender Distribution Over Time **/
SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    B.Gender,
    COUNT(*) AS CustomerCount
INTO GenderDistributionOverTime
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    B.Gender
ORDER BY OrderYear, B.Gender;


/** Create Table for Income Distribution **/
SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    B.YearlyIncome,
    COUNT(*) AS CustomerCount
INTO IncomeDistribution
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    B.YearlyIncome
ORDER BY OrderYear, B.YearlyIncome;



/** Create Table for Decline in Store Sales **/
SELECT 
    FORMAT([OrderDate], 'yyyy-MM') AS [MonthYear],
    SUM([TotalDue]) AS [TotalStoreSales],
    COUNT([SalesOrderID]) AS [NumberOfTransactions]
INTO DeclineInStoreSales
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY FORMAT([OrderDate], 'yyyy-MM')
ORDER BY [MonthYear];


/** Create Table for Sales Volume **/
SELECT 
    SUM([SOD].[OrderQty]) AS [TotalSalesVolume]
INTO SalesVolume
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Total Costs **/
SELECT 
    SUM([SOD].[OrderQty] * ([SOD].[UnitPrice] - [SOD].[UnitPriceDiscount])) AS [TotalCosts]
INTO TotalCosts
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Total Revenue **/
SELECT 
    SUM([TotalDue]) AS [TotalRevenue]
INTO TotalRevenue
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Average Transaction Value **/
SELECT 
    AVG([TotalDue]) AS [AverageTransactionValue]
INTO AverageTransactionValue
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Cost Per Sale **/
SELECT 
    SUM([SOD].[OrderQty] * ([SOD].[UnitPrice] - [SOD].[UnitPriceDiscount])) / NULLIF(COUNT([SOH].[SalesOrderID]), 0) AS [CostPerSale]
INTO CostPerSale
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Revenue Per Customer **/
SELECT 
    SUM([TotalDue]) / NULLIF(COUNT(DISTINCT [CustomerID]), 0) AS [RevenuePerCustomer]
INTO RevenuePerCustomer
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales


/** Create Table for Average Transaction per Customer **/
SELECT 
    COUNT([SOH].[SalesOrderID]) / NULLIF(COUNT(DISTINCT [CustomerID]), 0) AS [AverageTransactionPerCustomer]
INTO AverageTransactionPerCustomer
FROM [Sales].[SalesOrderHeader] AS [SOH]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales



/** Create Table for Selling Price vs. Cost Price **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    AVG(SOD.[UnitPrice]) AS [AverageSellingPrice],
    SUM(SOD.[OrderQty] * (SOD.[UnitPrice] - SOD.[UnitPriceDiscount])) AS [TotalRevenue],
    P.[StandardCost] AS [StandardCost],
    AVG(SOD.[UnitPrice]) - P.[StandardCost] AS [PriceDifference]  
INTO PriceVsCost
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY P.[ProductID], P.[Name], P.[StandardCost]
HAVING AVG(SOD.[UnitPrice]) < P.[StandardCost]  -- Check for Selling Below Cost
ORDER BY [PriceDifference];


  
/** Create Table for Average Time to Deliver Products **/
SELECT 
    AVG(DATEDIFF(DAY, [OrderDate], [ShipDate])) AS [AverageDeliveryTime],
    [ST].[Name] AS [Region]
INTO AverageDeliveryTime
FROM [Sales].[SalesOrderHeader] AS [SOH]
JOIN [Sales].[SalesTerritory] AS [ST] ON [SOH].[TerritoryID] = [ST].[TerritoryID]
WHERE [SOH].[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY [ST].[Name];


  
/** Create Table for Investigating Discounts **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    AVG(SOD.[UnitPriceDiscount]) AS [AverageDiscount],
    SUM(SOD.[OrderQty] * (SOD.[UnitPrice] - SOD.[UnitPriceDiscount])) AS [TotalRevenue],
    SUM(SOD.[OrderQty] * SOD.[UnitPriceDiscount]) AS [TotalDiscountAmount]
INTO InvestigateDiscounts
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY P.[ProductID], P.[Name]
HAVING AVG(SOD.[UnitPriceDiscount]) > 0;  -- Only include products with discounts


  
/** Create Table for Analyzing Product Returns **/
SELECT 
    COUNT(SOD.[SalesOrderID]) AS [TotalReturns],
    SUM(SOD.[OrderQty]) AS [TotalQuantityReturned],
    ST.[Name] AS [Region]
INTO AnalyzeProductReturns
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
JOIN [Sales].[SalesTerritory] AS ST ON SOH.[TerritoryID] = ST.[TerritoryID]
WHERE SOD.[OrderQty] < 0  -- If negative quantity indicates a return
GROUP BY ST.[Name];

  
/** Create Table for Cost-Effectiveness of Manufacturing Locations **/
SELECT 
    P.[ProductSubcategoryID],  -- Adjust based on your findings
    SUM(P.[StandardCost]) AS [TotalManufacturingCost]
INTO CostEffectivenessOfManufacturingLocations
FROM [Production].[Product] AS P
GROUP BY P.[ProductSubcategoryID]  -- Group by the identified column
ORDER BY [TotalManufacturingCost] ASC;  -- To find the most cost-effective categories



/** Create Table for Product Performance **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    SUM(SOD.[UnitPrice] * SOD.[OrderQty]) AS [TotalRevenue],
    AVG(SOD.[UnitPrice]) AS [AveragePrice]
INTO ProductPerformance
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Consider only reseller/store sales
GROUP BY P.[ProductID], P.[Name]
ORDER BY TotalRevenue DESC;  -- Sorting by total revenue


/** Create Table for Regional Performance **/
SELECT 
    ST.[Name] AS [Region],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    SUM(SOD.[UnitPrice] * SOD.[OrderQty]) AS [TotalRevenue]
INTO RegionalPerformance
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
JOIN [Sales].[SalesTerritory] AS ST ON SOH.[TerritoryID] = ST.[TerritoryID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Consider only reseller/store sales
GROUP BY ST.[Name]
ORDER BY TotalRevenue DESC;  -- Sorting by total revenue
