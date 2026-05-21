-- Loading Data into MySQL
-- SHOW VARIABLES LIKE 'secure_file_priv'; -- MySQL-only command
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data.csv'
into table ecommerce
character set Latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\n' 
ignore 1 rows;

select count(*) from ecommerce limit 10;

#-- Data Cleaning 
-- clean customerids
update ecommerce set CustomerID = null where CustomerID = '';

-- remove null customer
delete from ecommerce where CustomerID is null;

#-- converting data types
-- convert InvoiceDate to datetime
update ecommerce set InvoiceDate = str_to_date(InvoiceDate, '%m/%d/%Y %H:%i');

alter table ecommerce modify invoicedate datetime;

desc ecommerce;

-- converting customerid to int
alter table ecommerce modify customerid int; 
