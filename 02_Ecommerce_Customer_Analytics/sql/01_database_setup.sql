-- E-Commerce Customer Intelligence Project

-- creating database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- table create
CREATE TABLE ecommerce (
InvoiceNo VARCHAR(20),
StockCode VARCHAR(20),
Description VARCHAR(255),
Quantity INT,
InvoiceDate VARCHAR(50),
UnitPrice DECIMAL(10,2),
CustomerID VARCHAR(50),
Country VARCHAR(50));

-- indexing
CREATE INDEX idx_customer_id ON ecommerce(CustomerID);
CREATE INDEX idx_invoice_date ON ecommerce(InvoiceDate);
