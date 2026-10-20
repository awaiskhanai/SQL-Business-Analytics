-- ============================================================
-- SQL Business Analytics
-- Step 21: Order Status & Delivery Performance
-- ============================================================

WITH status_summary AS (
    SELECT
        order_status,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY order_status
),

delivery_metrics AS (
    SELECT
        COUNT(*) FILTER (
            WHERE order_status = 'delivered'
        ) AS delivered_orders,

        ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        order_delivered_customer_date
                        - order_purchase_timestamp
                    )
                ) / 86400
            ) FILTER (
                WHERE order_status = 'delivered'
                AND order_delivered_customer_date IS NOT NULL
            ),
            2
        ) AS avg_delivery_days,

        ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        order_delivered_customer_date
                        - order_estimated_delivery_date
                    )
                ) / 86400
            ) FILTER (
                WHERE order_status = 'delivered'
                AND order_delivered_customer_date IS NOT NULL
                AND order_estimated_delivery_date IS NOT NULL
            ),
            2
        ) AS avg_delivery_difference_days
    FROM orders
)

SELECT
    s.order_status,
    s.total_orders,
    ROUND(
        s.total_orders * 100.0 /
        SUM(s.total_orders) OVER (),
        2
    ) AS status_percentage,
    d.delivered_orders,
    d.avg_delivery_days,
    d.avg_delivery_difference_days
FROM status_summary s
CROSS JOIN delivery_metrics d
ORDER BY s.total_orders DESC;