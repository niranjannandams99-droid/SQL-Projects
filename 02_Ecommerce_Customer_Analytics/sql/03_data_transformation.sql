-- Data Transformation
use ecommerce_db;

-- adding Revenue column
alter table ecommerce add Revenue decimal(12,2);

-- calculating revenue
update ecommerce set Revenue = quantity * unitprice;
select * from ecommerce;

-- Add Order Month Column
alter table ecommerce add OrderMonth varchar(20);
update ecommerce set OrderMonth = date_format(invoicedate, '%Y-%m');

-- Verify Transformation
select InvoiceNo,Quantity,UnitPrice,Revenue,OrderMonth from ecommerce; 
