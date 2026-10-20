-- ============================================================
-- SQL Business Analytics
-- Step 34: Geographic Order Value Analysis
-- ============================================================

WITH order_values AS (
    SELECT
        o.order_id,
        c.customer_state,

        SUM(oi.price) AS order_revenue,
        SUM(oi.freight_value) AS order_freight

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.order_id,
        c.customer_state
),

state_analysis AS (
    SELECT
        customer_state,

        COUNT(*) AS total_orders,

        ROUND(AVG(order_revenue), 2) AS average_order_revenue,

        ROUND(AVG(order_freight), 2) AS average_freight,

        ROUND(SUM(order_revenue), 2) AS total_revenue,

        ROUND(SUM(order_freight), 2) AS total_freight

    FROM order_values

    GROUP BY
        customer_state
)

SELECT
    customer_state,

    total_orders,

    ROUND(
        total_orders * 100.0 /
        SUM(total_orders) OVER (),
        2
    ) AS order_percentage,

    average_order_revenue,

    average_freight,

    ROUND(
        average_freight /
        NULLIF(average_order_revenue, 0) * 100,
        2
    ) AS freight_to_revenue_percentage,

    total_revenue,

    total_freight

FROM state_analysis

ORDER BY
    total_revenue DESC;