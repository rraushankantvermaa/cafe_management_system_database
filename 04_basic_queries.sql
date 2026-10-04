USE cafe_management;

-- Q1. Display all customers.
SELECT * FROM customers;

-- Q2. Display all products.
SELECT * FROM products;

-- Q3. Find products costing more than 150.
SELECT * FROM products WHERE price > 150;

-- Q4. Find customers from Dhanbad.
SELECT * FROM customers WHERE city = 'Dhanbad';

-- Q5. Display products from highest to lowest price.
SELECT * FROM products ORDER BY price DESC;

-- Q6. Find available products.
SELECT * FROM products WHERE is_available = TRUE;

-- Q7. Find employees earning more than 20000.
SELECT employee_name, job_role, salary
FROM employees
WHERE salary > 20000;

-- Q8. Find orders paid using UPI.
SELECT * FROM orders WHERE payment_method = 'UPI';

-- Q9. Count total customers.
SELECT COUNT(*) AS total_customers FROM customers;

-- Q10. Find minimum, maximum and average product price.
SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price
FROM products;
