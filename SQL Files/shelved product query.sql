SELECT 
    SOH.SalesOrderID AS OrderID,
    SOD.ProductID,
    P.Name AS ProductName,
    C.TerritoryID AS TerritoryID,  -- TerritoryID from Customer
    ST.Name AS TerritoryName         -- Territory Name from Sales.SalesTerritory
FROM 
    Sales.SalesOrderHeader AS SOH
JOIN 
    Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN 
    Production.Product AS P ON SOD.ProductID = P.ProductID
JOIN 
    Sales.Customer AS C ON SOH.CustomerID = C.CustomerID
JOIN 
    Sales.SalesTerritory AS ST ON C.TerritoryID = ST.TerritoryID  -- Joining with SalesTerritory table
ORDER BY 
    SOH.SalesOrderID;
