--Supermart Analysis--

-- View Table Data --

SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM regions;


--Total Revenue calculation--
CREATE VIEW total_revenue AS
SELECT quantity*unit_price*(1-discount/100.0) AS total_rev
FROM order_items;

-- Section A — Fundamentals --
-- Question 1

-- a. Retrieve the first_name, last_name, and email of every customer who lives in Lagos. Sort results alphabetically by last_name, then by first_name.
SELECT first_name, last_name, email
FROM customers
WHERE city = 'Lagos'
ORDER BY last_name ASC, first_name;

-- b. List  the  names  of  all  distinct  cities  to  which  SuperMart  has  shipped  at  least  one  order.  Sort alphabetically.
SELECT DISTINCT(shipping_city)
FROM orders
GROUP BY shipping_city
ORDER BY shipping_city;

-- c. Display the top 10 most expensive products by unit_price. Show product_name, category_id, and unit_price, ordered from most to least expensive.
SELECT TOP 10 product_name, category_id, unit_price
FROM products o 
ORDER BY unit_price ASC;

-- d. List  all  employees hired on  or  after 1st  January  2021.  Display  their full  name (first_name and last_name concatenated as one column called full_name), 
-- role, hire_date, and salary, ordered by hire_date ascending.
SELECT CONCAT(first_name, ' ',last_name) AS full_name,
	   role,
	   hire_date,
	   salary
FROM employees
WHERE hire_date > '2021-01-01'
ORDER BY hire_date ASC;


-- e. Retrieve all orders placed in December across any year. Show order_id, order_date, status, and shipping_city. Order by order_date descending
SELECT order_id, order_date, shipping_city
FROM orders
WHERE MONTH(order_date) = 12
ORDER BY order_date DESC;


-- Section B — Aggregate Functions

-- a.    How  many  orders  exist  for  each  status?  Display  the  status,  the  count,  and  each  status  as  a percentage of all orders, 
-- rounded to 2 decimal places. Label the percentage column pct_of_total. Order by count descending.
CREATE VIEW order_count AS
SELECT count(*) AS order_ct
FROM orders;

WITH status_count AS (
	SELECT 
	status, 
	count(*) AS ord_count
	FROM orders
	GROUP BY status
)
SELECT 
	status, 
	ord_count, 
	ROUND(((ord_count*1.0/order_ct) * 100),2) AS order_perct
FROM status_count
CROSS JOIN order_count;

-- b.  For each product category, calculate the minimum, maximum, and average unit_price of products in that category. Round the average to 2 decimal places. 
-- Display category_name (not just the ID). Order by average price descending

SELECT 
	category_name, 
	MIN(p.unit_price) as min_price,
	MAX(p.unit_price) as max_price,
	ROUND(AVG(p.unit_price),2) as avg_price 
FROM categories c
JOIN products p
ON p.category_id = c.category_id
GROUP BY category_name
ORDER BY avg_price DESC;


-- c.  Across all rows in order_items, calculate: the total revenue generated, the average revenue per line item, the maximum revenue from a single line item, 
-- and the minimum revenue from a single line item. Round all values to 2 decimal places and label each column clearly.

SELECT *,
	   quantity*unit_price*(1-discount/100.0) AS total_rev,
	   AVG(quantity*unit_price*(1-discount/100.0)) AS avg_rev,
	   MAX(quantity*unit_price*(1-discount/100.0)) AS max_rev,
	   MIN(quantity*unit_price*(1-discount/100.0)) AS min_rev
FROM order_items
GROUP BY order_item_id,order_id,product_id,quantity,unit_price,discount;


-- d.  How many distinct customers have placed at least one order? What is the average number of orders per ordering customer, 
-- rounded to 2 decimal places? Display both figures as separate columns in a single result row


SELECT	
	c.first_name, 
	COUNT(DISTINCT(o.order_id)) AS order_count,
	AVG(oi.quantity) AS avg_qty
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name;


-- Section C — Grouping

