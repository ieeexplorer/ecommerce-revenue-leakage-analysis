-- 01_kpi_queries.sql
-- Core KPIs for the executive summary page

WITH base_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date::date AS order_date,
        DATE_TRUNC('month', o.order_date::date) AS order_month,
        o.quantity,
        o.price,
        o.discount,
        (o.quantity * o.price - o.discount) AS revenue,
        p.payment_status,
        s.delivery_performance
    FROM orders o
    LEFT JOIN payments p ON o.order_id = p.order_id
    LEFT JOIN shipping s ON o.order_id = s.order_id
    WHERE o.order_status = 'Completed'
)
SELECT
    order_month,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value,
    ROUND(
        100.0 * SUM(CASE WHEN delivery_performance = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS on_time_delivery_rate_pct
FROM base_orders
WHERE payment_status IN ('Paid', 'Refunded')
GROUP BY order_month
ORDER BY order_month;

-- Overall return rate
SELECT
    ROUND(
        100.0 * COUNT(DISTINCT r.order_id) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS return_rate_pct
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
WHERE o.order_status = 'Completed';

-- Revenue by region
SELECT
    s.region,
    ROUND(SUM(o.quantity * o.price - o.discount), 2) AS revenue
FROM orders o
JOIN shipping s ON o.order_id = s.order_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Completed'
  AND p.payment_status IN ('Paid', 'Refunded')
GROUP BY s.region
ORDER BY revenue DESC;