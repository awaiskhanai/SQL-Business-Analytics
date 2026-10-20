-- ============================================================
-- SQL Business Analytics
-- Step 28: Product Performance Analysis
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_id,

        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS category,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        COUNT(*) AS units_sold,

        ROUND(SUM(oi.price), 2) AS total_revenue,

        ROUND(AVG(oi.price), 2) AS average_selling_price,

        ROUND(SUM(oi.freight_value), 2) AS total_freight

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    LEFT JOIN category_translation ct
        ON p.product_category_name = ct.product_category_name

    GROUP BY
        p.product_id,
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        )
)

SELECT
    product_id,
    category,
    total_orders,
    units_sold,
    total_revenue,
    average_selling_price,
    total_freight,

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_share_percentage

FROM product_sales

ORDER BY total_revenue DESC

LIMIT 20;