-- a. Count the number of customers who registered each year between 2018 and 2024. Display the registration year and the count. Order by year ascending.

SELECT 
	YEAR(registration_date) as Year,
	count(*) as reg_count
FROM customers
WHERE YEAR(registration_date) BETWEEN 2018 AND 2024
GROUP BY YEAR(registration_date)
ORDER BY Year ASC;
	

-- b.  Which shipping cities received more than 10 delivered orders in total? Display the city name and the count of delivered orders, ordered by count descending.
SELECT 
	city,
	count(o.order_id) AS order_ct
FROM customers c 
JOIN orders o
	 ON o.customer_id = c.customer_id
WHERE status = 'Delivered'
GROUP BY city
HAVING count(o.order_id) > 10
ORDER BY order_ct DESC;



-- c.  Find all products whose total quantity sold across all order_items exceeds 50 units. Display product_id, product_name, and total quantity sold. 
-- Order by total quantity descending 

SELECT 
	product_id,
	product_name, 
	SUM(stock_quantity) AS total_qty_sold
FROM products
GROUP BY product_id, product_name
HAVING SUM(stock_quantity) > 50
ORDER BY total_qty_sold DESC;


-- d.  Show each employee's full name and the total number of orders they handled. Return only employees who handled 20 or more orders. 
-- Order by order count descending.

SELECT 
	CONCAT(first_name,' ',last_name) AS full_name,
	COUNT(order_id) AS order_count
FROM employees e
JOIN orders o
ON o.employee_id = e.employee_id
GROUP BY CONCAT(first_name,' ',last_name)
HAVING COUNT(order_id) >= 20
ORDER BY order_count DESC;


-- For each year in the dataset (2021–2024), show the total number of orders placed and the count of distinct customers who ordered that year. 
-- Order by year ascending.

SELECT 
	YEAR(order_date) AS year,
	COUNT(order_id) AS order_count,
	COUNT(DISTINCT(customer_id)) AS cust_count
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year ASC;



-- Section D — LIKE & ILIKE

-- a. SuperMart wants to run a Gmail campaign. Retrieve the first_name, last_name, and email of all customers whose email address ends with @gmail.com. 
-- Order alphabetically by last_name.

SELECT
	first_name,
	last_name,
	email
FROM customers
WHERE email LIKE '%@gmail.com';


-- b.   A product manager needs a list of all products whose names include the word "set" anywhere, regardless  of  case.  Use  ILIKE.  
-- Display  product_name,  category_id,  and  unit_price,  ordered  by unit_price descending.

SELECT
	product_id,
	category_id,
	unit_price
FROM products
WHERE product_name LIKE '%set%'
ORDER BY unit_price DESC;


-- c.  Find all customers whose last name begins with the letters 'Ad' (case-insensitive). Display full name, city, and registration_date.

SELECT 
	CONCAT(first_name,' ',last_name) AS full_name,
	city,
	registration_date
FROM customers
WHERE last_name LIKE 'Ad%';


-- d.  Retrieve all products whose names contain "combo", "kit", or "pack" anywhere in the name (case- insensitive). Use ILIKE with OR. 
-- Display product_name, category_id, and unit_price.

SELECT 
	product_name,
	category_id,
	unit_price
FROM products
WHERE product_name LIKE '%combo%' 
	OR product_name LIKE '%kit%'
	OR product_name LIKE '%pack%';


-- e.  Find all customers whose city name contains the letter sequence 'an' (case-insensitive — e.g. Kano, Kaduna). 
-- Display first_name, last_name, and city. Order by city, then last_name.

SELECT 
	first_name,
	last_name,
	city
FROM customers
WHERE city LIKE '%an%'
ORDER BY city, last_name;


-- Section e — JOINS

-- a.  Display the 50 most recent orders. For each, show: order_id, the customer's full name, the handling employee's full name, order_date, status, 
-- and shipping_city. Use INNER JOINs. Order by order_date descending.

