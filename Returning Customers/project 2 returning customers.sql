-- Objective: To observe trends of returning customers between the years 2011-2015

-- Final output: Display the percentage of returning customers each year

-- A returning customer is a customer who made more than one purchase in a given year.

-- (Percentage of returning customers each year = ( (Number of returning customers in a specific year / Total customers in that year) * 100 )


WITH total_cus_filter AS -- (Initial filter for customers who made more than one purchase in a given year)
(
    SELECT 
        YEAR(OrderDate) AS year,
        CustomerID
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), CustomerID
    HAVING COUNT(SalesOrderID) > 1
),

return_customer_cnt AS -- Counting returning customers each year
(
    SELECT
        year,
        COUNT(CustomerID) AS returning_customers
    FROM total_cus_filter
    GROUP BY year
),

final AS ( -- Joining subquery to show the total number of customers for each year
           -- This join is necessary to calculate the final percentage of returning customers
    SELECT 
        return_customer_cnt.year,
        return_customer_cnt.returning_customers,
        total_cus
    FROM return_customer_cnt
    LEFT JOIN
    (
        SELECT 
            YEAR(OrderDate) AS year,
            COUNT(DISTINCT CustomerID) AS total_cus
        FROM Sales.SalesOrderHeader
        GROUP BY YEAR(OrderDate)
    ) AS total_customers
    ON return_customer_cnt.year = total_customers.year
)

SELECT -- Final calculation for the percentage of returning customers each year
       -- I multiplied returning_customers by 1.0 to ensure we divide two numbers and don't get 0 as a result, losing information
    year,
    (returning_customers * 1.0 / total_cus) * 100 AS returning_cus_percentage
FROM final
ORDER BY year;