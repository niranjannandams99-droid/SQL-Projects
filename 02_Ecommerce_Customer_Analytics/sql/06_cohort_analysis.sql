
-- COHORT RETENTION ANALYSIS : 
-- a group of customers who made their first purchase in the same month.

use ecommerce_db;


drop table if exists customer_first_purchase;

drop table if exists cohort_data;


-- Creating Customer First Purchase Table
create table customer_first_purchase as
select customerid,min(invoicedate) as First_purchase_date from ecommerce
group by customerid;


-- Create Cohort Data Table

create table cohort_data as
select e.customerid,date_format(c.First_purchase_date, '%Y-%m') as Cohort_Month,
date_format(e.invoicedate, '%Y-%m') as Order_Month
from ecommerce e
join customer_first_purchase c 
on e.customerid = c.customerid;

-- Add Cohort Index Column
alter table cohort_data add column Cohort_Index int;

-- Calculate Cohort Index
update cohort_data set Cohort_Index = 
period_diff(replace(Order_Month,'-',''),
replace(Cohort_Month,'-',''));

select * from cohort_data;

-- Cohort Customer Retention Counts
select cohort_month,Cohort_index,count(distinct customerid) as retained_customers
from cohort_data
group by cohort_month, Cohort_index
order by cohort_month, Cohort_index;

-- Cohort Retention Percentage
with cohort_size as 
(select cohort_month,count(distinct customerid) as Total_customers from cohort_data
where Cohort_index = 0
group by cohort_month
)
select c.cohort_month,c.Cohort_index,count(distinct c.customerid) as retained_customers,
round(count(distinct c.customerid)*100.0/cs.Total_customers,2) as retention_rate
from cohort_data c
join cohort_size cs 
on c.cohort_month = cs.cohort_month
group by c.cohort_month, c.Cohort_index,cs.total_customers
order by c.cohort_month, c.Cohort_index;    
