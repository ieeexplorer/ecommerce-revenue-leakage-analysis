-- 04_retention_queries.sql
-- Monthly cohort retention analysis

WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date::date)) AS cohort_month
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
activity AS (
    SELECT
        o.customer_id,
        DATE_TRUNC('month', o.order_date::date) AS activity_month
    FROM orders o
    WHERE o.order_status = 'Completed'
),
cohort_activity AS (
    SELECT
        fp.cohort_month,
        a.activity_month,
        EXTRACT(YEAR FROM AGE(a.activity_month, fp.cohort_month)) * 12
        + EXTRACT(MONTH FROM AGE(a.activity_month, fp.cohort_month)) AS month_number,
        COUNT(DISTINCT a.customer_id) AS active_customers
    FROM first_purchase fp
    JOIN activity a ON fp.customer_id = a.customer_id
    GROUP BY fp.cohort_month, a.activity_month, month_number
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM first_purchase
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.month_number,
    cs.cohort_size,
    ca.active_customers,
    ROUND(100.0 * ca.active_customers / NULLIF(cs.cohort_size, 0), 2) AS retention_rate_pct
FROM cohort_activity ca
JOIN cohort_size cs ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.month_number;