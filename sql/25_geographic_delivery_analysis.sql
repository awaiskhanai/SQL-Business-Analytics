-- ============================================================
-- SQL Business Analytics
-- Step 38: Geographic Delivery Performance Analysis
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_state,

        EXTRACT(
            EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )
        ) / 86400.0 AS delivery_days,

        EXTRACT(
            EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_estimated_delivery_date
            )
        ) / 86400.0 AS delivery_difference_days

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    WHERE
        o.order_status = 'delivered'

        AND o.order_purchase_timestamp IS NOT NULL

        AND o.order_delivered_customer_date IS NOT NULL

        AND o.order_estimated_delivery_date IS NOT NULL
),

state_delivery AS (
    SELECT
        customer_state,

        COUNT(*) AS delivered_orders,

        AVG(delivery_days) AS average_delivery_days,

        AVG(delivery_difference_days) AS average_delivery_difference_days

    FROM delivered_orders

    GROUP BY
        customer_state
)

SELECT
    customer_state,

    delivered_orders,

    ROUND(
        delivered_orders * 100.0 /
        SUM(delivered_orders) OVER (),
        2
    ) AS delivered_order_percentage,

    ROUND(
        average_delivery_days,
        2
    ) AS average_delivery_days,

    ROUND(
        average_delivery_difference_days,
        2
    ) AS average_difference_vs_estimate,

    CASE
        WHEN average_delivery_difference_days < 0
            THEN 'Earlier than estimate'

        WHEN average_delivery_difference_days > 0
            THEN 'Later than estimate'

        ELSE 'On estimate'
    END AS delivery_performance

FROM state_delivery

ORDER BY
    average_delivery_days DESC;