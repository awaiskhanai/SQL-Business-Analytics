SELECT 
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM sellers) AS total_sellers,
    (SELECT ROUND(SUM(price), 2) FROM order_items) AS total_product_revenue,
    (SELECT ROUND(SUM(freight_value), 2) FROM order_items) AS total_freight_value,
    (SELECT ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) FROM order_items) AS average_order_value,
    (SELECT ROUND(SUM(freight_value) / COUNT(DISTINCT order_id), 2) FROM order_items) AS average_freight_per_order,
    (SELECT ROUND(SUM(payment_value), 2) FROM order_payments) AS total_payment_value,
    (SELECT ROUND(AVG(review_score), 2) FROM order_reviews) AS average_review_score;
