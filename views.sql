-- Top 5 customers by total spent.
CREATE VIEW top_customers AS
SELECT c.customer_name, SUM(so.total_value) AS total_spent
FROM customers c
JOIN sales_orders so ON c.customer_id = so.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Revenue by Region
CREATE VIEW revenue_by_region AS
SELECT s.region, SUM(so.total_value) AS total_revenue
FROM stores s
JOIN sales_orders so ON s.store_id = so.store_id
GROUP BY s.region;

-- Total Sales by Product Category
CREATE VIEW total_sales_by_category AS
SELECT p.category, SUM(t.quantity * t.price) AS total_sales, AVG(t.quantity) AS avg_qty_sold
FROM products p 
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.category;

-- Employees with the Most Sales Based on Total Order Value
CREATE VIEW top_employees_by_sales AS
SELECT e.employee_name, SUM(so.total_value) AS total_order_value 
FROM employees e 
JOIN sales_orders so ON e.employee_id = so.employee_id
GROUP BY e.employee_name
ORDER BY total_order_value DESC;

-- Conversion Rate by Store
CREATE VIEW store_conversion_rate AS
SELECT st.store_location, 
       (COUNT(DISTINCT t.transaction_id) / COUNT(so.order_id)) * 100 AS conversion_rate
FROM stores st
JOIN sales_orders so ON st.store_id = so.store_id
LEFT JOIN transactions t ON so.order_id = t.order_id
GROUP BY st.store_location
ORDER BY conversion_rate DESC;

-- Customer Spending Category
CREATE VIEW customer_spending_category AS
SELECT customer_id, 
       SUM(total_value) AS total_spent,
       CASE 
           WHEN SUM(total_value) > 500 THEN 'High Spender'
           WHEN SUM(total_value) BETWEEN 200 AND 500 THEN 'Medium Spender'
           ELSE 'Low Spender'
       END AS spending_category
FROM sales_orders
GROUP BY customer_id;
