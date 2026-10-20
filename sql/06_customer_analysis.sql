-- ============================================================
-- SQL Business Analytics
-- Combined Step 19: Customer Analytics (All-in-One View)
-- ============================================================

-- Metric Group 1 & 3 & 4: Overview Metrics
SELECT 
    '1. Frequency: One-time vs Repeat' AS analysis_section,
    customer_type AS metric_name, 
    customer_count::TEXT AS metric_value
FROM (
    WITH customer_orders AS (
        SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_unique_id
    )
    SELECT 
        CASE WHEN order_count = 1 THEN 'One-time customer' ELSE 'Repeat customer' END AS customer_type,
        COUNT(*) AS customer_count
    FROM customer_orders
    GROUP BY 1
) frequency_data

UNION ALL

SELECT 
    '3. Average Revenue per Customer' AS analysis_section,
    'Average Revenue ($)' AS metric_name,
    ROUND(SUM(oi.price) / COUNT(DISTINCT c.customer_unique_id), 2)::TEXT AS metric_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id

UNION ALL

SELECT 
    '4. Customers with 2+ Orders' AS analysis_section,
    'Repeat Customer Count' AS metric_name,
    COUNT(*)::TEXT AS metric_value
FROM (
    SELECT c.customer_unique_id
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) >= 2
) as repeat_list

UNION ALL

-- Metric Group 2: Top 10 Customers (Formatted to fit the table)
SELECT 
    '2. Top 10 Customers by Revenue' AS analysis_section,
    'ID: ' || customer_unique_id || ' (' || total_orders || ' orders)' AS metric_name,
    '$' || total_revenue::TEXT AS metric_value
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
    ORDER BY total_revenue DESC
    LIMIT 10
) top_10;
