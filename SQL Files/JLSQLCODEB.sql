/**SQL Query to Retrieve Online Customer Data**/

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
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1;



/**Age Distribution Over Time**/

SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    DATEDIFF(YEAR, B.BirthDate, GETDATE()) AS CustomerAge,
    COUNT(*) AS CustomerCount
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    DATEDIFF(YEAR, B.BirthDate, GETDATE())
ORDER BY OrderYear, CustomerAge;



/**Gender Distribution Over Time**/
SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    B.Gender,
    COUNT(*) AS CustomerCount
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    B.Gender
ORDER BY OrderYear, B.Gender;




/** Income Distribution**/
SELECT 
    YEAR(A.OrderDate) AS OrderYear,
    B.YearlyIncome,
    COUNT(*) AS CustomerCount
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [AdventureWorksDW2012].[dbo].[DimCustomer] AS B
    ON A.CustomerID = B.CustomerKey
WHERE A.OnlineOrderFlag = 1
GROUP BY 
    YEAR(A.OrderDate), 
    B.YearlyIncome
ORDER BY OrderYear, B.YearlyIncome;
