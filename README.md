# ☕ Cafe Management SQL Database

A small, normalized **MySQL database project** designed to simulate the backend data structure of a real-world café business.

The project focuses on database design, relationships, data integrity, and SQL-based business analysis using **5 related tables**.

---

## 📌 Project Overview

The **Cafe Management Database** stores and analyzes information related to:

- Customers
- Employees
- Products/Menu Items
- Orders
- Order Items

The database is designed using relational database principles and normalized up to **Third Normal Form (3NF)**.

The project also includes SQL queries ranging from basic data retrieval to advanced analytical queries using **CTEs and window functions**.

---

## 🏢 Business Scenario

Imagine a small café that needs to maintain information about its customers, employees, menu items, and sales transactions.

The database should answer questions such as:

- Who are the most valuable customers?
- Which products generate the most revenue?
- Which products sell the most units?
- What is the average order value?
- Which payment method is used most frequently?
- Which category generates the highest revenue?
- Which employee handles the most orders?
- How does revenue change over time?

This project models these requirements using a compact relational database.

---

## 🗂️ Database Structure

The database contains **5 tables**:

```text
customers
    │
    │ 1 : N
    ▼
 orders ──────────────► employees
    │
    │ 1 : N
    ▼
order_items
    │
    │ N : 1
    ▼
 products
```

### 1. `customers`

Stores customer information.

| Column | Description |
|---|---|
| `customer_id` | Primary key |
| `customer_name` | Customer name |
| `phone` | Unique phone number |
| `email` | Unique email |
| `city` | Customer city |
| `registration_date` | Date of registration |

---

### 2. `employees`

Stores café employee information.

| Column | Description |
|---|---|
| `employee_id` | Primary key |
| `employee_name` | Employee name |
| `job_role` | Employee role |
| `phone` | Employee phone |
| `hire_date` | Joining date |
| `salary` | Employee salary |

---

### 3. `products`

Stores menu/product information.

| Column | Description |
|---|---|
| `product_id` | Primary key |
| `product_name` | Product name |
| `category` | Product category |
| `price` | Current product price |
| `is_available` | Product availability |

---

### 4. `orders`

Stores customer order information.

| Column | Description |
|---|---|
| `order_id` | Primary key |
| `customer_id` | Foreign key → `customers` |
| `employee_id` | Foreign key → `employees` |
| `order_date` | Date and time of order |
| `order_status` | Completed/Pending/Cancelled |
| `payment_method` | Cash/UPI/Card |

---

### 5. `order_items`

Stores individual products included in an order.

| Column | Description |
|---|---|
| `order_id` | Foreign key → `orders` |
| `product_id` | Foreign key → `products` |
| `quantity` | Quantity purchased |
| `unit_price` | Price charged for the item |

The table uses a **composite primary key**:

```sql
PRIMARY KEY (order_id, product_id)
```

This prevents the same product from being inserted multiple times into the same order.

---

## 📁 Project Structure

```text
cafe-management-sql/
│
├── README.md
│
├── 01_database_setup.sql
├── 02_table_design.sql
├── 03_insert_data.sql
├── 04_basic_queries.sql
├── 05_intermediate_queries.sql
├── 06_advanced_queries.sql
├── 07_views.sql
└── 08_indexes.sql
```

---

## 🛠️ Technologies Used

- **MySQL 8.0+**
- SQL
- Relational Database Design

---

## ▶️ How to Run

### Step 1 — Clone the repository

```bash
git clone <your-repository-url>
cd cafe-management-sql
```

### Step 2 — Open MySQL

You can use:

- MySQL Workbench
- MySQL Command Line
- VS Code with a MySQL extension
- Any MySQL-compatible database client

### Step 3 — Run the SQL files in order

Execute the files in the following sequence:

```text
01_database_setup.sql
        ↓
02_table_design.sql
        ↓
03_insert_data.sql
        ↓
04_basic_queries.sql
        ↓
05_intermediate_queries.sql
        ↓
06_advanced_queries.sql
        ↓
07_views.sql
        ↓
08_indexes.sql
```

The first three files create and populate the database. The remaining files demonstrate different SQL capabilities.

---

# 📊 SQL Query Levels

## 1️⃣ Basic SQL Queries

`04_basic_queries.sql`

