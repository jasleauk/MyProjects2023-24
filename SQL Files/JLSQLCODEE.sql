/** Check Selling Price vs. Cost Price **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    AVG(SOD.[UnitPrice]) AS [AverageSellingPrice],
    SUM(SOD.[OrderQty] * (SOD.[UnitPrice] - SOD.[UnitPriceDiscount])) AS [TotalRevenue],
    P.[StandardCost] AS [StandardCost],  -- Include StandardCost in SELECT
    AVG(SOD.[UnitPrice]) - P.[StandardCost] AS [PriceDifference]  
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY P.[ProductID], P.[Name], P.[StandardCost]  -- Include StandardCost in GROUP BY
HAVING AVG(SOD.[UnitPrice]) < P.[StandardCost]  -- Check for Selling Below Cost
ORDER BY [PriceDifference];


/** Average Time to Deliver Products **/
SELECT 
    AVG(DATEDIFF(DAY, [OrderDate], [ShipDate])) AS [AverageDeliveryTime],
    [ST].[Name] AS [Region]
FROM [Sales].[SalesOrderHeader] AS [SOH]
JOIN [Sales].[SalesTerritory] AS [ST] ON [SOH].[TerritoryID] = [ST].[TerritoryID]  -- Verify this column name
WHERE [SOH].[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY [ST].[Name];


/** Investigate Discounts **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    AVG(SOD.[UnitPriceDiscount]) AS [AverageDiscount],
    SUM(SOD.[OrderQty] * (SOD.[UnitPrice] - SOD.[UnitPriceDiscount])) AS [TotalRevenue],
    SUM(SOD.[OrderQty] * SOD.[UnitPriceDiscount]) AS [TotalDiscountAmount]
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY P.[ProductID], P.[Name]
HAVING AVG(SOD.[UnitPriceDiscount]) > 0;  -- Only include products with discounts


/** Analyze Product Returns **/
SELECT 
    COUNT(SOD.[SalesOrderID]) AS [TotalReturns],
    SUM(SOD.[OrderQty]) AS [TotalQuantityReturned],
    ST.[Name] AS [Region]
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
JOIN [Sales].[SalesTerritory] AS ST ON SOH.[TerritoryID] = ST.[TerritoryID]
WHERE SOD.[OrderQty] < 0  -- If negative quantity indicates a return
GROUP BY ST.[Name];


/** Cost-Effectiveness of Manufacturing Locations **/
SELECT 
    P.[ProductSubcategoryID],  -- Adjust based on your findings
    SUM(P.[StandardCost]) AS [TotalManufacturingCost]  -- Ensure this column exists
FROM [Production].[Product] AS P
GROUP BY P.[ProductSubcategoryID]  -- Group by the identified column
ORDER BY [TotalManufacturingCost] ASC;  -- To find the most cost-effective categories


