USE cafe_management;

DROP VIEW IF EXISTS order_summary;
CREATE VIEW order_summary AS
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.payment_method,
    o.order_status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    c.customer_name,
    o.order_date,
    o.payment_method,
    o.order_status;

-- Test the view
SELECT * FROM order_summary;
