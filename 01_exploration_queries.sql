-- Active: 1777613063454@@127.0.0.1@3306@supermarket_db
USE supermarket_db;
CREATE TABLE sales (
    invoice_id VARCHAR(30) PRIMARY KEY,
    branch VARCHAR(50),
    city VARCHAR(50),
    customer_type VARCHAR(50),
    gender VARCHAR(20),
    product_line VARCHAR(100),
    unit_price DECIMAL(10,2),
    quantity INT,
    tax_5_pct DECIMAL(10,4),
    total_sales DECIMAL(10,4),
    sale_date DATE,
    sale_time TIME,
    payment_method VARCHAR(50),
    cogs DECIMAL(10,4),
    gross_margin_pct DECIMAL(10,9),
    gross_income DECIMAL(10,4),
    rating DECIMAL(3,1)
);
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SuperMarket Analysis.csv' 
INTO TABLE sales 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;
SELECT * FROM sales;

-- Level 1: Basic Exploration & Filtering (The Warm-up)

-- Which cities are represented in this dataset?
SELECT DISTINCT city FROM sales; -- 3

-- Show all the details for the invoice ID 631-41-3108.
SELECT * FROM sales WHERE invoice_id = '631-41-3108';

-- How many transactions involved a "Member" customer type?
SELECT COUNT(*) FROM sales WHERE customer_type = 'Member'; -- 565
SELECT COUNT(*) FROM sales WHERE customer_type = 'Normal'; -- 435

-- Show all transactions where the total sales amount was greater than $500.
SELECT * FROM sales WHERE total_sales > 500;

-- What are the different product lines sold in the supermarket?
SELECT DISTINCT product_line FROM sales;

-- Find all sales that happened in the branch 'A'.
SELECT * FROM sales WHERE branch = 'Alex';
SELECT DISTINCT branch FROM sales;

-- Which transactions were paid for using 'Ewallet'?
SELECT * FROM sales WHERE payment_method = 'Ewallet';

-- Level 2: Sorting & Limiting (Finding the Extremes)

-- What were the top 5 most expensive transactions (by total sales)?
SELECT * FROM sales ORDER BY total_sales DESC LIMIT 5;

-- Show the 10 lowest rated transactions.
SELECT * FROM sales ORDER BY rating ASC LIMIT 10;

-- Which transaction had the highest quantity of items purchased in a single go?
SELECT * FROM sales WHERE quantity = (SELECT MAX(quantity) AS highest_quantity FROM sales); -- highest quantity = 10
-- or
SELECT * FROM sales ORDER BY quantity DESC LIMIT 1; -- but only give one row

-- Order all "Health and beauty" sales from the newest date to the oldest date.
SELECT product_line, sale_date FROM sales WHERE product_line = 'Health and beauty' ORDER BY sale_date DESC;

-- Level 3: Aggregation & Grouping (The Core Analyst Skills)

-- What is the total gross income generated across all branches?
SELECT branch, SUM(gross_income) AS total_gross_income FROM sales GROUP BY branch;

-- How many items (quantity) were sold in total?
SELECT SUM(quantity) AS total_items_sold FROM sales; -- 5510

SELECT quantity, SUM(quantity) FROM sales GROUP BY quantity;

-- What is the average customer rating for the entire supermarket?
SELECT AVG(rating) AS average_customer_rating FROM sales; -- 6.97270

-- How much revenue (total sales) did each branch generate?
SELECT branch, SUM(total_sales) AS revenue FROM sales GROUP BY branch;

-- What is the average rating given by male customers versus female customers?
SELECT gender, AVG(rating) AS average_rating FROM sales GROUP BY gender; -- Male: 6.98998 | Female: 6.95972

-- Which product line sold the highest total quantity of items?
SELECT product_line, SUM(quantity) AS total_quantity FROM sales GROUP BY product_line ORDER BY total_quantity DESC LIMIT 1;

-- Find the total sales for each payment method.
SELECT payment_method, SUM(total_sales) FROM sales GROUP BY payment_method;
-- Which method brings in the most money?
SELECT payment_method, SUM(total_sales) FROM sales GROUP BY payment_method ORDER BY SUM(total_sales) DESC LIMIT 1;

-- Level 4: Intermediate Logic (Combining Concepts)

-- Which branch has the highest average customer rating?
SELECT branch, AVG(rating) AS average_rating FROM sales GROUP BY branch ORDER BY average_rating DESC LIMIT 1;

-- What is the total gross income generated specifically by "Normal" (non-member) customers?
SELECT customer_type, SUM(gross_income) AS total_gross_income FROM sales GROUP BY customer_type HAVING customer_type = 'Normal';

-- or

-- Optimized Version:
SELECT customer_type, SUM(gross_income) AS total_gross_income 
FROM sales 
WHERE customer_type = 'Normal'
GROUP BY customer_type;

-- Find the total number of transactions that occurred in the city of 'Yangon' for the "Electronic accessories" product line.
SELECT COUNT(*) FROM sales WHERE city = 'Yangon' AND product_line = 'Electronic accessories';

-- Which product line generates the highest total gross income?
SELECT product_line, SUM(gross_income) AS total_gross_income FROM sales GROUP BY product_line ORDER BY total_gross_income DESC LIMIT 1;

-- Level 5: Advanced Grouping & Having (The Pro Tier)

