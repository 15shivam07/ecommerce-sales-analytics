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

-- Top 20% Customer Revenue

SELECT ROUND(SUM(Nett_Rev),2)
FROM(SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales),2) AS Nett_Rev
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Nett_Rev DESC
LIMIT 159) AS Top159Cust_Rev;

-- Result:
-- Top 20% Customers (159 Customers)
-- Revenue Contribution = 48.00%

-- Insight:
-- Business shows moderate customer concentration risk.


-- Top 50% Customer Revenue

SELECT ROUND(SUM(Nett_Rev),2)
FROM(SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales),2) AS Nett_Rev
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Nett_Rev DESC
LIMIT 397) AS Half_Cust_Rev;

-- Result:
-- Top 50% Customers (397 customers)
-- Revenue Contribution = 80.43%

-- Insight:
-- Revenue follows a Pareto-like distribution where a relatively small portion of customers generates the majority of sales.

-- =====================================================
-- 2. REGIONAL PERFORMANCE ANALYSIS
-- =====================================================

-- Revenue by Region

SELECT Region, ROUND(SUM(sales),2) AS RegionWiseRev
FROM superstore
GROUP BY Region;

-- Result:
-- West    = 710,219.68
-- East    = 669,518.73
-- Central = 492,646.91
-- South   = 389,151.46

-- Insight:
-- West is the highest revenue-generating region,
-- contributing approximately 31.4% of total company revenue.


-- Orders by Region

SELECT Region, COUNT(DISTINCT`Order ID`) as OrderPerRegion
FROM superstore
GROUP BY Region;

-- Result:
-- West    = 1,587 Orders
-- East    = 1,369 Orders
-- Central = 1,156 Orders
-- South   = 810 Orders

-- Insight:
-- West not only generates the highest revenue but
-- also processes the highest number of orders,
-- indicating the largest market footprint.


-- Average Revenue Per Order

SELECT Region, ROUND(SUM(Sales)/COUNT(DISTINCT `Order ID`),2) as AvgRevByRegion
FROM superstore
GROUP BY Region;

-- Result:
-- East    = 489.06
-- South   = 480.43
-- West    = 447.52
-- Central = 426.17

-- Insight:
-- East records the highest average revenue per order,
-- suggesting a higher-spending customer base compared
-- to other regions.

-- =====================================================
-- 3. CATEGORY ANALYSIS
-- =====================================================

-- Revenue by Category and Region

SELECT Region, Category,
	ROUND(SUM(Sales),2) as CatWiseRev
FROM superstore
GROUP BY Region, Category;

-- Result:
--
-- Central
-- Technology      = 168739.21
-- Office Supplies = 163590.24
-- Furniture       = 160317.46
--
-- East
-- Technology      = 263116.53
-- Furniture       = 206461.39
-- Office Supplies = 199940.81
--
-- South
-- Technology      = 148195.21
-- Office Supplies = 124424.77
-- Furniture       = 116531.48
--
-- West
-- Technology      = 247404.93
-- Furniture       = 245348.25
-- Office Supplies = 217466.51

-- Insight:
-- Technology is the highest revenue-generating category
-- across all regions.
--
-- East records the highest Technology revenue,
-- followed by West.

-- Category Revenue Share %

SELECT
    C.Region,
    C.Category,
    C.CatWiseRev,
    R.RegionWiseRev,
    ROUND((C.CatWiseRev / R.RegionWiseRev) * 100, 2) AS CategorySharePct
FROM
(
    SELECT
        Region,
        Category,
        ROUND(SUM(Sales), 2) AS CatWiseRev
    FROM superstore
    GROUP BY Region, Category
) AS C
JOIN
(
    SELECT
        Region,
        ROUND(SUM(Sales), 2) AS RegionWiseRev
    FROM superstore
    GROUP BY Region
) AS R
ON C.Region = R.Region
ORDER BY C.Region, CategorySharePct DESC;

-- Result:
--
-- Central
-- Technology      = 34.25%
-- Office Supplies = 33.21%
-- Furniture       = 32.54%
--
-- East
-- Technology      = 39.30%
-- Furniture       = 30.84%
-- Office Supplies = 29.86%
--
-- South
-- Technology      = 38.08%
-- Office Supplies = 31.97%
-- Furniture       = 29.95%
--
-- West
-- Technology      = 34.83%
-- Furniture       = 34.55%
-- Office Supplies = 30.62%

-- Insight:
-- East and South derive a significantly larger share
-- of revenue from Technology products compared to
-- West and Central.

-- =====================================================
-- 4. SUB-CATEGORY ANALYSIS
-- =====================================================

-- Technology Sub-Category Analysis

