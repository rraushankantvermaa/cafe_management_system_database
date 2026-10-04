USE cafe_management;

-- Q25. Top 5 customers by total spending.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_spending
ORDER BY total_spending DESC
LIMIT 5;

-- Q26. Rank customers by spending.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT *,
       DENSE_RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending;

-- Q27. Top 3 products by units sold using a window function.
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.product_id, p.product_name
)
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY units_sold DESC) AS product_rank
    FROM product_sales
) ranked
WHERE product_rank <= 3;

-- Q28. Revenue by category.
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Q29. Best-selling product within each category.
WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category, p.product_id, p.product_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY units_sold DESC
           ) AS category_rank
    FROM product_sales
)
SELECT *
FROM ranked
WHERE category_rank = 1;

-- Q30. Monthly revenue.
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- Q31. Running monthly revenue.
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month
    ) AS running_revenue
FROM monthly_sales;

-- Q32. Highest-value order.
SELECT
    o.order_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.order_id, c.customer_name
ORDER BY order_total DESC
LIMIT 1;

-- Q33. Customers whose spending is above average customer spending.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_spending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM customer_spending
)
ORDER BY total_spending DESC;

-- Q34. Most popular payment method.
SELECT
    payment_method,
    COUNT(*) AS completed_orders
FROM orders
WHERE order_status = 'Completed'
GROUP BY payment_method
ORDER BY completed_orders DESC
LIMIT 1;

-- Q35. Employees ranked by number of completed orders.
WITH employee_orders AS (
    SELECT
        e.employee_id,
        e.employee_name,
        COUNT(o.order_id) AS completed_orders
    FROM employees e
    LEFT JOIN orders o
        ON e.employee_id = o.employee_id
       AND o.order_status = 'Completed'
    GROUP BY e.employee_id, e.employee_name
)
SELECT *,
       RANK() OVER (ORDER BY completed_orders DESC) AS employee_rank
FROM employee_orders;

-- Q36. Customer's first and latest order.
SELECT
    c.customer_name,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS latest_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name;

-- Q37. Customers who bought a product from the Main Course category.
SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Main Course'
  AND o.order_status = 'Completed';

-- Q38. Orders with value above the average order value.
WITH order_values AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id
)
SELECT *
FROM order_values
WHERE order_total > (SELECT AVG(order_total) FROM order_values)
ORDER BY order_total DESC;

-- Q39. Revenue contribution percentage of each product.
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_name,
    revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM product_revenue
ORDER BY revenue DESC;

-- Q40. Identify customers with at least two different product categories purchased.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT p.category) AS categories_purchased
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) >= 2
ORDER BY categories_purchased DESC;
