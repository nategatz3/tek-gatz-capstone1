-- BEFORE RUNNING THIS SCRIPT PLEASE ENSURE THAT YOU USE THE TABLE IMPORT WIZARD TO GRAB THE CSV FILES --
-- THESE FILES WILL ACT AS THE BASE TO THE REST OF THE SCRIPT --
-- AFTER IMPORTING MAKE SURE TO DELETE "i>>?" FROM THE FIRST COLUMN NAME --


-- CSV LIST WILL BE IN THE ZIPPED FILE --
-- hist_prod_sales.csv , hist_serv_sales.csv , prod_details.csv , sales_team.csv , week_breakdown.csv --


-- All of this info is for application and setting adjusment

Select @@autocommit; -- 1 by default, all commands COMMIT immediately (no ROLLBACK)
Set @@autocommit = 0; -- ROLLBACK may be used to reverse DML changes not yet COMMIT.
Select @@SQL_SAFE_UPDATES; -- 1 by default
Set @@SQL_SAFE_UPDATES = 0; -- Lifts Warning on DELETE

use tractortek;

commit;

rollback;

-- Open a Table

-- select * from oltp_weekly_sales;

-- select * from prod_details;

-- select * from sales_team;

-- select * from week_breakdown;

-- select * from historical_prod_sales;

-- select * from historical_prod_sales_region;

-- select * from historical_prod_sales_category;

-- select * from historical_serv_sales;

-- select * from historical_serv_sales_region;

-- select * from historical_serv_sales_category;

-- select * from historical_serv_sales_income;

-- select * from quart_prod_inc_2019;

-- select * from quart_prod_inc_2019;

-- Dropping Tables 

DROP TABLE IF EXISTS hist_prod_sales_region;

DROP TABLE IF EXISTS hist_serv_sales_region;

DROP TABLE IF EXISTS hist_prod_sales_category;

DROP TABLE IF EXISTS hist_serv_sales_category;

DROP TABLE IF EXISTS hist_serv_sales_income;

DROP TABLE IF EXISTS quart_prod_inc_2019;

DROP TABLE IF EXISTS quart_prod_inc_2020;

-- Create regional product sales table and insert data

CREATE TABLE IF NOT EXISTS hist_prod_sales_region (
	prod_code VARCHAR(20),
    emp_id VARCHAR(20),
    region VARCHAR(5),
    the_year SMALLINT,
    total_quantity SMALLINT
);

INSERT INTO hist_prod_sales_region (prod_code, emp_id, region, the_year, total_quantity)
SELECT hist_prod_sales.prod_code, emp_id, region, the_year, total_quantity
FROM sales_team
INNER JOIN hist_prod_sales ON sales_team.employee_id = hist_prod_sales.emp_id;

-- Create regional service plan sales table and insert data

CREATE TABLE IF NOT EXISTS hist_serv_sales_region (
	serv_plan VARCHAR(20),
    emp_id VARCHAR(20),
    region VARCHAR(5),
    the_year SMALLINT,
    total_quantity SMALLINT
);

INSERT INTO hist_serv_sales_region (serv_plan, emp_id, region, the_year, total_quantity)
SELECT hist_serv_sales.serv_plan, emp_id, region, the_year, total_quantity
FROM sales_team
INNER JOIN hist_serv_sales ON sales_team.employee_id = hist_serv_sales.emp_id;

-- Create categorical product sales table and insert data

CREATE TABLE IF NOT EXISTS hist_prod_sales_category (
	prod_code VARCHAR(20),
    manufacturer VARCHAR(20),
    emp_id VARCHAR(20),
    the_year SMALLINT,
    total_quantity SMALLINT
);

INSERT INTO hist_prod_sales_category (prod_code, manufacturer, emp_id, the_year, total_quantity)
SELECT hist_prod_sales.prod_code, manufacturer AS category, emp_id, the_year, total_quantity
FROM prod_details
INNER JOIN hist_prod_sales ON prod_details.product_code = hist_prod_sales.prod_code;

-- Create categorical service plan sales table and insert data

CREATE TABLE IF NOT EXISTS hist_serv_sales_category (
	serv_plan VARCHAR(20),
    manufacturer VARCHAR(20),
    emp_id VARCHAR(20),
    the_year SMALLINT,
    total_quantity SMALLINT
);

