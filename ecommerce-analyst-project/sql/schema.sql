-- ============================================================
-- Northwind Traders — Company Database Schema
-- Wholesale food & beverage distribution company
-- ============================================================

CREATE TABLE categories (
    categoryID      INTEGER PRIMARY KEY,
    categoryName    VARCHAR(50) NOT NULL,
    description     TEXT
);

CREATE TABLE suppliers (
    supplierID      INTEGER PRIMARY KEY,
    companyName     VARCHAR(100) NOT NULL,
    contactName     VARCHAR(100),
    contactTitle    VARCHAR(50),
    address         VARCHAR(150),
    city            VARCHAR(50),
    region          VARCHAR(50),
    postalCode      VARCHAR(20),
    country         VARCHAR(50),
    phone           VARCHAR(30),
    fax             VARCHAR(30),
    homePage        TEXT
);

CREATE TABLE products (
    productID       INTEGER PRIMARY KEY,
    productName     VARCHAR(100) NOT NULL,
    supplierID      INTEGER,
    categoryID      INTEGER,
    quantityPerUnit VARCHAR(50),
    unitPrice       DECIMAL(10,2),
    unitsInStock    INTEGER,
    unitsOnOrder    INTEGER,
    reorderLevel    INTEGER,
    discontinued    INTEGER,
    FOREIGN KEY (supplierID) REFERENCES suppliers(supplierID),
    FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
);

CREATE TABLE customers (
    customerID      VARCHAR(5) PRIMARY KEY,
    companyName     VARCHAR(100) NOT NULL,
    contactName     VARCHAR(100),
    contactTitle    VARCHAR(50),
    address         VARCHAR(150),
    city            VARCHAR(50),
    region          VARCHAR(50),
    postalCode      VARCHAR(20),
    country         VARCHAR(50),
    phone           VARCHAR(30),
    fax             VARCHAR(30)
);

CREATE TABLE employees (
    employeeID      INTEGER PRIMARY KEY,
    lastName        VARCHAR(50) NOT NULL,
    firstName       VARCHAR(50) NOT NULL,
    title           VARCHAR(50),
    titleOfCourtesy VARCHAR(20),
    birthDate       DATE,
    hireDate        DATE,
    address         VARCHAR(150),
    city            VARCHAR(50),
    region          VARCHAR(50),
    postalCode      VARCHAR(20),
    country         VARCHAR(50),
    homePhone       VARCHAR(30),
    extension       VARCHAR(10),
    reportsTo       INTEGER,
    FOREIGN KEY (reportsTo) REFERENCES employees(employeeID)
);

CREATE TABLE orders (
    orderID         INTEGER PRIMARY KEY,
    customerID      VARCHAR(5),
    employeeID      INTEGER,
    orderDate       DATE,
    requiredDate    DATE,
    shippedDate     DATE,
    shipVia         INTEGER,
    freight         DECIMAL(10,2),
    shipName        VARCHAR(100),
    shipAddress     VARCHAR(150),
    shipCity        VARCHAR(50),
    shipRegion      VARCHAR(50),
    shipPostalCode  VARCHAR(20),
    shipCountry     VARCHAR(50),
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (employeeID) REFERENCES employees(employeeID)
);

CREATE TABLE order_details (
    orderID         INTEGER,
    productID       INTEGER,
    unitPrice       DECIMAL(10,2),
    quantity        INTEGER,
    discount        DECIMAL(4,2),
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID),
    FOREIGN KEY (productID) REFERENCES products(productID)
);
