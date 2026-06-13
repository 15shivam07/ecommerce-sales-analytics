-- =====================================
-- ECOMMERCE SALES ANALYTICS PROJECT
-- =====================================
-- Dataset: Superstore
-- Rows: 9800
-- Analyst: Shivam
-- =====================================


-- =====================================
-- CUSTOMER CONCENTRATION ANALYSIS
-- =====================================

SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales),2) AS Nett_Rev
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Nett_Rev DESC;


-- Top 10% Customer Revenue

SELECT SUM(Nett_Rev)
FROM(
    SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales),2) AS Nett_Rev
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Nett_Rev DESC
LIMIT 80)
 AS Top80Cust_Rev;


 -- Result:
-- Top 10% Customers (80 customers)
-- Revenue = 704697.10
-- Approx Revenue Contribution = 31.16%
-- Interpretation: Moderate customer concentration risk.-- Business Analysis Queries
