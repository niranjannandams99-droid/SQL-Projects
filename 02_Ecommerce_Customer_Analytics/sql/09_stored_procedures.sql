-- Stored Procedures for Business Reporting
use ecommerce_db;

-- Procedure: Top Customers
drop procedure if exists GetTopCustomers;

create procedure GetTopCustomers()
begin
select CustomerID, round(sum(revenue), 2) as Total_Spent
from ecommerce
group by customerid
order by Total_Spent desc
limit 10;
end;

-- Procedure: Monthly Revenue
drop procedure if exists GetMonthlyRevenue;
create procedure GetMonthlyRevenue()
begin
select OrderMonth, round(sum(revenue), 2) as Monthly_Revenue
from ecommerce
group by OrderMonth
order by OrderMonth;
end;

-- Procedure: Country Revenue
drop procedure if exists GetCountryRevenue;
create procedure GetCountryRevenue()
begin
select country, round(sum(revenue), 2) as Country_Revenue
from ecommerce
group by country
order by Country_Revenue desc;
end;

-- Procedure: Customer Segment Summary
drop procedure if exists GetCustomerSegmentSummary;
create procedure GetCustomerSegmentSummary()
begin
select Customer_Segment, count(*) as Total_customers,
round(sum(Monetary), 2) as Total_Segment_Revenue
from customer_rfm
group by Customer_Segment
order by Total_Segment_Revenue desc;
end;

-- Execute Procedures
call GetTopCustomers();
call GetMonthlyRevenue();
call GetCountryRevenue();
call GetCustomerSegmentSummary();



