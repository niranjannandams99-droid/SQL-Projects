-- Executive Business KPI Analysis

use ecommerce_db;

-- Total Revenue (company performance)
select round(sum(Revenue)) as Total_Revenue from ecommerce;

-- Total Orders (sales volume)
select count(distinct invoiceno)as Total_orders from ecommerce;

-- Total Customers (customer base size)
select count(distinct Customerid) as Total_Customers from ecommerce;

-- Average Revenue Per Customer
select round(sum(Revenue)/count(distinct Customerid),2) as Avg_Revenue_per_Customer from ecommerce;

-- Average Order Value (customer spending behavior)
select Round(sum(revenue)/count(distinct invoiceno),2) as Average_order_value from ecommerce;

-- Total Products Sold
select sum(quantity) as Total_Products_Sold from ecommerce;

-- Unique Products Count
select count(distinct Description) as Unique_Products from ecommerce;

-- Top Revenue Generating Country
select country,round(sum(revenue),2) as country_revenue from ecommerce
group by country 
order by country_revenue desc limit 1;

-- Most Valuable Customer
select Customerid,round(sum(revenue),2) as Total_Spent from ecommerce
group by customerid
order by Total_Spent desc
limit 1;

-- Highest Revenue Month
select Ordermonth,Round(sum(revenue),2) as Monthly_Revenue from ecommerce
group by Ordermonth
order by Monthly_Revenue desc limit 1;

-- Monthly Active Customers
select Ordermonth,count(distinct Customerid) as Monthly_Active_Customers from ecommerce
group by Ordermonth
order by Ordermonth;

-- Repeat Customers
select Customerid, count(distinct invoiceno) as Order_Count from ecommerce
group by Customerid 
having Order_Count > 1
order by Order_Count desc;

-- Repeat Customer Percentage 
select round((select count(*) from (select customerid from ecommerce 
group by customerid 
having count(distinct invoiceno) > 1) as repeat_customers)*100.0/count(distinct customerid),2) as Repeat_Customer_Percentage 
from ecommerce;
