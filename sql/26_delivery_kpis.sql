-- ============================================================
-- SQL Business Analytics
-- Step 39: Overall Delivery KPIs
-- ============================================================

WITH delivery_data AS (
    SELECT
        order_id,

        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )
        ) / 86400.0 AS delivery_days,

        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_delivered_carrier_date
            )
        ) / 86400.0 AS carrier_to_customer_days,

        EXTRACT(
            EPOCH FROM (
                order_delivered_carrier_date
                - order_purchase_timestamp
            )
        ) / 86400.0 AS purchase_to_carrier_days,

        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_estimated_delivery_date
            )
        ) / 86400.0 AS difference_vs_estimate

    FROM orders

    WHERE
        order_status = 'delivered'

        AND order_purchase_timestamp IS NOT NULL

        AND order_delivered_carrier_date IS NOT NULL

        AND order_delivered_customer_date IS NOT NULL

        AND order_estimated_delivery_date IS NOT NULL
)

SELECT
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(delivery_days),
        2
    ) AS average_total_delivery_days,

    ROUND(
        MIN(delivery_days),
        2
    ) AS fastest_delivery_days,

    ROUND(
        MAX(delivery_days),
        2
    ) AS slowest_delivery_days,

    ROUND(
        AVG(purchase_to_carrier_days),
        2
    ) AS average_purchase_to_carrier_days,

    ROUND(
        AVG(carrier_to_customer_days),
        2
    ) AS average_carrier_to_customer_days,

    ROUND(
        AVG(difference_vs_estimate),
        2
    ) AS average_difference_vs_estimate

FROM delivery_data;