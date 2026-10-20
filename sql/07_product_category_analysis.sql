-- ============================================================
-- SQL Business Analytics
-- Step 20: Product & Category Analysis
-- ============================================================

WITH category_sales AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS category,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        COUNT(*) AS items_sold,
        ROUND(SUM(oi.price), 2) AS product_revenue,
        ROUND(AVG(oi.price), 2) AS average_product_price
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation ct
        ON p.product_category_name = ct.product_category_name
    GROUP BY
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        )
)

SELECT
    category,
    total_orders,
    items_sold,
    product_revenue,
    average_product_price,
    ROUND(
        product_revenue /
        NULLIF(SUM(product_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_share_percentage
FROM category_sales
ORDER BY product_revenue DESC
LIMIT 10;