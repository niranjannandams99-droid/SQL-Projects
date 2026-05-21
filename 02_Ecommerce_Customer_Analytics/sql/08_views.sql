-- SQL Views for Business Reporting

use ecommerce_db;


-- Monthly Sales View
create view Monthly_Sales as

select OrderMonth, round(sum(Revenue),2) as Total_Revenue,
count(distinct invoiceno) as Total_Orders,
count(distinct Customerid) as Total_Customers
from ecommerce
group by OrderMonth;

-- Customer Summary View
Create view Customer_Summary as
select Customerid,
count(distinct invoiceno) as Total_Orders,
sum(quantity) as Total_Products_Purchased,
round(sum(Revenue),2) as Total_Spent,
max(invoicedate) as Last_Purchase_Date
from ecommerce
group by Customerid;

-- Product Performance View
create view Product_Performance as
select `Description`, sum(quantity) as Total_Quantity_Sold,
round(sum(Revenue),2) as Total_Revenue
from ecommerce
group by `Description`;

-- Country Sales View
create view Country_Sales as
select country, round(sum(Revenue),2) as Total_Revenue,
count(distinct invoiceno) as Total_Orders,
count(distinct Customerid) as Total_Customers
from ecommerce
group by country;

-- Customer Segments View
create view Customer_Segments as
select Customerid,Recency,Frequency,Monetary,Customer_Segment from customer_rfm;


select * from monthly_sales;
select * from customer_summary;
select * from product_performance;
select * from country_sales;
select * from customer_segments;
