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
SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2;

SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2) sub;	

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
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

SELECT AVG(standard_qty) AS avg_std_qty, AVG(poster_qty) AS avg_poster_qty, AVG(gloss_qty) AS AVG_gloss_qty
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
											FROM orders);
											
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