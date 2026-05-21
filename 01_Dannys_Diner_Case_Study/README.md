# 🍜 Danny's Diner — SQL Case Study

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Case--Study-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

---

## 📌 Problem Statement

Danny opened a small restaurant in early 2021 selling his 3 favourite foods: **sushi, curry, and ramen**.
He wants to use customer data to understand:
- Visiting patterns
- Money spent
- Favourite menu items

These insights will help Danny decide whether to **expand his customer loyalty program**.

---

## 🗃️ Database Schema

```
┌─────────────┐       ┌──────────────┐       ┌─────────────┐
│    sales     │       │     menu     │       │   members   │
├─────────────┤       ├──────────────┤       ├─────────────┤
│ customer_id │──┐    │ product_id PK│    ┌──│ customer_id │
│ order_date  │  └───▶│ product_name │    │  │ join_date   │
│ product_id  │──────▶│ price        │    │  └─────────────┘
└─────────────┘       └──────────────┘    │
      │                                    │
      └────────────────────────────────────┘
```

---

## 🎯 Business Questions & Solutions

---

### ❓ Question 1 — Total Amount Each Customer Spent

```sql
SELECT s.customer_id, SUM(price) AS total_spent
FROM sales AS s
INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id;
```

**💡 Insight:** Customer A is the highest spender, followed by B and C.

| Customer | Total Spent |
|----------|------------|
| A | $76 |
| B | $74 |
| C | $36 |

---

### ❓ Question 2 — How Many Days Each Customer Visited

```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id;
```

**💡 Insight:** Customer B visited the most frequently — showing higher engagement.

| Customer | Days Visited |
|----------|-------------|
| A | 4 |
| B | 6 |
| C | 2 |

---

### ❓ Question 3 — First Item Purchased by Each Customer

```sql
-- Using CTE + ROW_NUMBER
WITH cte AS (
  SELECT s.customer_id, m.product_name,
    ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
  FROM menu AS m JOIN sales AS s USING(product_id)
)
SELECT customer_id, product_name FROM cte WHERE rn = 1;
```

**💡 Insight:** Sushi and curry were the first choices — premium items attract first-time customers.

| Customer | First Order |
|----------|------------|
| A | sushi |
| B | curry |
| C | ramen |

---

### ❓ Question 4 — Most Purchased Item Overall

```sql
SELECT product_name, COUNT(*) AS purchase_count
FROM sales s JOIN menu m USING(product_id)
GROUP BY product_name
ORDER BY purchase_count DESC
LIMIT 1;
```

**💡 Insight:** **Ramen** is the bestseller — Danny should consider promotions around it.

| Product | Times Ordered |
|---------|--------------|
| ramen | 8 |

---

### ❓ Question 5 — Most Popular Item Per Customer

```sql
WITH product_sales AS (
  SELECT customer_id, product_name, COUNT(*) AS cnt
  FROM sales AS s INNER JOIN menu AS m USING(product_id)
  GROUP BY customer_id, product_name
),
rnk_CTE AS (
  SELECT *, RANK() OVER(PARTITION BY customer_id ORDER BY cnt DESC) AS rn
  FROM product_sales
)
SELECT customer_id, product_name, cnt FROM rnk_CTE WHERE rn = 1;
```

**💡 Insight:** Ramen is the favourite for A and C. Customer B loves all items equally.

| Customer | Favourite Item | Count |
|----------|---------------|-------|
| A | ramen | 3 |
| B | sushi, curry, ramen | 2 each |
| C | ramen | 3 |

---

### ❓ Question 6 — First Item After Becoming a Member

```sql
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name,
    ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
  FROM sales AS s
  JOIN menu AS m ON s.product_id = m.product_id
  JOIN members mb ON s.customer_id = mb.customer_id
  WHERE s.order_date > mb.join_date
) t
WHERE rn = 1;
```

**💡 Insight:** After joining the loyalty program, members ordered ramen and sushi — premium items.

| Customer | First Post-Membership Order |
|----------|---------------------------|
| A | ramen |
| B | sushi |

---

### ❓ Question 7 — Item Purchased Just Before Becoming a Member

```sql
SELECT customer_id, product_name
FROM (
  SELECT s.customer_id, m.product_name,
    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rn
  FROM sales AS s
  JOIN menu AS m ON s.product_id = m.product_id
  JOIN members mb ON s.customer_id = mb.customer_id
  WHERE s.order_date < mb.join_date
) t
WHERE rn = 1;
```

**💡 Insight:** Customers tried sushi and curry right before joining — these may be the items that convinced them to join!

| Customer | Last Pre-Membership Order |
|----------|--------------------------|
| A | sushi, curry |
| B | sushi |

---

### ❓ Question 8 — Total Items & Amount Spent Before Membership

```sql
SELECT s.customer_id, COUNT(*) AS total_items, SUM(m.price) AS total_spent
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;
```

**💡 Insight:** Both customers were already engaged buyers before joining — the loyalty program targets the right audience.

| Customer | Items Bought | Amount Spent |
|----------|-------------|-------------|
| A | 2 | $25 |
| B | 3 | $40 |

---

### ❓ Question 9 — Loyalty Points Calculation

> $1 = 10 points | Sushi = 2x multiplier (20 points per $1)

```sql
SELECT customer_id,
  SUM(CASE 
    WHEN product_name = 'sushi' THEN price * 20 
    ELSE price * 10 
  END) AS total_points
FROM sales AS s JOIN menu AS m ON s.product_id = m.product_id
GROUP BY customer_id;
```

**💡 Insight:** Customer B leads on points — a targeted sushi promotion could boost A and C's engagement.

| Customer | Total Points |
|----------|-------------|
| A | 860 |
| B | 940 |
| C | 360 |

---

### ❓ Question 10 — Double Points in First Week of Membership (January)

> First 7 days after joining: 2x points on ALL items (not just sushi)

```sql
SELECT customer_id,
  SUM(CASE 
    WHEN order_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 7 DAY) THEN price * 20
    WHEN product_name = 'sushi' THEN price * 20
    ELSE price * 10
  END) AS total_points
FROM sales AS s
JOIN menu AS m USING(product_id)
JOIN members AS mb USING(customer_id)
WHERE MONTH(order_date) = 1
GROUP BY customer_id;
```

**💡 Insight:** The first-week double points program significantly boosts Customer A's points — a strong incentive for new members.

| Customer | January Points (with bonus) |
|----------|---------------------------|
| A | 1,370 |
| B | 820 |

---

## 🔑 SQL Concepts Used

| Concept | Used In |
|---------|---------|
| `INNER JOIN` | Q1, Q9 |
| `COUNT(DISTINCT)` | Q2 |
| `ROW_NUMBER()` | Q3, Q6 |
| `CTE (WITH clause)` | Q3, Q5 |
| `RANK() / DENSE_RANK()` | Q5, Q7 |
| `CASE WHEN` | Q9, Q10 |
| `DATE_ADD()` | Q10 |
| `Subqueries` | Q4, Q6, Q7 |

---

## 📁 Repository Structure

```
01_Dannys_Diner_Case_Study/
├── README.md               ← This file
└── dannys_diner.sql        ← Full schema + all 10 solutions
```

---

## 🙏 Credits

Case study from **[8 Week SQL Challenge](https://8weeksqlchallenge.com/)** by Danny Ma.
Solved independently by **[Niranjan Nandam](https://github.com/niranjannandams99-droid)**

---

*⭐ If you found this helpful, consider starring the repo!*