SELECT Region,`Sub-Category`,ROUND(SUM(Sales),2) As SCRev
FROM superstore
WHERE Category = 'Technology'
GROUP BY Region,`Sub-Category`
ORDER BY Region,`Sub-Category` Desc;

-- Result:
--
-- Central
-- Phones      = 71939.95
-- Machines    = 26797.38
-- Copiers     = 37259.57
-- Accessories = 32742.30
--
-- East
-- Phones      = 99884.66
-- Machines    = 66106.17
-- Copiers     = 53219.46
-- Accessories = 43906.24
--
-- South
-- Phones      = 58098.34
-- Machines    = 53890.96
-- Copiers     = 9299.76
-- Accessories = 26906.15
--
-- West
-- Phones      = 97859.50
-- Machines    = 42444.12
-- Copiers     = 46469.31
-- Accessories = 60632.01

-- Findings:
--
-- 1. East has the highest Avg Revenue Per Order (489.06)
-- 2. East has the highest Technology Share (39.30%)
-- 3. South has the second-highest Technology Share (38.08%)
-- 4. South has the second-highest Avg Revenue Per Order (480.43)
-- 5. Machine sales are strongest in East and South

-- Insight:
--
-- Regions with stronger Technology sales,
-- particularly Machine sales,
-- tend to record higher Average Revenue Per Order.
--
-- Premium Technology products appear to be a major
-- contributor to larger order values.

-- =====================================================
-- 5. YEARLY TREND ANALYSIS
-- =====================================================

-- Revenue by Year

SELECT YEAR(STR_TO_DATE(`Order Date`, '%d/%m/%Y')) AS YEAR, ROUND(SUM(Sales),2) as YrlyREV
FROM superstore
GROUP BY YEAR
ORDER BY YEAR;

-- Result:
--
-- 2015 = 479856.21
-- 2016 = 459436.01
-- 2017 = 600192.55
-- 2018 = 722052.02

-- Insight:
--
-- Revenue declined slightly in 2016 before entering
-- a strong growth phase in 2017 and 2018.
--
-- Revenue increased by more than 57% between
-- 2016 and 2018.

-- =====================================================
-- 6. MONTHLY TREND ANALYSIS
-- =====================================================

-- Revenue by Month and Year

SELECT 
YEAR(STR_TO_DATE(`Order Date`, '%d/%m/%Y')) AS YEAR,
MONTH(STR_TO_DATE(`Order Date`, '%d/%m/%Y')) AS MON_NUM,
MONTHNAME(STR_TO_DATE(`Order Date`, '%d/%m/%Y')) AS MONTH,
ROUND(SUM(Sales),2) as YrlyREV
FROM superstore
GROUP BY YEAR,MON_NUM, MONTH
ORDER BY YEAR,MON_NUM;

-- Result:
--
-- Strongest Month:
-- November 2018 = 117938.16
--
-- Weakest Month:
-- February 2015 = 4519.89
--
-- Consistently Strong Months:
-- September
-- November
-- December
--
-- Consistently Weak Months:
-- January
-- February

-- Findings:
--
-- 1. The second half of the year consistently
--    outperforms the first half.
--
-- 2. Q4 (Oct-Nov-Dec) is the strongest sales period.
--
-- 3. November is consistently one of the best
--    performing months.
--
-- 4. February is consistently among the weakest months.
--
-- 5. Quarter-ending months such as March,
--    September and December often outperform
--    surrounding months.

-- Insight:
--
-- The business exhibits strong seasonal patterns.
--
-- Revenue tends to accelerate during the second
-- half of the year and peaks during Q4.

-- =====================================================
-- 7. GEOGRAPHIC ANALYSIS
-- =====================================================

-- Revenue by State

SELECT Region, State,
ROUND(SUM(Sales),2) AS StateRev
FROM superstore
GROUP BY Region, State
ORDER BY Region, State DESC;

-- Result:
--
-- West     | California   = 446306.46
-- East     | New York     = 306361.15
-- Central  | Texas        = 168572.53
-- West     | Washington   = 135206.85
-- East     | Pennsylvania = 116276.65
-- South    | Florida      = 88436.53
-- Central  | Illinois     = 79236.52
-- Central  | Michigan     = 76136.07
-- East     | Ohio         = 75130.35
-- South    | Virginia     = 70636.72

-- Insight:
--
-- California is the highest revenue-generating state.
--
-- West Region benefits significantly from
-- California and Washington.


-- Top 5 States Contribution

SELECT Region, State,
ROUND(SUM(Sales),2) AS StateRev
FROM superstore
GROUP BY Region, State
ORDER BY StateRev DESC
LIMIT 5

-- Result:
--
-- Top 5 States Revenue Contribution = 51.85%

-- Insight:
--
-- More than half of total company revenue is generated
-- by only five states.
--
-- This indicates strong geographic concentration.
-- =====================================================
