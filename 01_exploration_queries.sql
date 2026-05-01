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