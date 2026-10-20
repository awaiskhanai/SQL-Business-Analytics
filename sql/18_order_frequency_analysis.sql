-- ============================================================
-- SQL Business Analytics
-- Step 31: Customer Order Frequency Analysis
-- ============================================================

WITH customer_frequency AS (
    SELECT
        c.customer_unique_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        ROUND(SUM(oi.price), 2) AS total_revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_unique_id
),

frequency_groups AS (
    SELECT
        CASE
            WHEN total_orders = 1 THEN '1 Order'
            WHEN total_orders = 2 THEN '2 Orders'
            WHEN total_orders = 3 THEN '3 Orders'
            WHEN total_orders = 4 THEN '4 Orders'
            ELSE '5+ Orders'
        END AS order_frequency,

        COUNT(*) AS customer_count,

        ROUND(AVG(total_revenue), 2) AS average_customer_revenue,

        ROUND(SUM(total_revenue), 2) AS total_revenue

    FROM customer_frequency

    GROUP BY
        CASE
            WHEN total_orders = 1 THEN '1 Order'
            WHEN total_orders = 2 THEN '2 Orders'
            WHEN total_orders = 3 THEN '3 Orders'
            WHEN total_orders = 4 THEN '4 Orders'
            ELSE '5+ Orders'
        END
)

SELECT
    order_frequency,
    customer_count,

    ROUND(
        customer_count * 100.0 /
        SUM(customer_count) OVER (),
        2
    ) AS customer_percentage,

    average_customer_revenue,
    total_revenue,

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_percentage

FROM frequency_groups

ORDER BY
    CASE order_frequency
        WHEN '1 Order' THEN 1
        WHEN '2 Orders' THEN 2
        WHEN '3 Orders' THEN 3
        WHEN '4 Orders' THEN 4
        WHEN '5+ Orders' THEN 5
    END;