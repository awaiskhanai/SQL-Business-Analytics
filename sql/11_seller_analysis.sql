-- ============================================================
-- SQL Business Analytics
-- Step 24: Seller Performance Analysis
-- ============================================================

WITH seller_sales AS (
    SELECT
        s.seller_id,
        s.seller_city,
        s.seller_state,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        COUNT(*) AS items_sold,

        ROUND(SUM(oi.price), 2) AS total_revenue,

        ROUND(AVG(oi.price), 2) AS average_item_price,

        ROUND(SUM(oi.freight_value), 2) AS total_freight

    FROM sellers s

    JOIN order_items oi
        ON s.seller_id = oi.seller_id

    GROUP BY
        s.seller_id,
        s.seller_city,
        s.seller_state
)

SELECT
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    items_sold,
    total_revenue,
    average_item_price,
    total_freight,

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_share_percentage

FROM seller_sales

ORDER BY total_revenue DESC

LIMIT 20;