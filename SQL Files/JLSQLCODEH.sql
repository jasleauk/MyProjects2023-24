WITH ProductPairs AS (
    SELECT 
        S1.ProductID AS Product1,
        S2.ProductID AS Product2,
        COUNT(*) AS PairCount
    FROM 
        Sales.SalesOrderDetail S1
    JOIN 
        Sales.SalesOrderDetail S2 ON S1.SalesOrderID = S2.SalesOrderID 
    WHERE 
        S1.ProductID <> S2.ProductID  -- Ensure not the same product
    GROUP BY 
        S1.ProductID, S2.ProductID
)

SELECT 
    Product1,
    Product2,
    PairCount
FROM 
    ProductPairs
ORDER BY 
    PairCount DESC;  -- Order by the most frequently purchased pairs