SELECT TOP 50
	CONCAT(c.first_name,' ',c.last_name) AS cust_name,
	CONCAT(e.first_name,' ',e.last_name) AS emp_name,
	o.order_date,
	o.status,
	c.city
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN employees e
ON e.employee_id = o.employee_id
ORDER BY order_date DESC;


-- b.  List all 800 customers alongside the total number of orders they have placed. Customers who have never  ordered  should  show  0.  
-- Display  customer_id,  full  name,  city,  and  order_count.  Order  by order_count descending, then last_name ascending.

SELECT 
	c.customer_id,
	CONCAT(c.first_name,' ',c.last_name) AS cust_name,
	city,
	COUNT(order_id) AS order_count
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, CONCAT(c.first_name,' ',c.last_name), city;


-- c.   Produce a detailed order line report containing every row in  order_items. For each row show: order_id,  order_date,  customer  full  name, 
-- product_name,  quantity,  unit_price,  discount,  and  a calculated   column   line_total   using   the   revenue   formula.   Order   by   order_id   ascending, 
-- then product_name ascending.
SELECT 
	oi.order_id,
	o.order_date,
	CONCAT(c.first_name,' ',c.last_name) AS cust_fullname,
	p.product_name,
	oi.quantity,
	oi.unit_price,
	oi.discount,
	oi.quantity*oi.unit_price*(1-oi.discount/100.0) AS total_rev
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN orders o
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
ORDER BY oi.order_id ASC;


-- d.  Show all 35 employees with their full_name, role, region_name (from the regions table), and the total number of orders they have handled. 
-- Include employees with zero orders (show 0). Order by total orders descending, then last_name ascending.
SELECT 
	CONCAT(e.first_name,' ',e.last_name) AS emp_fullname,
	e.last_name,
	e.role,
	r.region_name,
	COUNT(o.order_id) AS order_count
FROM employees e
JOIN regions r
ON r.region_id = e.region_id
JOIN orders o
ON o.employee_id = e.employee_id
GROUP BY CONCAT(e.first_name,' ',e.last_name), e.last_name, e.role, r.region_name
ORDER BY order_count DESC, e.last_name ASC;


-- e.  For each product category, list every product alongside the total number of distinct orders it has appeared in and the total quantity sold. 
-- Display category_name, product_name, times_ordered, and total_qty_sold. Order by category_name, then total_qty_sold descending.
SELECT 
	c.category_name,
	p.product_name,
	COUNT(oi.order_id) AS times_ordered,
	SUM(quantity) AS total_qty_sold
FROM categories c
JOIN products p
ON p.category_id = c.category_id
JOIN order_items oi
ON oi.product_id = p.product_id
GROUP BY c.category_name, p.product_name
ORDER BY c.category_name, total_qty_sold DESC;



-- Section F — CASE Expressions

-- a.    Assign  a  price  tier  label  to  every  product  using  the  table  below.  Display   product_name, 
-- category_name (joined from categories), unit_price, and price_tier. Order by unit_price ascending.
SELECT 
	p.product_name,
	c.category_name,
	p.unit_price,
    CASE 
        WHEN unit_price < 10000 THEN 'Budget'
		WHEN unit_price BETWEEN 10000 AND 99999 THEN 'Mid Range'
		WHEN unit_price > 10000 THEN 'Premium'
    END AS price_tier
FROM products p
JOIN categories c
ON c.category_id = p.category_id
ORDER BY unit_price;


-- b.  Classify each of the 35 employees into a pay band based on their salary. Display full_name, role, salary, and pay_band. Order by salary descending.

SELECT 
	CONCAT(e.first_name,' ',e.last_name) AS emp_fullname,
	role,
	salary,
    CASE 
        WHEN salary >= 100000 THEN 'Executive'
		WHEN salary BETWEEN 80000 AND 99999 THEN 'Senior'
		WHEN salary < 80000 THEN 'Entry Level'
    END AS pay_band
FROM employees e;


-- c.  For each order, calculate the total order value (sum of all its line totals), then classify it using the table below. 
-- Display order_id, order_date, status, total_order_value (rounded to 2 dp), and value_category. Order by total_order_value descending.

