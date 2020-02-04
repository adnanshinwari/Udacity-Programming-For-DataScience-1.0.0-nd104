/* First SubQuery */
SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1;

SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1) sub;

/* QUIZ */
/* 1. Use the test environment below to find the number of events that occur for each day for each channel. */
SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2;

/* 2. Now create a subquery that simply provides all of the data from your first query. */
SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2) sub;	

/* 3. Now find the average number of events for each channel. Since you broke out by day earlier, this is giving you an average per day. */
SELECT channel, AVG(event_count) AS avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC;

/* SubQuery Part II */
SELECT MIN(occurred_at) AS min_time
FROM orders;

SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders;

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
											FROM orders)
ORDER BY occurred_at;


/* QUIZ: SubQuery Part II */
/* 1. Use DATE_TRUNC to pull month level information about the first order ever placed in the orders table. */
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

/* 2. Use the result of the previous query to find only the orders that took place in the
		same month and year as the first order, and then pull the average for each type of paper qty in this month. */
SELECT AVG(standard_qty) AS avg_std_qty, AVG(poster_qty) AS avg_poster_qty, AVG(gloss_qty) AS AVG_gloss_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
											FROM orders);

/* Qiuz Section:
		Match each value to the corresponding description. 
		*. The total amount spent on all orders on the first month that any order was placed in first in the orders table (in terms of usd).
*/						
SELECT SUM(total_amt_usd) AS amount_spent
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
											FROM orders);

/* SUBQUERY Mania */
SELECT t3.id, t3.name, t3.channel, t3.ct
FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
		FROM accounts a
		JOIN web_events we
		ON a.id = we.account_id
		GROUP BY a.id, a.name, we.channel) t3
JOIN (SELECT t1.id, t1.name, MAX(ct) max_chan
		FROM(SELECT a.id, a.name, we.channel, COUNT(*) ct
				FROM accounts a
				JOIN web_events we
				ON a.id = we.account_id
				GROUP BY a.id, a.name, we.channel) t1
		GROUP BY t1.id, t1.name) t2
ON t2.id = t3.id AND t2.max_chan = t3.ct
ORDER BY t3.id, t3.ct;

/*SUBQUERY Mania QUIZ*/
/* 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. */
/* Finding the total_amt_usd totals associated with each sales rep.	The region in which they were located. */
SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY srep_name, region_name
ORDER BY 3 DESC;

/* Max for Each region */
SELECT region_name, MAX(total_amt) total_amt
FROM (SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN region r
		ON r.id = s.region_id
		JOIN accounts a
		ON s.id = a.sales_rep_id
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY srep_name, region_name) T1
GROUP BY 1
ORDER BY 2 DESC;

/* Need SAME region_name and total_amt from both tables */
SELECT t1.srep_name, t1.region_name, t1.total_amt
FROM (SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN region r
		ON r.id = s.region_id
		JOIN accounts a
		ON s.id = a.sales_rep_id
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY srep_name, region_name) t1
JOIN (SELECT region_name, MAX(total_amt) total_amt
		FROM (SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM sales_reps s
				JOIN region r
				ON r.id = s.region_id
				JOIN accounts a
				ON s.id = a.sales_rep_id
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY srep_name, region_name) T2
		GROUP BY 1) T3
ON T3.region_name = T1.region_name AND T3.total_amt = T1.total_amt
ORDER BY 3 DESC;

/* 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? */
/* Extraction of "Region Name" and "Total Amount" accossiated with those regions. */
SELECT r.name AS region_name, SUM(o.total_amt_usd) total_amt
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name;

/* To Extract MAX from the above Query, We have 2 methods */
/* 1. Using MAX() */
SELECT MAX(total_amt)
FROM (SELECT r.name AS region_name, SUM(o.total_amt_usd) total_amt
		FROM region r
		JOIN sales_reps s ON r.id = s.region_id
		JOIN accounts a ON s.id = a.sales_rep_id
		JOIN orders o ON a.id = o.account_id
		GROUP BY r.name) T1;

/* 2. Using ORDER BY & LIMIT */
SELECT r.name AS region_name, SUM(o.total_amt_usd) total_amt
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY 2 DESC
LIMIT 1;

/* Need region name and max orders where total_amt_usd = the above query */
SELECT r.name, COUNT(total) total_orders
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
		SELECT MAX(total_amt)
		FROM (SELECT r.name AS region_name, SUM(o.total_amt_usd) total_amt
		FROM region r
		JOIN sales_reps s ON r.id = s.region_id
		JOIN accounts a ON s.id = a.sales_rep_id
		JOIN orders o ON a.id = o.account_id
		GROUP BY r.name) t1);

/* 3. For the name of the account that purchased the most (in total over their lifetime as a customer)
		standard_qty paper, how many accounts still had more in total purchases? */
/* Pulling account with highest std paper */
SELECT a.name account_name, SUM(o.standard_qty) AS std_qty, SUM(o.total_amt_usd) AS std_amt
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/* Pulling accounts with more sales in total */
SELECT a.name account_name
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (
		SELECT total
		FROM (SELECT a.name account_name, SUM(o.standard_qty) AS std_qty, SUM(o.total) AS total
		FROM accounts a
		JOIN orders o ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 1) T1 );

