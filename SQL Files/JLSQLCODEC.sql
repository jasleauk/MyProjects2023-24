/** Check for a Decline in Store Sales **/
SELECT 
    FORMAT([OrderDate], 'yyyy-MM') AS [MonthYear],
    SUM([TotalDue]) AS [TotalStoreSales],
    COUNT([SalesOrderID]) AS [NumberOfTransactions]
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0  -- Reseller/Store Sales
GROUP BY FORMAT([OrderDate], 'yyyy-MM')
ORDER BY [MonthYear];

/** Sales Volume **/
SELECT 
    SUM([SOD].[OrderQty]) AS [TotalSalesVolume]
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales

/** Total Costs **/
SELECT 
    SUM([SOD].[OrderQty] * ([SOD].[UnitPrice] - [SOD].[UnitPriceDiscount])) AS [TotalCosts]
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales

/** Total Revenue **/
SELECT 
    SUM([TotalDue]) AS [TotalRevenue]
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales

/** Average Transaction Value **/
SELECT 
    AVG([TotalDue]) AS [AverageTransactionValue]
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales

/** Cost Per Sale **/
SELECT 
    SUM([SOD].[OrderQty] * ([SOD].[UnitPrice] - [SOD].[UnitPriceDiscount])) / COUNT([SOH].[SalesOrderID]) AS [CostPerSale]
FROM [Sales].[SalesOrderDetail] AS [SOD]
JOIN [Sales].[SalesOrderHeader] AS [SOH] ON [SOD].[SalesOrderID] = [SOH].[SalesOrderID]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales

/** Revenue Per Customer **/
SELECT 
    SUM([TotalDue]) / COUNT(DISTINCT [CustomerID]) AS [RevenuePerCustomer]
FROM [Sales].[SalesOrderHeader]
WHERE [OnlineOrderFlag] = 0;  -- Store Sales

/** Average Transaction per Customer **/
SELECT 
    COUNT([SOH].[SalesOrderID]) / COUNT(DISTINCT [CustomerID]) AS [AverageTransactionPerCustomer]
FROM [Sales].[SalesOrderHeader] AS [SOH]
WHERE [SOH].[OnlineOrderFlag] = 0;  -- Store Sales
