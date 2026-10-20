-- ============================================================
-- SQL Business Analytics
-- Step 35: Geographic Customer Retention Analysis
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.price) AS customer_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_unique_id,
        c.customer_state
),

state_retention AS (
    SELECT
        customer_state,

        COUNT(*) AS total_customers,

        COUNT(*) FILTER (
            WHERE order_count = 1
        ) AS one_time_customers,

        COUNT(*) FILTER (
            WHERE order_count >= 2
        ) AS repeat_customers,

        SUM(customer_revenue) AS total_revenue,

        SUM(customer_revenue) FILTER (
            WHERE order_count >= 2
        ) AS repeat_customer_revenue

    FROM customer_orders

    GROUP BY
        customer_state
)

SELECT
    customer_state,

    total_customers,

    one_time_customers,

    repeat_customers,

    ROUND(
        repeat_customers * 100.0 /
        NULLIF(total_customers, 0),
        2
    ) AS repeat_customer_rate,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        repeat_customer_revenue,
        2
    ) AS repeat_customer_revenue,

    ROUND(
        repeat_customer_revenue * 100.0 /
        NULLIF(total_revenue, 0),
        2
    ) AS repeat_revenue_percentage

FROM state_retention

ORDER BY
    repeat_customer_rate DESC;