Select * from [Sales].[SalesOrderHeaderSalesReason] as A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID



SELECT 
A.[SalesOrderID]
,CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END AS SalesReason_Price
,CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END AS SalesReason_Quality
,CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END AS SalesReason_Review
,CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END AS SalesReason_Other
,CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END AS SalesReason_TV
,CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END AS SalesReason_Manufacturer
,CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
order by A.[SalesOrderID];




SELECT 
A.[SalesOrderID]
,max(CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END) AS SalesReason_Price
,max(CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END) AS SalesReason_Quality
,max(CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END) AS SalesReason_Review
,Max(CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END) AS SalesReason_Other
,max(CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END) AS SalesReason_TV
,max(CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END) AS SalesReason_Manufacturer
,max(CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END) AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
group by A.[SalesOrderID]
order by A.[SalesOrderID];


SELECT 
A.[SalesOrderID]
,sum(CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END) AS SalesReason_Price
,sum(CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END) AS SalesReason_Quality
,sum(CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END) AS SalesReason_Review
,sum(CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END) AS SalesReason_Other
,sum(CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END) AS SalesReason_TV
,sum(CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END) AS SalesReason_Manufacturer
,sum(CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END) AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
group by A.[SalesOrderID];


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [CurrencyRateID]
      ,[CurrencyRateDate]
      ,[FromCurrencyCode]
      ,[ToCurrencyCode]
      ,[AverageRate]
      ,[EndOfDayRate]
      ,[ModifiedDate]
  FROM [AdventureWorks2012].[Sales].[CurrencyRate]
  
  SELECT 
  A.[SalesOrderID]
  ,A.[OrderDate]
  ,A.[CurrencyRateID]
  ,B.[AverageRate]
  ,B.[EndOfDayRate]
  FROM [Sales].[SalesOrderHeader] AS A
  LEFT JOIN [AdventureWorks2012].[Sales].[CurrencyRate] AS B
  ON A.CurrencyRateID = B.CurrencyRateID AND A.[OrderDate] = B.[CurrencyRateDate]






