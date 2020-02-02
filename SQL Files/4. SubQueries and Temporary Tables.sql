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
SELECT T2.sale_person_name, T2.region_name, T1.total_amount
FROM (SELECT a.sales_rep_id, a.id, SUM(o.total_amt_usd) AS total_amount
		FROM accounts a
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY a.sales_rep_id, a.id) T1
JOIN (SELECT s.id, s.name AS sale_person_name, r.name AS region_name
		FROM sales_reps s
		JOIN region r
		ON r.id = s.region_id) T2
ON T2.id = T1.sales_rep_id
ORDER BY 3 DESC
LIMIT 5;