
--create view offline_online_orders_2011_to_2014 as

--SELECT 
    --YEAR(orderdate) AS year,
    --COUNT(CASE WHEN OnlineOrderFlag = 0 THEN 'online' END) AS offlineorders,
    --COUNT(CASE WHEN OnlineOrderFlag = 1 THEN 'ofline' END) AS onlineorders
--FROM AdventureWorks2019.Sales.SalesOrderHeader
--GROUP BY YEAR(orderdate);

-- Creating a view that counts the number of orders by type (online/offline) for each year  
-- When OnlineOrderFlag = 0, the order is considered offline; when OnlineOrderFlag = 1, the order is considered online  
-- ORDER BY is not allowed in views, so it will be used in the next step  

WITH firsttable AS (
    SELECT 
        year,
        offlineorders,
        onlineorders,
        LAG(offlineorders, 1, 0) OVER (ORDER BY year) AS previous_offline_count,
        LAG(onlineorders, 1, 0) OVER (ORDER BY year) AS previous_online_count
    FROM offline_online_orders_2011_to_2014
)

-- Adding the previous year's order count for each record using LAG to calculate the growth rate  


SELECT 
    year,
    offlineorders,
    onlineorders,
    CASE
        WHEN previous_offline_count = 0 THEN NULL 
        ELSE offlineorders * 100 / previous_offline_count END AS offline_grow_rate,

    CASE 
        WHEN previous_online_count = 0 THEN NULL 
        ELSE onlineorders * 100 / previous_online_count END AS online_grow_rate

FROM firsttable;

-- Calculating the growth rate for both order types while preventing division by zero by converting values to NULL when necessary  
-- Using a CTE improves code readability and creates a temporary structure for better data organization  























