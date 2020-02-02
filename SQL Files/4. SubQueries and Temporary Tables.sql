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

/* 3. For the name of the account that purchased the most (in total over their lifetime as a customer)
		standard_qty paper, how many accounts still had more in total purchases? */

/* 4. For the customer that spent the most (in total over their lifetime as a customer)
		total_amt_usd, how many web_events did they have for each channel? */

/* 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */

/* What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders. */