-- RFM CUSTOMER SEGMENTATION ANALYSIS


-- Recency	    How recently customer purchased   (Detect active users)
-- Frequency	  How often customer purchases      (Detect loyal users)
-- Monetary   	How much customer spends          (Detect high-value users)

use ecommerce_db;

-- Creating RFM Base Table
create table customer_rfm as 
select customerid,
datediff((select max(invoicedate) from ecommerce), max(invoicedate)) as Recency,
count(distinct invoiceno) as Frequency,
round(sum(revenue),2) as Monetary
from ecommerce 
group by customerid;


-- Add Recency Score
alter table customer_rfm add Recency_Score int;

update customer_rfm set Recency_Score = CASE 
when Recency <= 30 then 5
when Recency <= 60 then 4
when Recency <= 90 then 3
when Recency <= 180 then 2
else 1 end;

-- Add Frequency Score
alter table customer_rfm add Frequency_Score int;
update customer_rfm set Frequency_Score = CASE 
when Frequency >= 50 then 5
when Frequency >= 20 then 4
when Frequency >= 10 then 3
when Frequency >= 5 then 2
else 1 end;

-- Add Monetary Score
alter table customer_rfm add Monetary_Score int;
update customer_rfm set Monetary_Score = CASE 
when Monetary >= 10000 then 5
when Monetary >= 5000 then 4
when Monetary >= 1000 then 3
when Monetary >= 500 then 2
else 1 end;

-- Add Customer Segment Column
alter table customer_rfm add Customer_Segment varchar(50);
-- Customer Segmentation Logic
update customer_rfm set Customer_Segment = CASE 
when Recency_Score >=4
and Frequency_Score >=4
and Monetary_Score >=4 
then 'Champions'

when Frequency_Score >=4
then 'Loyal Customers'

when Monetary_Score >=4
then 'Big Spenders'

when Recency_Score <=2
and Frequency_Score <=2
then 'At Risk'

else 'Regular Customers' end;

select * from customer_rfm;

-- Customer Segment Distribution
select customer_segment,count(*) as total_customers from customer_rfm
group by customer_segment
order by total_customers desc;

-- Revenue Contribution by Segment
select customer_segment,round(sum(monetary),2) as segment_revenue from customer_rfm
group by customer_segment
order by segment_revenue desc;

-- Top Champion Customers
select customerid,monetary,frequency,recency from customer_rfm
where customer_segment = 'Champions'
order by monetary desc
limit 10;

-- High Value At-Risk Customers
select customerid,monetary,frequency,recency from customer_rfm
where customer_segment = 'At Risk'
order by monetary desc;
