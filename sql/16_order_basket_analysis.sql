-- ============================================================
-- SQL Business Analytics
-- Step 29: Order Basket Analysis
-- ============================================================

WITH order_baskets AS (
    SELECT
        oi.order_id,

        COUNT(*) AS items_in_order,

        ROUND(SUM(oi.price), 2) AS order_revenue,

        ROUND(SUM(oi.freight_value), 2) AS order_freight

    FROM order_items oi

    GROUP BY
        oi.order_id
),

basket_groups AS (
    SELECT
        CASE
            WHEN items_in_order = 1 THEN 'Single Item'
            WHEN items_in_order BETWEEN 2 AND 3 THEN '2-3 Items'
            WHEN items_in_order BETWEEN 4 AND 5 THEN '4-5 Items'
            ELSE '6+ Items'
        END AS basket_size,

        COUNT(*) AS total_orders,

        ROUND(AVG(items_in_order), 2) AS average_items_per_order,

        ROUND(AVG(order_revenue), 2) AS average_order_revenue,

        ROUND(SUM(order_revenue), 2) AS total_revenue,

        ROUND(AVG(order_freight), 2) AS average_freight

    FROM order_baskets

    GROUP BY
        CASE
            WHEN items_in_order = 1 THEN 'Single Item'
            WHEN items_in_order BETWEEN 2 AND 3 THEN '2-3 Items'
            WHEN items_in_order BETWEEN 4 AND 5 THEN '4-5 Items'
            ELSE '6+ Items'
        END
)

SELECT
    basket_size,
    total_orders,

    ROUND(
        total_orders * 100.0 /
        SUM(total_orders) OVER (),
        2
    ) AS order_percentage,

    average_items_per_order,
    average_order_revenue,
    total_revenue,
    average_freight

FROM basket_groups

ORDER BY
    CASE basket_size
        WHEN 'Single Item' THEN 1
        WHEN '2-3 Items' THEN 2
        WHEN '4-5 Items' THEN 3
        WHEN '6+ Items' THEN 4
    END;