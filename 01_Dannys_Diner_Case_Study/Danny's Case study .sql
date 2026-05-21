CREATE database dannys_diner;
use dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
select*from sales;

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
select * from menu;

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  use dannys_diner;
  
  select *from members;
  select * from menu;
  select * from sales;
  
  
/*Danny wants to use the data to answer a few simple questions about his customers, 
especially about their visiting patterns, how much money they’ve spent and also which
menu items are their favourite. Having this deeper connection with his customers will
help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the 
existing customer loyalty program - additionally he needs help to generate some basic 
datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues
- but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

sales
menu
members*/


  # 1 .What is the total amount each customer spent at the restaurant?
  select s.customer_id,sum(price) as price from sales as s 
  inner join 
  menu as m 
  on s.product_id= m.product_id
  group by s.customer_id;

  # 2.How many days has each customer visited the restaurant?
  select customer_id,count(distinct order_date) as customer_visited from sales 
  group by customer_id;
  
  
  # 3.What was the first item from the menu purchased by each customer?
  /* using row number*/
  select*from(
  select*,row_number() over(partition by customer_id order by order_date)as RN
  from menu as m join sales as s using(product_id)) as t where rn = 1;

  /*using CTE*/
  With cte as(
  select s.customer_id,m.product_name,row_number() over(partition by s.customer_id order by s.order_date) as RN
  from menu as m join sales as s using(product_id))
  select customer_id,product_name from cte where RN=1;


  # 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
  select product_name,count(*) as cnt from sales s join menu m using ( product_id) group by product_name 
  order by cnt desc limit 1;
  
  
  # 5.Which item was the most popular for each customer?
  select*from(
  select customer_id,product_name ,count(*) as cnt,
  rank() over(partition by customer_id order by count(*) desc)as rn 
  from sales s inner join menu m 
  using( product_id) group by customer_id,product_name)as t where rn=1;
  
  
  with product_sales as(
  select customer_id,product_name ,count(*)as cnt 
  from sales as s inner join menu as m using (product_id)
  group by customer_id,product_name),
  rnk_CTE as(
  select*,rank() over(partition by customer_id order by cnt desc) as rn
  from product_sales)
  select *from rnk_CTE where rn=1;
  
  
  # 6.Which item was purchased first by the customer after they became a member?
 select customer_id, product_name from(
 select  s.customer_id,m.product_name,
 row_number() over (partition by s.customer_id 
 order by s.order_date) as rn
 from sales as s join menu as m on s.product_id = m.product_id
 join members mb on s.customer_id = mb.customer_id
 where s.order_date > mb.join_date) t
 where  rn = 1;

  select*from members;
  
  
  # 7.Which item was purchased just before the customer became a member?
  select customer_id,product_name from(
  select s.customer_id,m.product_name,
  dense_rank() over (partition by s.customer_id 
  order by s.order_date desc) as rn
  from sales as s join menu as m on s.product_id = m.product_id
  join members mb on s.customer_id = mb.customer_id
  where s.order_date < mb.join_date )t 
  where rn=1;
  
  select*from sales;
  select*from menu;
  select*from members;
  
  
  # 8.What is the total items and amount spent for each member before they became a member?
  select s.customer_id ,count(*)as total_items,
  sum(m.price) as total_spent from sales as s
  join menu as m on s.product_id = m.product_id
  join members as mb
  on s.customer_id = mb.customer_id
  where s.order_date <mb.join_date
  group by s.customer_id;
  
  
  # 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
  select customer_id,sum(case when product_name = 'sushi'then price *20 else price*10 end) as points
  from sales as s join menu as m on s.product_id =m.product_id
  group by customer_id;
  

  # 10.In the first week after a customer joins the program (including their join date)they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  select customer_id,sum( case when order_date between join_date 
  and date_add(join_date,Interval 7 day) 
  then price*20 when product_name ='sushi' then price *20 
  else price*10 end) as Total_points 
  from sales as s join menu as m using(product_id) join members as mb using (customer_id)
  where month(order_date) = 1
  group by customer_id;
  