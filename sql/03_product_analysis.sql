-- 03_product_analysis.sql
-- Product, category, returns, margin, and discount analysis

-- Revenue and margin by category
SELECT
    pr.category,
    ROUND(SUM(o.quantity * o.price - o.discount), 2) AS revenue,
    ROUND(SUM((o.quantity * o.price - o.discount) - (o.quantity * pr.cost_price)), 2) AS gross_margin
FROM orders o
JOIN products pr ON o.product_id = pr.product_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Completed'
  AND p.payment_status IN ('Paid', 'Refunded')
GROUP BY pr.category
ORDER BY revenue DESC;

-- Return rate by category
SELECT
    pr.category,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT r.order_id) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS return_rate_pct
FROM orders o
JOIN products pr ON o.product_id = pr.product_id
LEFT JOIN returns r ON o.order_id = r.order_id
WHERE o.order_status = 'Completed'
GROUP BY pr.category
ORDER BY return_rate_pct DESC;

-- Top products by revenue
SELECT
    pr.product_id,
    pr.subcategory,
    pr.brand,
    ROUND(SUM(o.quantity * o.price - o.discount), 2) AS revenue
FROM orders o
JOIN products pr ON o.product_id = pr.product_id
WHERE o.order_status = 'Completed'
GROUP BY pr.product_id, pr.subcategory, pr.brand
ORDER BY revenue DESC
LIMIT 10;

-- Discount impact
SELECT
    pr.category,
    ROUND(AVG(o.discount), 2) AS avg_discount,
    ROUND(AVG(o.quantity * o.price - o.discount), 2) AS avg_net_revenue_per_order
FROM orders o
JOIN products pr ON o.product_id = pr.product_id
WHERE o.order_status = 'Completed'
GROUP BY pr.category
ORDER BY avg_discount DESC;