-- ============================================================
-- SQL Business Analytics
-- Step 22: Payment Method Analysis
-- ============================================================

SELECT
    payment_type,
    COUNT(*) AS payment_transactions,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value,
    ROUND(
        SUM(payment_value) * 100.0 /
        SUM(SUM(payment_value)) OVER (),
        2
    ) AS payment_value_share_percentage
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;