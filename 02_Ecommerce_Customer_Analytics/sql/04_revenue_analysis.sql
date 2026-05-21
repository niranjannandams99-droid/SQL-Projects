-- Revenue & Business Analysis


use ecommerce_db;

-- Total Revenue (company performance)
select round(sum(Revenue)) as Total_Revenue from ecommerce;

-- Total Orders (sales volume)
select count(distinct invoiceno) 
as Total_orders from ecommerce;

-- Total Customers (customer base size)
select count(distinct Customerid) 
as Total_Customers from ecommerce;

-- Average Order Value (customer spending behavior)
select Round(sum(revenue)/count(distinct invoiceno),2) 
as Average_order_value from ecommerce;

-- Monthly Revenue Trend (growth tracking)
select Ordermonth,Round(sum(revenue),2) as Monthly_Revenue from ecommerce
group by Ordermonth
order by Ordermonth;

-- Top 10 Customers by Revenue (VIP customer)
select Customerid,round(sum(revenue),2) as Total_Spent from ecommerce
group by customerid
order by Total_Spent desc
limit 10;

-- Top 10 Selling Products (inventory planning)
select `Description`, sum(quantity) as Total_quantity_sold,
round(sum(revenue),2) as Product_Revenue
from ecommerce
group by `Description`
order by Total_quantity_sold desc
limit 10;

-- Top Revenue Generating Countries (market analysis)
select country,round(sum(revenue),2) as country_revenue from ecommerce
group by country 
order by country_revenue desc;

-- Top 5 Highest Value Orders (sales performance)
select invoiceno,round(sum(revenue),2) as Order_value from ecommerce
group by invoiceno 
order by Order_value desc
limit 5;

-- Daily Revenue Trend (operational trends)
select date(invoicedate) as order_date,round(sum(revenue),2) as daily_revenue from ecommerce
group by order_date
order by order_date;
