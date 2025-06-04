# Omni-Channel Retail SQL Analysis

This SQL project explores a simulated omni-channel retail dataset with a focus on analyzing customer behavior, sales performance, product trends, employee contributions, and regional metrics.

## Project Overview

This project was created to showcase SQL skills relevant to a data analyst role, including:

- Schema design for multiple retail entities
- Business-driven SQL queries
- Window functions for advanced analytics
- Views for modular, reusable reporting

The dataset is AI-generated and represents a retail business with both online and in-store purchases.

---

## Database Structure

The project is structured around 6 core tables:

- `customers`
- `products`
- `stores`
- `employees`
- `sales_orders`
- `transactions`

All tables are connected with proper primary and foreign keys to simulate realistic business data relationships.

---

## Key Business Questions Answered

Some examples of questions this project answers:

- Who are the top 5 customers by total spend?
- Which categories or products generate the most revenue?
- What is the revenue breakdown by region?
- How do employees rank by total sales or average order value?
- What is the store-level conversion rate?
- Which customers are high, medium, or low spenders?
- What are the rolling revenue trends over time?

---

## SQL Techniques Used

- **JOINs** for multi-table analysis
- **Aggregate Functions** (SUM, AVG, COUNT)
- **Window Functions** (RANK, LAG, SUM OVER)
- **CASE WHEN** for conditional categorization
- **Views** for reusable reporting layers
- **Date filtering** with `CURDATE()` and intervals

---

## Example Query

```sql
SELECT customer_id,
       SUM(total_value) AS total_spent,
       RANK() OVER (ORDER BY SUM(total_value) DESC) AS spending_rank
FROM sales_orders
GROUP BY customer_id;
