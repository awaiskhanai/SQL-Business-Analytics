-- ============================================================
-- SQL Business Analytics
-- Step 33: Order Value & Freight Analysis
-- ============================================================

WITH order_values AS (
    SELECT
        oi.order_id,

        ROUND(SUM(oi.price), 2) AS order_revenue,

        ROUND(SUM(oi.freight_value), 2) AS order_freight

    FROM order_items oi

    GROUP BY
        oi.order_id
),

order_groups AS (
    SELECT
        CASE
            WHEN order_revenue < 50
                THEN 'Under $50'

            WHEN order_revenue < 100
                THEN '$50-$100'

            WHEN order_revenue < 250
                THEN '$100-$250'

            WHEN order_revenue < 500
                THEN '$250-$500'

            ELSE '$500+'
        END AS order_value_group,

        COUNT(*) AS total_orders,

        ROUND(AVG(order_revenue), 2) AS average_order_revenue,

        ROUND(AVG(order_freight), 2) AS average_freight,

        ROUND(SUM(order_revenue), 2) AS total_revenue,

        ROUND(SUM(order_freight), 2) AS total_freight

    FROM order_values

    GROUP BY
        CASE
            WHEN order_revenue < 50
                THEN 'Under $50'

            WHEN order_revenue < 100
                THEN '$50-$100'

            WHEN order_revenue < 250
                THEN '$100-$250'

            WHEN order_revenue < 500
                THEN '$250-$500'

            ELSE '$500+'
        END
)

SELECT
    order_value_group,
    total_orders,

    ROUND(
        total_orders * 100.0 /
        SUM(total_orders) OVER (),
        2
    ) AS order_percentage,

    average_order_revenue,
    average_freight,

    ROUND(
        average_freight /
        NULLIF(average_order_revenue, 0) * 100,
        2
    ) AS freight_to_revenue_percentage,

    total_revenue,
    total_freight

FROM order_groups

ORDER BY
    CASE order_value_group
        WHEN 'Under $50' THEN 1
        WHEN '$50-$100' THEN 2
        WHEN '$100-$250' THEN 3
        WHEN '$250-$500' THEN 4
        WHEN '$500+' THEN 5
    END;