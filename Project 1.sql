-- SQL Retail Sales Analysis - P1
use sql_project_p1;

-- Create Table
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(30),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Data Cleaning
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_time IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    customer_id IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    gender IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    age IS NULL;
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL OR sale_date
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;

-- Data Exploration

SELECT 
    COUNT(*) AS total_sale
FROM
    retail_sales;

-- How many customers we have?
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    retail_sales;

-- Total categories
SELECT DISTINCT
    category
FROM
    retail_sales;

-- Data Analysis & Business Key Problems & Answers
-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantiy >= 4;
    
-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) AS total_sale,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    category, ROUND(AVG(age), 0)
FROM
    retail_sales
WHERE
    category IN ('Beauty' , 'clothing')
GROUP BY category;

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    gender,
    category,
    COUNT(transactions_id) AS total_transactions
FROM
    retail_sales
GROUP BY gender , category
ORDER BY category DESC;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year, month,average_sale
 from(
	SELECT 
	RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale), 0) DESC) AS ranking,
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 0) AS average_sale
    FROM 
    retail_sales
GROUP BY 
    YEAR(sale_date), MONTH(sale_date) ) as t1
    where ranking =1;
    
-- 8.Write a SQL query to find the top 5 customers based on the highest total sales .
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    COUNT(DISTINCT customer_id) AS unique_customers, category
FROM
    retail_sales
GROUP BY category;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17). 

with hourly_sales
as(
SELECT *,
case
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales)
select shift,count(*) as total_order from hourly_sales group by shift;
