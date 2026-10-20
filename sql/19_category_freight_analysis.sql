-- ============================================================
-- SQL Business Analytics
-- Step 32: Category Freight Analysis
-- ============================================================

WITH category_freight AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS category,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        COUNT(*) AS units_sold,

        ROUND(SUM(oi.price), 2) AS product_revenue,

        ROUND(SUM(oi.freight_value), 2) AS total_freight,

        ROUND(AVG(oi.freight_value), 2) AS average_freight_per_item

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
    units_sold,
    product_revenue,
    total_freight,
    average_freight_per_item,

    ROUND(
        total_freight /
        NULLIF(product_revenue, 0) * 100,
        2
    ) AS freight_to_revenue_percentage

FROM category_freight

ORDER BY
    total_freight DESC;