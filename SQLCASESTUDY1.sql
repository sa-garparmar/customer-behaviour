CREATE DATABASE [Case_Study1]

USE [Case_Study1]

--Q1


SELECT COUNT(customer_id)  FROM [dbo].[Customer] UNION 
SELECT COUNT(prod_cat)  FROM [dbo].[prod_cat_info] UNION
SELECT COUNT(transaction_id) FROM [dbo].[Transactions] 


--Q2

SELECT COUNT(*) FROM  [dbo].[Transactions]
WHERE CAST(total_amt AS float)  < 0

--Q3

SELECT CONVERT(date, tran_date, 105) as DATE From [dbo].[Transactions] UNION
SELECT CONVERT(date, DOB, 105) from [dbo].[Customer]

--Q4

SELECT 
DATEDIFF(YEAR, min(CONVERT(Date, tran_date, 105)), max(CONVERT(Date, tran_date, 105))) as year_diff, 
DATEDIFF(DAY, min(CONVERT(Date, tran_date, 105)), max(CONVERT(Date, tran_date, 105))) as days_diff,
DATEDIFF(MONTH, min(CONVERT(Date, tran_date, 105)), max(CONVERT(Date, tran_date, 105))) as month_diff
from [dbo].[Transactions]


--Q5

SELECT prod_cat, prod_subcat 
FROM prod_cat_info 
WHERE prod_subcat = 'DIY'
GROUP BY prod_cat, prod_subcat



--Q1

SELECT MAX(Store_type) AS MAX_CHL
FROM [dbo].[Transactions]

--Q2

SELECT( SELECT  COUNT(GENDER) FROM  [dbo].[Customer] WHERE  Gender = 'M'  ) AS MALE , COUNT(GENDER) AS FEMEALE 
FROM  [dbo].[Customer]
GROUP BY Gender
HAVING  Gender = 'F'


--Q3


SELECT TOP 1 * FROM (
SELECT city_code, COUNT([customer_Id]) AS COUNT_CUSTOMER 
FROM [dbo].[Customer] 
GROUP BY city_code) TT
ORDER BY city_code DESC


--Q4

SELECT COUNT (prod_subcat) AS COUNT_BOOKS FROM [dbo].[prod_cat_info]
WHERE [prod_cat] = 'Books'

--Q5

SELECT MAX(Qty) FROM [dbo].[Transactions]
WHERE CAST(total_amt AS float) > 0 

--Q6

SELECT COUNT(total_amt) AS REVENUE_EB 
FROM Transactions 
INNER JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
WHERE [prod_cat] = 'Books' OR [prod_cat] = 'Electronics'

--Q7

SELECT COUNT([customer_Id]) AS CNT_CUST, CAST(total_amt AS float)
FROM [dbo].[Customer] 
LEFT JOIN [dbo].[Transactions] ON [dbo].[Transactions].cust_id = [dbo].[Customer].customer_Id
WHERE CAST(total_amt AS float) > 0
GROUP BY CAST(total_amt AS float)
HAVING COUNT([customer_Id]) > 10

--Q8

SELECT SUM(CAST(total_amt AS float)) AS REVENUE_EC
FROM [dbo].[Transactions]
LEFT JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
WHERE ([prod_cat] = 'Clothing' OR [prod_cat] = 'Electronics')
and Store_type = 'Flagship store'   


--Q9

SELECT SUM(CAST(total_amt AS float)) AS REVENUE_M_EC FROM   [dbo].[Customer] 
INNER JOIN [dbo].[Transactions] ON [dbo].[Transactions].cust_id = [dbo].[Customer].customer_Id
LEFT JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
WHERE  Gender = 'M' AND [prod_cat] = 'Electronics'


--Q10

SELECT TOP 5 [prod_subcat], SUM(CASE WHEN (CAST(total_amt AS float)) > 0 THEN (CAST(total_amt AS float)) ELSE 0 END) *100 / 
(SELECT SUM(CAST(total_amt AS float)) FROM   [dbo].[Transactions] WHERE (CAST(total_amt AS float)) > 0) AS SALES , 
SUM(CASE WHEN (CAST(total_amt AS float)) < 0 THEN (CAST(total_amt AS float)) ELSE 0 END) *100 / 
(SELECT SUM(CAST(total_amt AS float)) FROM   [dbo].[Transactions] WHERE (CAST(total_amt AS float)) < 0) AS RETURNS
FROM [dbo].[Transactions] 
INNER JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code 
AND [dbo].[prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code 
GROUP BY [prod_subcat]


--Q11

SELECT SUM(CAST(total_amt AS float)) TBL_REVENUE FROM [dbo].[Transactions] 
INNER JOIN [dbo].[Customer] ON [dbo].[Customer].customer_Id = [dbo].[Transactions].cust_id
WHERE DATEDIFF(YEAR, CONVERT(date, DOB, 105), CONVERT(date, tran_date, 105)) BETWEEN 25 AND 35
AND DATEADD(DAY, -30, (SELECT MAX(CONVERT(date, tran_date, 105)) FROM [dbo].[Transactions])) < CONVERT(date, tran_date, 105)

--Q12


SELECT TOP 1 SUM(CAST(total_amt AS float)) TBL_RETURNS, [prod_cat] FROM [dbo].[Transactions] 
INNER JOIN [dbo].[Customer] ON [dbo].[Customer].customer_Id = [dbo].[Transactions].cust_id
INNER JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
WHERE CAST(total_amt AS float) < 0
AND DATEADD(MONTH, -3, (SELECT MAX(CONVERT(date, tran_date, 105)) FROM [dbo].[Transactions])) < CONVERT(date, tran_date, 105)
GROUP BY [prod_cat]
ORDER BY TBL_RETURNS


--Q13


SELECT TOP 1 SUM(CAST(Qty AS INT)) AS QUANTITY, SUM(CAST(total_amt AS FLOAT)) AS TOTAL, Store_type
 FROM [dbo].[Transactions]
 GROUP BY Store_type
 ORDER BY QUANTITY DESC, TOTAL DESC 


--Q14

SELECT AVG(CAST(total_amt AS FLOAT)) as AVERAGE , [prod_cat] FROM [dbo].[Transactions] 
LEFT JOIN [dbo].[prod_cat_info] on [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
GROUP BY [prod_cat]
HAVING AVG(CAST(total_amt AS FLOAT)) > (SELECT AVG(CAST(total_amt AS FLOAT)) as average FROM [dbo].[Transactions])

--Q15

SELECT [prod_subcat], AVG(CAST(total_amt AS FLOAT)) as AVERAGE, SUM(CAST(total_amt AS FLOAT)) as TOTAL FROM [dbo].[Transactions]
LEFT JOIN [dbo].[prod_cat_info] ON [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code 
AND [prod_cat_info].prod_sub_cat_code = [dbo].[Transactions].prod_subcat_code
WHERE [prod_cat] IN (SELECT TOP 5 [prod_cat]
FROM [dbo].[Transactions] 
LEFT JOIN [dbo].[prod_cat_info] on [dbo].[prod_cat_info].prod_cat_code = [dbo].[Transactions].prod_cat_code
GROUP BY [prod_cat]
 ORDER BY SUM(CAST(Qty AS INT)) DESC)
 GROUP BY [prod_subcat]