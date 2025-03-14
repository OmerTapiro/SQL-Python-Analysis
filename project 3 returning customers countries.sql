-- Check which year has the highest sales and use it to decide which year to focus on
SELECT 
    YEAR(OrderDate) AS Year,
    COUNT(SalesOrderID) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate);

-------------------------

SELECT * 
FROM Sales.SalesOrderHeader;

GO

-------------------------

-- Calculating the total purchase amount and the number of customers per country for the year 2013
WITH first AS (
    SELECT 

     S_Order_Header.TerritoryID,
     Name, -- Brought it from another table (SalesTerritory)
     SUM(TotalDue) AS total_purchase_amount, -- Calculates the sum of purchases for each country
     COUNT(DISTINCT CustomerID) AS customer_count, -- Counts how many customers for each country (distict customers)
     COUNT(SalesOrderID) AS total_orders -- Counts the total orders for each country

    FROM Sales.SalesOrderHeader AS S_Order_Header

    LEFT JOIN Sales.SalesTerritory AS S_Territory
    ON S_Order_Header.TerritoryID = S_Territory.TerritoryID

    WHERE YEAR(OrderDate) = 2013 -- Filters the data for the year 2013

    GROUP BY Name, S_Order_Header.TerritoryID
)

SELECT 
    Name,
    total_purchase_amount / customer_count AS avg_spending_per_customer, -- Calculates average spending per customer
    total_orders * 1.0 / 
    (SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = 2013) * 100 AS orders_percentage_of_total_sales -- Calculates the percentage of orders from total sales
FROM first
ORDER BY TerritoryID;
