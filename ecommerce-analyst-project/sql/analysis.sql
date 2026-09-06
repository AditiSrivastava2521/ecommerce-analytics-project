-- ============================================================
-- Northwind Traders — Business Analysis Queries
-- ============================================================

-- Q1: Monthly revenue trend (company-wide)
SELECT
    strftime('%Y-%m', o.orderDate) AS month,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue
FROM orders o
JOIN order_details od ON o.orderID = od.orderID
GROUP BY month
ORDER BY month;

-- Q2: Top 10 products by revenue
SELECT
    p.productName,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue,
    SUM(od.quantity) AS units_sold
FROM order_details od
JOIN products p ON od.productID = p.productID
GROUP BY p.productName
ORDER BY revenue DESC
LIMIT 10;

-- Q3: Revenue by country
SELECT
    c.country,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue,
    COUNT(DISTINCT o.orderID) AS num_orders
FROM orders o
JOIN customers c ON o.customerID = c.customerID
JOIN order_details od ON o.orderID = od.orderID
GROUP BY c.country
ORDER BY revenue DESC;

-- Q4: Employee sales performance ranking (window function)
SELECT
    e.firstName || ' ' || e.lastName AS employee,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(od.unitPrice * od.quantity * (1 - od.discount)) DESC) AS sales_rank
FROM orders o
JOIN employees e ON o.employeeID = e.employeeID
JOIN order_details od ON o.orderID = od.orderID
GROUP BY employee
ORDER BY sales_rank;

-- Q5: Customer RFM inputs (Recency, Frequency, Monetary)
SELECT
    c.customerID,
    c.companyName,
    JULIANDAY('1998-05-06') - JULIANDAY(MAX(o.orderDate)) AS recency_days,
    COUNT(DISTINCT o.orderID) AS frequency,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS monetary
FROM customers c
JOIN orders o ON c.customerID = o.customerID
JOIN order_details od ON o.orderID = od.orderID
GROUP BY c.customerID, c.companyName
ORDER BY monetary DESC
LIMIT 20;

-- Q6: Average delivery time & late delivery rate by shipper
SELECT
    o.shipVia AS shipper_id,
    ROUND(AVG(JULIANDAY(o.shippedDate) - JULIANDAY(o.orderDate)), 1) AS avg_delivery_days,
    ROUND(100.0 * SUM(CASE WHEN o.shippedDate > o.requiredDate THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_pct
FROM orders o
WHERE o.shippedDate IS NOT NULL
GROUP BY o.shipVia;

-- Q7: Revenue by product category
SELECT
    cat.categoryName,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue
FROM order_details od
JOIN products p ON od.productID = p.productID
JOIN categories cat ON p.categoryID = cat.categoryID
GROUP BY cat.categoryName
ORDER BY revenue DESC;

-- Q8: Month-over-month revenue growth % (window function: LAG)
WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.orderDate) AS month,
        SUM(od.unitPrice * od.quantity * (1 - od.discount)) AS revenue
    FROM orders o
    JOIN order_details od ON o.orderID = od.orderID
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Q9: Customers who ordered only once (churn risk / one-time buyers)
SELECT
    c.companyName,
    c.country,
    COUNT(o.orderID) AS total_orders
FROM customers c
JOIN orders o ON c.customerID = o.customerID
GROUP BY c.customerID, c.companyName, c.country
HAVING COUNT(o.orderID) = 1
ORDER BY c.country;

-- Q10: Top supplier by revenue contribution
SELECT
    s.companyName AS supplier,
    ROUND(SUM(od.unitPrice * od.quantity * (1 - od.discount)), 2) AS revenue
FROM order_details od
JOIN products p ON od.productID = p.productID
JOIN suppliers s ON p.supplierID = s.supplierID
GROUP BY s.companyName
ORDER BY revenue DESC
LIMIT 10;