-- Show the total sales for each branch, but only include branches that generated more than $100,000 in total sales.
SELECT branch, SUM(total_sales) FROM sales GROUP BY branch HAVING SUM(total_sales) > 100000; -- ALL

-- or

-- Cleaner Version:
SELECT branch, SUM(total_sales) AS branch_revenue
FROM sales 
GROUP BY branch 
HAVING branch_revenue > 100000;

-- Which product lines have an average rating lower than 7.0?
SELECT product_line, AVG(rating) FROM sales GROUP BY product_line HAVING AVG(rating) < 7.0;

-- Find the busiest hour of the day across all branches (i.e., which hour has the most transactions?). (Hint: You will need a specific time/date function for this).
SELECT 
    HOUR(sale_time) AS hour_of_day, 
    COUNT(invoice_id) AS total_transactions 
FROM sales 
GROUP BY HOUR(sale_time) 
ORDER BY total_transactions DESC
LIMIT 1;

-- Which combination of City and Customer type generates the highest average total sales per transaction?
SELECT city, customer_type, AVG(total_sales) FROM sales GROUP BY city, customer_type ORDER BY AVG(total_sales) DESC LIMIT 1; -- Naypyitaw & Member : 345.23101546

-- Level 6: Professional Logic (The Strategic Analyst)

-- 1. Customer Segmentation
-- Create a query that categorizes every transaction into three groups: 'Small Spend' (under $200), 'Medium Spend' ($200–$600), and 'High Spend' (over $600).
SELECT *,
CASE
WHEN total_sales < 200 THEN 'Small Spend'
WHEN 200 < total_sales AND total_sales < 600 THEN 'Medium Spend'
WHEN 600 < total_sales THEN 'High Spend'
ElSE 'Invalid Value'
END AS transaction_category
FROM sales;

-- Show the count of transactions in each group.
SELECT
CASE
WHEN total_sales < 200 THEN 'Small Spend'
WHEN 200 < total_sales AND total_sales < 600 THEN 'Medium Spend'
WHEN 600 < total_sales THEN 'High Spend'
ElSE 'Invalid Value'
END AS transaction_category,
COUNT(invoice_id)
FROM sales GROUP BY transaction_category;

-- 2. Performance Comparison
-- Calculate the average rating for each branch, but display it alongside the "Overall Average" for the entire supermarket in the same row. This allows you to see exactly how much higher or lower a branch is compared to the company average.
WITH cte_avg_overall_rating AS (
    SELECT AVG(rating) AS avg_overall_rating
    FROM sales
)
SELECT branch, AVG(rating) AS avg_branch_rating,
(SELECT cte_avg_overall_rating.avg_overall_rating
FROM  cte_avg_overall_rating)
FROM sales
GROUP BY branch

-- or
SELECT 
    branch, 
    AVG(rating) AS avg_branch_rating,
    (SELECT AVG(rating) FROM sales) AS overall_avg -- Simple & Direct
FROM sales
GROUP BY branch;

-- 3. Peak Sales Window
-- Instead of just finding the busiest hour, categorize the sale_time into 'Morning' (before 12:00), 'Afternoon' (12:00–17:00), and 'Evening' (after 17:00). Which time of day generates the most total revenue?
SELECT
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN 12 <= HOUR(sale_time) AND HOUR(sale_time) <= 17 THEN 'Afternoon'
WHEN HOUR(sale_time) > 17 THEN 'Evening'
ELSE 'Invalid Value'
END AS categorize_sale_time,
SUM(total_sales) AS time_total_sales
FROM sales GROUP BY categorize_sale_time ORDER BY time_total_sales DESC LIMIT 1;

-- 4. The "Member Loyalty" Gap
-- For each product line, calculate the average unit price paid by "Members" versus "Normal" customers. Use a CASE statement to create two columns (one for Member Avg, one for Normal Avg) so they appear side-by-side for easy comparison.
SELECT product_line, customer_type, AVG(unit_price) FROM sales GROUP BY product_line, customer_type;

-- I tries CASE also
SELECT 
    product_line,
    AVG(CASE WHEN customer_type = 'Member' THEN unit_price END) AS member_avg_price,
    AVG(CASE WHEN customer_type = 'Normal' THEN unit_price END) AS normal_avg_price
FROM sales
GROUP BY product_line;

-- 5. Profitability Ranking
-- Rank the product lines based on their gross_income, but do it within each branch. For example, show the #1 product line for Alex, the #1 for Giza, and the #1 for Cairo in a single result set. (This is a classic "Top N per Group" problem).
SELECT branch, product_line, SUM(gross_income), RANK() OVER (PARTITION BY branch ORDER BY SUM(gross_income) DESC) AS branch_rank FROM sales GROUP BY branch, product_line;

-- To get the "Top N per group" (the #1 for each branch), you just need to wrap your query in a CTE or Subquery to filter the rank.
WITH RankedProductLines AS (
    SELECT 
        branch, 
        product_line, 
        SUM(gross_income) AS total_income, 
        RANK() OVER (PARTITION BY branch ORDER BY SUM(gross_income) DESC) AS branch_rank 
    FROM sales 
    GROUP BY branch, product_line
)
SELECT * FROM RankedProductLines WHERE branch_rank = 1

SELECT * FROM sales;
