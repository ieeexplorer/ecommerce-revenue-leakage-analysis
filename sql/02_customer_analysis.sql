-- 02_customer_analysis.sql
-- Customer retention, repeat buying, and churn-risk analysis

-- Customer lifetime value
SELECT
    c.customer_id,
    c.name,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.quantity * o.price - o.discount), 2) AS lifetime_value,
    MIN(o.order_date::date) AS first_order_date,
    MAX(o.order_date::date) AS last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Completed'
  AND p.payment_status IN ('Paid', 'Refunded')
GROUP BY c.customer_id, c.name, c.city
ORDER BY lifetime_value DESC;

-- Repeat customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 1
) t;

-- Churn-risk customers: no purchase in the last 45 days relative to max order date
WITH latest_date AS (
    SELECT MAX(order_date::date) AS max_order_date
    FROM orders
    WHERE order_status = 'Completed'
),
customer_last_order AS (
    SELECT
        customer_id,
        MAX(order_date::date) AS last_order_date
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.name,
    c.city,
    clo.last_order_date
FROM customers c
JOIN customer_last_order clo ON c.customer_id = clo.customer_id
CROSS JOIN latest_date ld
WHERE clo.last_order_date < ld.max_order_date - INTERVAL '45 days'
ORDER BY clo.last_order_date;