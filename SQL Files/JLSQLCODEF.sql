/** Query for Product Performance **/
SELECT 
    P.[ProductID],
    P.[Name] AS [ProductName],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    SUM(SOD.[UnitPrice] * SOD.[OrderQty]) AS [TotalRevenue],
    AVG(SOD.[UnitPrice]) AS [AveragePrice]
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Production].[Product] AS P ON SOD.[ProductID] = P.[ProductID]
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Consider only reseller/store sales
GROUP BY P.[ProductID], P.[Name]
ORDER BY TotalRevenue DESC;  -- Sorting by total revenue


/** Query for Regional Performance **/
SELECT 
    ST.[Name] AS [Region],
    SUM(SOD.[OrderQty]) AS [TotalQuantitySold],
    SUM(SOD.[UnitPrice] * SOD.[OrderQty]) AS [TotalRevenue]
FROM [Sales].[SalesOrderDetail] AS SOD
JOIN [Sales].[SalesOrderHeader] AS SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
JOIN [Sales].[SalesTerritory] AS ST ON SOH.[TerritoryID] = ST.[TerritoryID]
WHERE SOH.[OnlineOrderFlag] = 0  -- Consider only reseller/store sales
GROUP BY ST.[Name]
ORDER BY TotalRevenue DESC;  -- Sorting by total revenue