/* Pulling the COUNT of those accounts */
SELECT COUNT(*)
FROM (SELECT a.name account_name
		FROM accounts a
		JOIN orders o ON a.id = o.account_id
		GROUP BY 1
		HAVING SUM(o.total) > (
				SELECT total
				FROM (SELECT a.name account_name, SUM(o.standard_qty) AS std_qty, SUM(o.total) AS total
				FROM accounts a
				JOIN orders o ON a.id = o.account_id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) T1 )) SUB;

/* 4. For the customer that spent the most (in total over their lifetime as a customer)
		total_amt_usd, how many web_events did they have for each channel? */
/* Pulling top 3 spending customers */
SELECT a.id, a.name, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

/* made the above one a subquery and extracted number of events on each channel for the top spending customer */
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND a.id = (SELECT id
		FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
				FROM accounts a
				JOIN orders o ON a.id = o.account_id
				GROUP BY 1,2
				ORDER BY 3 DESC
				LIMIT 1) T1)
GROUP BY 1,2
ORDER BY 3 DESC;

/* 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */
/* Top 10 spending accounts */
SELECT a.id, a.name, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

/* AVG of the accounts */
SELECT AVG(total)
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total
	FROM accounts a
	JOIN orders o ON a.id = o.account_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 10) T1;

/* 6. What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders. */
/* AVG all accounts (total_amt_usd) */
SELECT AVG(o.total_amt_usd) avg_total
FROM orders o;

/* Extract accounts with > avg */
SELECT o.account_id, AVG(o.total_amt_usd) tot_avg_amt
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_total
FROM orders o);

/* Average of above query */
SELECT AVG(tot_avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) tot_avg_amt
		FROM orders o
		GROUP BY 1
		HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_total
										FROM orders o)) T1;
										
/* SubQuery using WITH */
SELECT channel, AVG(event_count) AS avg_event_count
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) AS event_count
		FROM web_events
	 	GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC;

WITH events AS (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2)

SELECT channel, AVG(event_count) AS avg_event_count
FROM events
GROUP BY 1
ORDER BY 2 DESC;

/* QUIZ: WITH */
/* 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. */
WITH table1 AS (SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM sales_reps s
				JOIN region r
				ON r.id = s.region_id
				JOIN accounts a
				ON s.id = a.sales_rep_id
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY srep_name, region_name),
	table2 AS (SELECT s.name AS srep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM sales_reps s
				JOIN region r
				ON r.id = s.region_id
				JOIN accounts a
				ON s.id = a.sales_rep_id
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY srep_name, region_name),
	table3 AS (SELECT region_name, MAX(total_amt) total_amt
				FROM  table2
				GROUP BY 1)

SELECT table1.srep_name, table1.region_name, table1.total_amt
FROM  table1
JOIN  table3
ON table3.region_name = table1.region_name AND table3.total_amt = table1.total_amt
ORDER BY 3 DESC;

/* 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? */
WITH table1 AS (SELECT r.name AS region_name, SUM(o.total_amt_usd) total_amt
					FROM region r
					JOIN sales_reps s ON r.id = s.region_id
					JOIN accounts a ON s.id = a.sales_rep_id
					JOIN orders o ON a.id = o.account_id
					GROUP BY r.name),
	table2 AS (SELECT MAX(total_amt)
				FROM table1)


SELECT r.name, COUNT(total) total_orders
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM table2);

/* 3. For the name of the account that purchased the most (in total over their lifetime as a customer)
		standard_qty paper, how many accounts still had more in total purchases? */
WITH table1 AS (SELECT a.name account_name, SUM(o.standard_qty) AS std_qty, SUM(o.total) AS total
					FROM accounts a
					JOIN orders o ON a.id = o.account_id
					GROUP BY 1
					ORDER BY 2 DESC
					LIMIT 1),
	table2 AS (SELECT a.name account_name
				FROM accounts a
				JOIN orders o ON a.id = o.account_id
				GROUP BY 1
				HAVING SUM(o.total) > (SELECT total
										FROM table1 ))
						
SELECT COUNT(*)
FROM table2;

/* 4. For the customer that spent the most (in total over their lifetime as a customer)
		total_amt_usd, how many web_events did they have for each channel? */
WITH table1 AS (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
					FROM accounts a
					JOIN orders o ON a.id = o.account_id
					GROUP BY 1,2
					ORDER BY 3 DESC
					LIMIT 1)

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND a.id = (SELECT id
														FROM table1)
GROUP BY 1,2
ORDER BY 3 DESC;

/* 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */
WITH table1 AS (SELECT a.id, a.name, SUM(o.total_amt_usd) total
					FROM accounts a
					JOIN orders o ON a.id = o.account_id
					GROUP BY 1,2
					ORDER BY 3 DESC
					LIMIT 10)
SELECT AVG(total)
FROM table1;

/* 6. What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders. */
WITH table1 AS (SELECT AVG(o.total_amt_usd) avg_all
				  FROM orders o
				  JOIN accounts a
				  ON a.id = o.account_id),
	table2 AS (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
				  FROM orders o
				  GROUP BY 1
				  HAVING AVG(o.total_amt_usd) > (SELECT * FROM table1))
			
SELECT AVG(avg_amt)
FROM table2;