Demonstrates fundamental SQL operations such as:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `BETWEEN`
- Aggregate functions
- `COUNT()`
- `MIN()`
- `MAX()`
- `AVG()`

Example:

```sql
SELECT *
FROM products
WHERE price > 150;
```

---

## 2️⃣ Intermediate SQL Queries

`05_intermediate_queries.sql`

Covers:

- `INNER JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `HAVING`
- Multiple-table joins
- Aggregate calculations
- Subqueries

Example:

```sql
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;
```

---

## 3️⃣ Advanced SQL Queries

`06_advanced_queries.sql`

The advanced section focuses on analytical SQL.

Concepts include:

- Common Table Expressions (`WITH`)
- Window functions
- `RANK()`
- `DENSE_RANK()`
- `PARTITION BY`
- Running totals
- Nested queries
- Revenue contribution analysis
- Above-average analysis
- Category-level ranking

Example:

```sql
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    *,
    DENSE_RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM customer_spending;
```

---

# 👁️ Views

`07_views.sql`

The project includes an `order_summary` view that combines order, customer, and order-item information.

```sql
SELECT *
FROM order_summary;
```

The view provides a reusable representation of order-level information without repeatedly writing the same joins.

---

# ⚡ Indexing

`08_indexes.sql`

Indexes are added to columns frequently used for:

- Filtering
- Joining
- Date-based analysis
- Searching

Examples:

```sql
CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_products_category
ON products(category);
```

Indexes can improve query performance when working with larger datasets.

---

# 🔐 Database Constraints

The database uses several constraints to maintain data integrity.

### Primary Keys

Every main entity has a unique identifier.

```sql
PRIMARY KEY (customer_id)
```

### Foreign Keys

Relationships between tables are enforced using foreign keys.

```sql
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
```

### Unique Constraints

Customer phone numbers and email addresses are unique.

```sql
phone VARCHAR(15) UNIQUE
```

### Check Constraints

Examples:

```sql
CHECK (price > 0)
```

```sql
CHECK (quantity > 0)
```

### Default Values

For example:

```sql
order_status VARCHAR(20) DEFAULT 'Completed'
```

---

# 🧩 Database Normalization

The database follows the principles of:

```text
1NF
 ↓
2NF
 ↓
3NF
```

The design separates different business entities instead of storing everything in a single table.

For example, customer information is stored in `customers`, product information in `products`, and transaction details are separated into `orders` and `order_items`.

This reduces:

- Data redundancy
- Update anomalies
- Insert anomalies
- Delete anomalies

---

# 💼 Business Questions Answered

The SQL queries are designed around practical business questions such as:

### Customer Analysis

- Who are the top customers by spending?
- Which customers have placed multiple orders?
- Which customers have never placed an order?
- What was each customer's first and latest order?

### Product Analysis

- Which products sell the most units?
- Which products generate the highest revenue?
- Which category generates the most revenue?
- What is the best-selling product within each category?

### Sales Analysis

- What is the total revenue?
- What is the average order value?
- Which payment method is most popular?
- What is the monthly revenue?
- What is the running revenue over time?

### Employee Analysis

- Which employee handled the most completed orders?
- How many orders were handled by each employee?

---

# 📈 Key SQL Concepts Demonstrated

```text
Database Creation
       ↓
Table Design
       ↓
Primary & Foreign Keys
       ↓
Constraints
       ↓
Data Insertion
       ↓
Filtering & Sorting
       ↓
JOINs
       ↓
Aggregation
       ↓
GROUP BY / HAVING
       ↓
Subqueries
       ↓
CTEs
       ↓
Window Functions
       ↓
Views
       ↓
Indexes
```

---

# 🎯 Learning Objectives

This project demonstrates practical understanding of:

- Relational database design
- Database normalization
- Entity relationships
- Primary and foreign keys
- Composite keys
- Data integrity
- SQL joins
- Aggregation and grouping
- Business-oriented SQL analysis
- Subqueries
- CTEs
- Window functions
- Views
- Indexing

---

# 🚀 Future Improvements

This project can be extended with additional tables such as:

- Suppliers
- Inventory
- Purchases
- Discounts
- Reviews
- Branches
- Payments

A future version could also connect this database to **Python, Power BI, or a web application** for reporting and visualization.

---

## 👨‍💻 Author

**[Your Friend's Name]**

SQL / Database Project

> This project was created for learning and demonstrating practical SQL and relational database design skills.
