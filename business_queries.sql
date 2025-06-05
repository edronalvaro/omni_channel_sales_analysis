-- What are the top 5 customers with the highest total order value?

SELECT c.customer_name, SUM(so.total_value) AS total_spent
FROM customers c
JOIN sales_orders so ON c.customer_id = so.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Highest performing categories 

SELECT p.category, SUM(t.quantity * t.price) AS total_revenue
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- How many unique customers have made purchases in the last 30 days?

SELECT COUNT(DISTINCT so.customer_id) AS unique_customers
FROM sales_orders so
WHERE so.order_date >= CURDATE() - INTERVAL 30 DAY;

-- What is the total revenue (sum of total_value) by region (from stores.region)?

SELECT s.region, SUM(so.total_value) AS total_revenue
FROM stores s
JOIN sales_orders so ON s.store_id = so.store_id
GROUP BY s.region;

-- Find the average order value by payment method (e.g., Credit Card, PayPal).

SELECT so.payment_method, AVG(so.total_value) AS avg_total_value
FROM sales_orders so 
GROUP BY so.payment_method
ORDER BY avg_total_value DESC;

-- Which products generated the most revenue in the last 6 months?

SELECT p.product_name, SUM(t.quantity * t.price) AS total_revenue
FROM products p
JOIN transactions t ON p.product_id = t.product_id
JOIN sales_orders so ON t.order_id = so.order_id
WHERE so.order_date >= CURDATE() - INTERVAL 6 MONTH
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Find the employees with the most sales based on total order value.

SELECT e.employee_name, SUM(so.total_value) AS total_order_value 
FROM employees e 
	JOIN sales_orders so ON e.employee_id = so.employee_id
GROUP BY e.employee_name
ORDER BY total_order_value DESC;

-- Identify the top 3 stores in terms of total sales value and analyze their performance across regions.

SELECT s.store_id, s.region, SUM(so.total_value) AS total_sales 
FROM stores s 
	JOIN sales_orders so ON s.store_id = so.store_id 
GROUP BY s.store_id
ORDER BY total_sales DESC
LIMIT 3;

-- What are the top 5 products sold by total quantity ordered?

SELECT p.product_name, SUM(t.quantity) AS total_sold 
FROM products p 
	JOIN transactions t ON p.product_id = t.product_id 
GROUP BY p.product_name 
ORDER BY total_sold
LIMIT 5;

-- For each product category, calculate the total sales value and the average quantity sold per transaction.

SELECT p.category, SUM(t.quantity * t.price) AS total_sales, AVG(t.quantity) AS avg_qty_sold
FROM products p 
	JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.category;

-- Which employee handled the most sales transactions in terms of revenue?

SELECT e.employee_name, SUM(so.total_value) AS total_sales
FROM employees e 
	JOIN sales_orders so ON e.employee_id = so.employee_id
GROUP BY e.employee_name
ORDER BY total_sales DESC
LIMIT 1;

-- Find the employees with the highest average order value.

SELECT e.employee_name, AVG(so.total_value) AS avg_order_value
FROM employees e 
	JOIN sales_orders so ON e.employee_id = so.employee_id
GROUP BY e.employee_name
ORDER BY avg_order_value DESC;

-- Calculate the conversion rate for each store (number of transactions divided by total orders).

SELECT st.store_location, 
       (COUNT(DISTINCT t.transaction_id) / COUNT(so.order_id)) * 100 AS conversion_rate
FROM stores st
	JOIN sales_orders so ON st.store_id = so.store_id
	LEFT JOIN transactions t ON so.order_id = t.order_id
GROUP BY st.store_location
ORDER BY conversion_rate DESC;

-- Which customers spent the most, and how do they rank?

SELECT customer_id,
	SUM(total_value) AS total_spent,
	RANK() OVER (ORDER BY SUM(total_value) DESC) AS spending_rank
FROM sales_orders
GROUP BY customer_id;

-- Which customers placed multiple orders, and how many days passed between them?

SELECT customer_id, 
       order_id, 
       order_date, 
       LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date, 
       DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
FROM sales_orders;

-- Categorize customers into High, Medium, and Low spenders.

SELECT customer_id, 
       SUM(total_value) AS total_spent,
       CASE 
           WHEN SUM(total_value) > 500 THEN 'High Spender'
           WHEN SUM(total_value) BETWEEN 200 AND 500 THEN 'Medium Spender'
           ELSE 'Low Spender'
       END AS spending_category
FROM sales_orders
GROUP BY customer_id;


-- Rolling Total

SELECT order_id,
       order_date,
       total_value,
       SUM(total_value) OVER (ORDER BY order_date) AS rolling_total
FROM sales_orders
ORDER BY order_date;