SELECT 
	oi.order_id,
	order_date,
	status,
	SUM(unit_price) AS total_order_value,
	CASE 
		WHEN SUM(unit_price) > 500000 THEN 'High Value'
		WHEN SUM(unit_price) BETWEEN 100000 AND 500000 THEN 'Medium Value'
		WHEN SUM(unit_price) < 100000 THEN 'Low Value'
	END AS value_category
FROM orders o 
JOIN order_items oi
ON oi.order_id = o.order_id
GROUP BY oi.order_id, order_date, status
ORDER BY total_order_value DESC;


-- d.  Using a single query with CASE inside an aggregate, count how many products in each category fall into  each  price  tier.  
-- Display  one  row  per  category  with  columns:  category_name,  budget_count, mid_range_count, premium_count.

SELECT 
    category_name,
    COUNT(CASE WHEN unit_price < 50 THEN 1 END) AS budget_count,
    COUNT(CASE WHEN unit_price >= 50 AND unit_price <= 150 THEN 1 END) AS mid_range_count,
    COUNT(CASE WHEN unit_price > 150 THEN 1 END) AS premium_count
FROM 
    categories c
JOIN products p ON p.category_id = c. category_id
GROUP BY 
    category_name;


-- Section G — Subqueries
-- a.  Find all products whose unit_price is above the average unit price of all products in the catalogue. Display product_name, category_id, and unit_price. 
-- Order by unit_price descending.

SELECT 
	product_name,
	category_id,
	unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price DESC;


-- b.  List all customers who have placed at least one order. Display their full name and city. Solve this using a subquery with IN — do not use a JOIN.
SELECT 
	CONCAT(first_name,' ',last_name) AS cust_fullname,
	city
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- c.    Find  all  products  that  have  never  appeared  in  any  order.  Display  product_id,  product_name, category_id, and unit_price.
SELECT 
	product_id,
	product_name,
	category_id,
	unit_price
FROM products
WHERE product_id IN (SELECT product_id FROM orders);


-- d.  Using subqueries, find the top 5 customers by total lifetime revenue (all statuses, all order items). 
-- Display their full name, city, and total lifetime revenue rounded to 2 decimal places.
SELECT TOP 5
    CONCAT(c.first_name, ' ', c.last_name) AS cust_fullname,
    c.city,
    rev.total_rev
FROM customers c
JOIN (
    -- Subquery calculates total revenue per customer
    SELECT 
        o.customer_id,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)),2) AS total_rev
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) rev ON c.customer_id = rev.customer_id
ORDER BY rev.total_rev DESC;


-- e.  Find all customers whose total lifetime revenue exceeds the average lifetime revenue across all ordering customers. 
-- Display their full name, city, and total revenue (rounded to 2 dp). Order by total revenue descending.
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS cust_fullname,
    c.city,
    rev.total_rev
FROM customers c
JOIN (
    -- Subquery calculates total revenue per customer
    SELECT 
        o.customer_id,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)),2) AS total_rev
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) rev ON c.customer_id = rev.customer_id
WHERE rev.total_rev > (SELECT ROUND(AVG(quantity * unit_price * (1 - discount / 100.0)),2) FROM order_items)
ORDER BY rev.total_rev DESC;


-- Section H — CTEs (Common Table Expressions)
-- a.  Using a single CTE, calculate the total revenue per customer across all their orders (all statuses). 
-- From the outer query, return only the top 10 customers by revenue. Display customer_id, full name, city, and total_revenue rounded to 2 dp
WITH cust_rev AS (
	SELECT 
		c.customer_id, c.first_name, c.last_name,c.city,
		SUM(quantity * unit_price * (1 - discount / 100.0)) AS total_rev
	FROM customers c
	JOIN orders o
	ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id,c.first_name	,c.last_name,c.city
)
SELECT TOP 10
	customer_id,
	CONCAT(first_name, ' ', last_name) AS cust_fullname,
	city,
	ROUND(total_rev,2) AS cust_total_rev
