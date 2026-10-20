-- ============================================================
-- SQL Business Analytics
-- Step 27: RFM Customer Segment Summary
-- ============================================================

WITH customer_rfm AS (
    SELECT
        c.customer_unique_id,

        MAX(o.order_purchase_timestamp) AS last_purchase_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(oi.price), 2) AS monetary_value

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_unique_id
),

rfm_calculated AS (
    SELECT
        customer_unique_id,

        DATE(
            (SELECT MAX(order_purchase_timestamp)
             FROM orders)
        ) -
        DATE(last_purchase_date) AS recency_days,

        frequency,

        monetary_value

    FROM customer_rfm
),

rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM rfm_calculated
),

segmented AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary_value,
        recency_score,
        frequency_score,
        monetary_score,

        CASE
            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'High Value'

            WHEN recency_score >= 4
                 AND frequency_score >= 3
                THEN 'Loyal'

            WHEN recency_score >= 4
                 AND monetary_score >= 4
                THEN 'Potential Loyalist'

            WHEN recency_score <= 2
                 AND monetary_score >= 4
                THEN 'At Risk'

            WHEN recency_score <= 2
                 AND frequency_score <= 2
                THEN 'Inactive'

            ELSE 'Regular'
        END AS customer_segment

    FROM rfm_scored
)

SELECT
    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage,

    ROUND(
        SUM(monetary_value),
        2
    ) AS total_revenue,

    ROUND(
        AVG(monetary_value),
        2
    ) AS average_customer_revenue,

    ROUND(
        AVG(frequency),
        2
    ) AS average_frequency,

    ROUND(
        AVG(recency_days),
        2
    ) AS average_recency_days

FROM segmented

GROUP BY
    customer_segment

ORDER BY
    total_revenue DESC;