/*
***RECAP:
PK & FK:
primary keys(PK) - are unique for every row in a table. These are generally the first column in our database
					(like you saw with the id column for every table in the Parch & Posey database).
foreign keys(FK) - are the primary key appearing in another table, which allows the rows to be non-unique. 

JOINS:
1. JOIN - an INNER JOIN that only pulls data that exists in both tables.
2. LEFT JOIN - pulls all the data that exists in both tables, as well as all
				of the rows from the table in the FROM even if they do not exist in the JOIN statement.
3. LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table
				in the FROM even if they do not exist in the JOIN statement.
*** do read about UNION & UNION ALL, CROSS JOIN, SELF JOIN

ALAS - AS
*/

/* SQL Joins */
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* Tasks: SQL Joins */
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* Joining multiple tables */
SELECT *
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN orders ON accounts.id = orders.account_id;

SELECT web_events.channel, accounts.name, orders.total
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN orders ON accounts.id = orders.account_id;

/* Testing joins on all tables in a single query */
SELECT *
FROM web_events
JOIN accounts ON web_events.account_id = accounts.id
JOIN orders ON accounts.id = orders.account_id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON sales_reps.region_id = region.id;

/* ALIAS */
SELECT o.*, a.*
FROM orders o
JOIN accounts a ON o.account_id = a.id;

/*
FROM tablename AS t1
JOIN tablename2 AS t2

***could be written in the following way

FROM tablename t1
JOIN tablename2 t2

***similarly

SELECT col1 + col2 AS total, col3

SELECT col1 + col2 total, col3
*/

/* 
***Aliasing for columns

SELECT t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2
*/

/* QUIZ: above material */
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.name IN ('Walmart');

SELECT r.name region, s.name, a.name account
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id;

/* OTHER JOINs */
SELECT a.id, a.name, o.total
FROM orders o
LEFT JOIN accounts a ON o.account_id = a.id;

SELECT a.id, a.name, o.total
FROM orders o
RIGHT JOIN accounts a ON o.account_id = a.id;

SELECT a.id, a.name, o.total
FROM orders o
RIGHT JOIN accounts a ON o.account_id = a.id;

SELECT a.id, a.name, o.total
FROM accounts a
LEFT JOIN orders o ON o.account_id = a.id;

/* JOIN and FILTERING */
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500;

SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts ON orders.account_id = accounts.id AND accounts.sales_rep_id = 321500;

/*QUIZ: Joins */
SELECT r.name RegionName, s.name SalesRepName, a.name AccountName
FROM region r
JOIN sales_reps s ON r.id = s.region_id AND r.name IN ('Midwest')
JOIN accounts a ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name RegionName, s.name SalesRepName, a.name AccountName
FROM region r
JOIN sales_reps s ON r.id = s.region_id AND r.name IN ('Midwest') AND s.name LIKE 'S%'
JOIN accounts a ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name RegionName, s.name SalesRepName, a.name AccountName
FROM region r
JOIN sales_reps s ON r.id = s.region_id AND r.name IN ('Midwest') AND s.name LIKE '% K%'
JOIN accounts a ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name regionName, a.name accountName, (o.total_amt_usd/(o.total + 0.01)) unitPrice
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id AND o.standard_qty > 100;

SELECT r.name regionName, a.name accountName, (o.total_amt_usd/(o.total + 0.01)) unitPrice
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id AND (o.standard_qty > 100 AND poster_qty > 50)
ORDER BY unitPrice;

SELECT r.name regionName, a.name accountName, (o.total_amt_usd/(o.total + 0.01)) unitPrice
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id AND (o.standard_qty > 100 AND poster_qty > 50)
ORDER BY unitPrice DESC;

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND a.id = 1001;

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;