FROM cust_rev
ORDER BY cust_total_rev DESC;


-- b.  Using a CTE, identify the single best-selling product (by total quantity sold) in each category. Display category_name, product_name, and total_qty_sold
WITH best_product AS (
	SELECT 
		category_name,
		p.product_name,
		SUM(oi.quantity) AS total_qty_sold
	FROM categories c
	JOIN products p
	ON p.category_id = c.category_id
	JOIN order_items oi
	ON oi.product_id = p.product_id
	GROUP BY category_name, product_name
)
SELECT TOP 1
	category_name,
	product_name,
	total_qty_sold
FROM best_product
ORDER BY total_qty_sold DESC;


-- c.  Using two chained CTEs, analyse monthly performance for the year 2023 only:
-- CTE 1: Total revenue per calendar month in 2023 (all statuses).
-- CTE 2: The average monthly revenue across all months of 2023.
-- Final  query:  Each  month  number,  total  revenue  (rounded  to  2  dp),  and  a  column  called vs_average — set to 'Above Average' 
-- if that month beat the average, otherwise 'Below Average'. Order by month ascending.

WITH rev_23 AS (
	SELECT 
		MONTH(order_date) AS month_23,
		ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)),2) AS total_rev
	FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY MONTH(order_date)
),
avg_mth_rev23 AS (
	SELECT 
		MONTH(order_date) AS avg_month_23,
		ROUND(AVG(quantity * unit_price * (1 - discount / 100.0)),2) AS avg_rev
	FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY MONTH(order_date)
)
SELECT
	month_23,
	total_rev,
	CASE
		WHEN total_rev > avg_rev THEN 'Above Average'
		WHEN total_rev < avg_rev THEN 'below Average'
	END AS vs_average
FROM rev_23 r 
JOIN avg_mth_rev23 a ON a.avg_month_23 = r.month_23
ORDER BY month_23 ASC;


-- d.  Using CTEs, produce a customer frequency segmentation report. 
-- Calculate how many total orders each customer has placed, then classify each customer using the table below. 
-- Return one row per segment showing the segment label and customer_count. Order by customer_count descending.

WITH cust_freq AS (
	SELECT 
		c.customer_id,
		COUNT(order_id) AS customer_count
	FROM customers c
	JOIN orders o
	ON o.customer_id = c.customer_id
	GROUP BY c.customer_id
)
SELECT 
	CASE 
		WHEN customer_count >= 8 THEN 'High Frequency'
		WHEN customer_count BETWEEN 4 AND 7 THEN 'Regular'
		WHEN customer_count BETWEEN 1 AND 3 THEN 'Occassional'
		ELSE 'Inactive'
	END AS segment,
	COUNT(customer_id) AS number_of_customers
FROM cust_freq
GROUP BY 
	CASE 
		WHEN customer_count >= 8 THEN 'High Frequency'
		WHEN customer_count BETWEEN 4 AND 7 THEN 'Regular'
		WHEN customer_count BETWEEN 1 AND 3 THEN 'Occassional'
		ELSE 'Inactive'
	END
ORDER BY number_of_customers DESC;



-- e.  Using a CTE, compute the year-over-year total revenue from delivered orders for each year in the dataset (2021, 2022, 2023, and the first half of 2024).
-- Display order_year and total_revenue (rounded to 2 dp). Order by year ascending.

WITH yoy_rev AS (
	SELECT 
		YEAR(order_date) AS order_year,
		ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)),2) AS total_revenue
	FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
	WHERE status = 'Delivered' AND
	order_date BETWEEN '2021-01-01' AND '2024-06-01'
    GROUP BY YEAR(order_date)
)
SELECT 
	order_year,
	total_revenue
FROM yoy_rev
ORDER BY order_year ASC;


