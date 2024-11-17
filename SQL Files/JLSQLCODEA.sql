
/**Compare Sales Over Time (Monthly)**/
SELECT 
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY MonthYear;



/**Compare Profit Over Time**/

SELECT 
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOD.OrderQty * (SOD.UnitPrice - SOD.UnitPriceDiscount)) AS TotalProfit
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY MonthYear;



/**Analyze the Shift by Region**/

SELECT 
    ST.Name AS Region,
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY 
    ST.Name, 
    FORMAT(SOH.OrderDate, 'yyyy-MM'), 
    SOH.OnlineOrderFlag
ORDER BY Region, MonthYear;





/**Analyze the Shift by Product Categories**/

SELECT 
    PC.Name AS ProductCategory,
    PSC.Name AS ProductSubcategory,
    FORMAT(SOH.OrderDate, 'yyyy-MM') AS MonthYear,
    SOH.OnlineOrderFlag,
    SUM(SOH.TotalDue) AS TotalRevenue,
    SUM(SOD.OrderQty) AS TotalOrderQuantity
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





