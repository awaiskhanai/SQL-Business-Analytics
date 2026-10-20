-- ============================================================
-- SQL Business Analytics
-- Step 15: Performance Indexes
-- ============================================================

-- Orders
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX idx_orders_purchase_timestamp
ON orders(order_purchase_timestamp);

CREATE INDEX idx_orders_status
ON orders(order_status);


-- Order Items
CREATE INDEX idx_order_items_product_id
ON order_items(product_id);

CREATE INDEX idx_order_items_seller_id
ON order_items(seller_id);


-- Payments
CREATE INDEX idx_order_payments_payment_type
ON order_payments(payment_type);


-- Reviews
CREATE INDEX idx_order_reviews_order_id
ON order_reviews(order_id);


-- Products
CREATE INDEX idx_products_category
ON products(product_category_name);


-- Customers
CREATE INDEX idx_customers_unique_id
ON customers(customer_unique_id);