-- Section I — Capstone Challenge
-- Employee Sales Performance Report
WITH total_rev AS (
	SELECT 
		order_id,
		ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)),2) AS total_revenue
	FROM order_items
	GROUP BY order_id
),
order_info AS (
	SELECT 
		o.employee_id,
		COUNT(o.order_id) AS total_delivered_orders,
		SUM(tr.total_revenue) AS total_revenue,
		ROUND(AVG(tr.total_revenue),2) AS avg_order_value,
		ROUND(MAX(tr.total_revenue),2) AS best_single_order
	FROM orders o 
	JOIN total_rev tr
	ON tr.order_id = o.order_id
	WHERE status = 'Delivered' AND
	order_date BETWEEN '2021-01-01' AND '2024-06-30'
	GROUP BY employee_id
)
SELECT 
	CONCAT(e.first_name,' ',e.last_name) AS employee_name,
	e.role,
	r.region_name,
	COALESCE(oi.total_delivered_orders, 0) AS total_delivered_orders,
    COALESCE(oi.total_revenue, 0.00) AS total_revenue,
    COALESCE(ROUND(oi.avg_order_value, 2), 0.00) AS avg_order_value,
    COALESCE(oi.best_single_order, 0.00) AS best_single_order,
	CASE 
		WHEN total_revenue > 5000000 THEN 'Elite'
		WHEN total_revenue BETWEEN 1000000 AND 5000000 THEN 'Strong'
		WHEN total_revenue BETWEEN 100000 AND 999999 THEN 'Developing'
		ELSE 'Inactive'
	END AS performance_band
FROM employees e
LEFT JOIN order_info oi ON e.employee_id = oi.employee_id
JOIN regions r ON r.region_id = e.region_id
ORDER BY oi.total_revenue DESC, employee_name ASC;
	


-- Section J — Bonus Challenge
-- Question 10 — Customer Lifetime Value Report
WITH item_totals AS (
   SELECT 
        order_id,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS order_revenue
    FROM order_items
    GROUP BY order_id
),
customer_stats AS (
   SELECT 
        o.customer_id,
        COUNT(CASE WHEN o.status = 'Delivered' THEN 1 END) AS delivered_orders,
        COUNT(CASE WHEN o.status = 'Cancelled' THEN 1 END) AS cancelled_orders,
        ROUND(SUM(CASE WHEN o.status = 'Delivered' THEN it.order_revenue ELSE 0 END), 2) AS lifetime_revenue
    FROM orders o
    LEFT JOIN item_totals it ON o.order_id = it.order_id
    GROUP BY o.customer_id
)
SELECT 
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	c.city,
	YEAR(registration_date) AS registration_year,
	(COALESCE(cs.delivered_orders, 0) + COALESCE(cs.cancelled_orders, 0)) AS total_orders,
    COALESCE(cs.delivered_orders, 0) AS delivered_orders,
    COALESCE(cs.cancelled_orders, 0) AS cancelled_orders,
    COALESCE(cs.lifetime_revenue, 0.00) AS lifetime_revenue,
	ROUND(
        CASE 
            WHEN COALESCE(cs.delivered_orders, 0) > 0 
            THEN cs.lifetime_revenue / cs.delivered_orders 
            ELSE 0.00 
        END, 2
    ) AS avg_order_value,
	CASE
		WHEN COALESCE(cs.lifetime_revenue, 0) > 500000 AND COALESCE(cs.delivered_orders, 0) >= 5 THEN 'VIP'
        WHEN COALESCE(cs.lifetime_revenue, 0) BETWEEN 100000 AND 500000 AND COALESCE(cs.delivered_orders, 0) BETWEEN 2 AND 4 THEN 'Loyal'
        WHEN COALESCE(cs.delivered_orders, 0) = 1 THEN 'One-Time Buyer'
        WHEN (COALESCE(cs.delivered_orders, 0) + COALESCE(cs.cancelled_orders, 0)) >= 1 AND COALESCE(cs.delivered_orders, 0) = 0 THEN 'No Conversions'
        ELSE 'Inactive'
	END AS customer_segment
FROM customers c
LEFT JOIN customer_stats cs 
ON cs.customer_id = c.customer_id
ORDER BY lifetime_revenue DESC, customer_name ASC;

