-- ============================================================
-- SQL Business Analytics
-- Step 36: Order Status & Revenue Impact Analysis
-- ============================================================

WITH order_values AS (
    SELECT
        o.order_id,
        o.order_status,

        SUM(oi.price) AS order_revenue,

        SUM(oi.freight_value) AS order_freight

    FROM orders o

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.order_id,
        o.order_status
),

status_analysis AS (
    SELECT
        order_status,

        COUNT(*) AS total_orders,

        COUNT(*) FILTER (
            WHERE order_revenue IS NOT NULL
        ) AS orders_with_items,

        COALESCE(
            SUM(order_revenue),
            0
        ) AS total_revenue,

        COALESCE(
            SUM(order_freight),
            0
        ) AS total_freight,

        AVG(order_revenue)
            FILTER (WHERE order_revenue IS NOT NULL)
            AS average_order_revenue

    FROM order_values

    GROUP BY
        order_status
)

SELECT
    order_status,

    total_orders,

    ROUND(
        total_orders * 100.0 /
        SUM(total_orders) OVER (),
        2
    ) AS order_percentage,

    orders_with_items,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(total_freight, 2) AS total_freight,

    ROUND(
        average_order_revenue,
        2
    ) AS average_order_revenue

FROM status_analysis

ORDER BY
    total_orders DESC;