INSERT INTO hist_serv_sales_category (serv_plan, manufacturer, emp_id, the_year, total_quantity)
SELECT hist_serv_sales.serv_plan, manufacturer AS category, emp_id, the_year, total_quantity
FROM prod_details
INNER JOIN hist_serv_sales ON prod_details.service_plan = hist_serv_sales.serv_plan;

-- Create service plan income table and insert data

CREATE TABLE IF NOT EXISTS hist_serv_sales_income (
	emp_id VARCHAR(20),
    region VARCHAR(5),
    serv_plan VARCHAR(20),
    quan_sold SMALLINT,
    serv_price VARCHAR(20),
    total_income VARCHAR(20),
    the_year SMALLINT
);

INSERT INTO hist_serv_sales_income (emp_id, region, serv_plan, quan_sold, serv_price, total_income, the_year)
SELECT emp_id, region, serv_plan,
total_quantity AS quan_sold,
CONCAT("$", serv_price) AS serv_price,
CONCAT("$", serv_price*total_quantity) AS total_income,
the_year
FROM prod_details
INNER JOIN hist_serv_sales ON prod_details.service_plan = hist_serv_sales.serv_plan
INNER JOIN sales_team ON hist_serv_sales.emp_id = sales_team.employee_id
ORDER BY serv_plan ASC;

-- Create product income by quarter by year tables

-- 2019 Product Income Table

CREATE TABLE IF NOT EXISTS quart_prod_inc_2019 (
	emp_id VARCHAR(20),
    region VARCHAR(5),
    prod_code VARCHAR(20),
    price VARCHAR(7),
    Q1_tot SMALLINT,
    Q2_tot SMALLINT,
    Q3_tot SMALLINT,
    Q4_tot SMALLINT,
    2019_Q1_inc VARCHAR(20),
    2019_Q2_inc VARCHAR(20),
    2019_Q3_inc VARCHAR(20),
    2019_Q4_inc VARCHAR(20)
);

INSERT INTO quart_prod_inc_2019
SELECT emp_id, region, prod_code, CONCAT("$", price_2019Q1) AS price, Q1_tot, Q2_tot, Q3_tot, Q4_tot,	-- Prices only differ by year. All of the proudcts maintain 1 price for 2019
CONCAT("$", price_2019Q1*Q1_tot) as "2019_Q1_inc",
CONCAT("$", price_2019Q2*Q2_tot) as "2019_Q2_inc",
CONCAT("$", price_2019Q3*Q3_tot) as "2019_Q3_inc",
CONCAT("$", price_2019Q4*Q4_tot) as "2019_Q4_inc"
FROM prod_details
INNER JOIN hist_prod_sales ON prod_details.product_code = hist_prod_sales.prod_code		-- Quarterly product income 2019
INNER JOIN sales_team ON hist_prod_sales.emp_id = sales_team.employee_id
WHERE the_year = 2019
ORDER BY emp_id ASC;

-- select * from quart_prod_inc_2019;

-- 2020 Product Income Table

CREATE TABLE IF NOT EXISTS quart_prod_inc_2020 (
	emp_id VARCHAR(20),
    region VARCHAR(5),
    prod_code VARCHAR(20),
    price VARCHAR(7),
    Q1_tot SMALLINT,
    Q2_tot SMALLINT,
    Q3_tot SMALLINT,
    Q4_tot SMALLINT,
    2020_Q1_inc VARCHAR(20),
    2020_Q2_inc VARCHAR(20),
    2020_Q3_inc VARCHAR(20),
    2020_Q4_inc VARCHAR(20)
);

INSERT INTO quart_prod_inc_2020
SELECT emp_id, region, prod_code, CONCAT("$", price_2020Q1) AS price, Q1_tot, Q2_tot, Q3_tot, Q4_tot,	-- Prices only differ by year. All of the proudcts maintain 1 price for 2020
CONCAT("$", price_2020Q1*Q1_tot) as "2020_Q1_inc",
CONCAT("$", price_2020Q2*Q2_tot) as "2020_Q2_inc",
CONCAT("$", price_2020Q3*Q3_tot) as "2020_Q3_inc",
CONCAT("$", price_2020Q4*Q4_tot) as "2020_Q4_inc"
FROM prod_details
INNER JOIN hist_prod_sales ON prod_details.product_code = hist_prod_sales.prod_code		-- Quarterly product income 2020
INNER JOIN sales_team ON hist_prod_sales.emp_id = sales_team.employee_id
WHERE the_year = 2020
ORDER BY emp_id ASC;

-- select * from quart_prod_inc_2020;
