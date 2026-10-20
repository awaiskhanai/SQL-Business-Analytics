-- ============================================================
-- SQL Business Analytics
-- Step 18: Month-over-Month Revenue Growth
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS product_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),

growth_analysis AS (
    SELECT
        month,
        total_orders,
        product_revenue,

        LAG(product_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    month,
    total_orders,
    product_revenue,
    previous_month_revenue,

    ROUND(
        product_revenue - previous_month_revenue,
        2
    ) AS revenue_change,

    ROUND(
        (
            (product_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS revenue_growth_percentage

FROM growth_analysis
ORDER BY month;