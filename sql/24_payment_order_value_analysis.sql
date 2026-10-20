-- ============================================================
-- SQL Business Analytics
-- Step 37: Payment Method & Order Value Analysis
-- ============================================================

WITH order_payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM order_payments
    GROUP BY
        order_id
),

payment_analysis AS (
    SELECT
        op.payment_type,

        COUNT(*) AS payment_transactions,

        COUNT(DISTINCT op.order_id) AS unique_orders,

        SUM(op.payment_value) AS total_payment_value,

        AVG(op.payment_value) AS average_payment_value,

        AVG(opt.total_payment_value) AS average_order_payment

    FROM order_payments op

    JOIN order_payment_totals opt
        ON op.order_id = opt.order_id

    GROUP BY
        op.payment_type
)

SELECT
    payment_type,

    payment_transactions,

    unique_orders,

    ROUND(
        unique_orders * 100.0 /
        SUM(unique_orders) OVER (),
        2
    ) AS order_share_percentage,

    ROUND(total_payment_value, 2)
        AS total_payment_value,

    ROUND(average_payment_value, 2)
        AS average_payment_value,

    ROUND(average_order_payment, 2)
        AS average_order_payment

FROM payment_analysis

ORDER BY
    total_payment_value DESC;