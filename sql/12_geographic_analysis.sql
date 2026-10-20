-- ============================================================
-- SQL Business Analytics
-- Step 25: Geographic Sales Analysis
-- ============================================================

WITH state_sales AS (
    SELECT
        c.customer_state,

        COUNT(DISTINCT o.order_id) AS total_orders,

        COUNT(DISTINCT c.customer_unique_id) AS unique_customers,

        ROUND(SUM(oi.price), 2) AS total_revenue,

        ROUND(SUM(oi.freight_value), 2) AS total_freight,

        ROUND(AVG(oi.price), 2) AS average_item_price

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_state
)

SELECT
    customer_state,
    total_orders,
    unique_customers,
    total_revenue,
    total_freight,
    average_item_price,

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_share_percentage

FROM state_sales

ORDER BY total_revenue DESC;