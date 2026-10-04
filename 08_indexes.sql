USE cafe_management;

-- Useful indexes for frequent filtering/joining.
CREATE INDEX idx_customers_city
ON customers(city);

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_employee
ON orders(employee_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_orders_status
ON orders(order_status);

CREATE INDEX idx_products_category
ON products(category);

CREATE INDEX idx_order_items_product
ON order_items(product_id);

-- Inspect indexes
SHOW INDEX FROM customers;
SHOW INDEX FROM orders;
SHOW INDEX FROM products;
