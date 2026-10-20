-- ============================================================
-- SQL Business Analytics
-- Step 30: Customer Lifetime Analysis
-- ============================================================

WITH customer_lifetime AS (
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

customer_groups AS (
    SELECT
        CASE
            WHEN total_orders = 1
                THEN 'One-Time Customer'

            ELSE 'Repeat Customer'
        END AS customer_type,

        COUNT(*) AS customer_count,

        ROUND(AVG(total_orders), 2) AS average_orders_per_customer,

        ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer,

        ROUND(SUM(total_revenue), 2) AS total_revenue

    FROM customer_lifetime

    GROUP BY
        CASE
            WHEN total_orders = 1
                THEN 'One-Time Customer'

            ELSE 'Repeat Customer'
        END
)

SELECT
    customer_type,
    customer_count,

    ROUND(
        customer_count * 100.0 /
        SUM(customer_count) OVER (),
        2
    ) AS customer_percentage,

    average_orders_per_customer,
    average_revenue_per_customer,
    total_revenue,

    ROUND(
        total_revenue /
        NULLIF(SUM(total_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_percentage

FROM customer_groups

ORDER BY
    total_revenue DESC;