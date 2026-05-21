# 🍽️ Danny's Diner — SQL Case Study

## 📌 Problem Statement
Danny wants to use data to understand his customers — 
visiting patterns, spending habits, and favourite menu items.

## 🎯 Business Questions Answered
1. What is the total amount each customer spent?
2. How many days has each customer visited?
3. What was the first item purchased by each customer?
4. What is the most purchased item on the menu?
5. Which item was most popular for each customer?
6. Which item was purchased first after becoming a member?
7. What is the total points each customer would have?

## 🛠️ Tools
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

## 📁 Files
| File | Description |
|------|-------------|
| `dannys_diner_schema.sql` | Database schema and sample data |
| `dannys_diner_queries.sql` | All solution queries with comments |

## 🔑 Key Concepts Used
- CTEs
- Window Functions (RANK, DENSE_RANK)
- JOINS
- CASE statements
- Aggregate Functions

## 📊 Schema
```
sales → customer_id, order_date, product_id
menu → product_id, product_name, price
members → customer_id, join_date
```
