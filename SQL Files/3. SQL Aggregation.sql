/*DATA TYPES AND NULL */
SELECT *
FROM accounts
WHERE id >1500 AND id < 1600;

SELECT *
FROM accounts
WHERE primary_poc IS NULL;

SELECT *
FROM accounts
WHERE primary_poc IS NOT NULL;

/* COUNT */
SELECT COUNT(*) as order_count
FROM orders
WHERE occurred_at >= '2016-12-01' AND occurred_at < '2017-01-01';

SELECT COUNT(*) as web_event_count
FROM web_events;

SELECT COUNT(*) as accounts_count
FROM accounts;

SELECT COUNT(*) as orders_count
FROM orders;

SELECT COUNT(*) as sales_reps_count
FROM sales_reps;

SELECT COUNT(*) as region_count
FROM region;

SELECT COUNT(accounts.id) AS account_id_count
FROM accounts;

SELECT *
FROM accounts
WHERE primary_poc IS NULL;

/* SUM */
SELECT SUM(standard_qty) AS standard, SUM(gloss_qty) AS gloss, SUM(poster_qty) AS poster
FROM orders;

/* QUIZ: SUM */
SELECT SUM(poster_qty) AS poster
FROM orders;

SELECT SUM(standard_qty) as standard
FROM orders;

SELECT SUM(standard_amt_usd) AS total_amount
FROM orders;

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_unit_price
FROM orders;

/* MIN MAX AVG */
SELECT MIN(standard_qty) as standard_min, MIN(gloss_qty) AS gloss_min, MIN(poster_qty) AS poster_min,
		MAX(standard_qty) as standard_max, MAX(gloss_qty) AS gloss_max, MAX(poster_qty) AS poster_max
FROM orders;

SELECT AVG(standard_qty) AS standard_avg, AVG(gloss_qty) AS gloss_avg, AVG(poster_qty) AS poster_avg
FROM orders;

/* QUIZ: MIN MAX AVG */
SELECT MIN(occurred_at) AS earliest_order
FROM orders;

SELECT occurred_at AS earliest_order
FROM orders
ORDER BY occurred_at
LIMIT 1;

SELECT MAX(occurred_at) AS latest_webevent
FROM web_events;

SELECT occurred_at AS latest_webevent
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_qty) AS avg_std_qty, AVG(standard_amt_usd) AS avg_std_usd,
		AVG(gloss_qty) AS avg_gloss_qty, AVG(gloss_amt_usd) AS avg_gloss_usd,
		AVG(poster_qty) AS avg_poster_qty, AVG(poster_amt_usd) AS avg_poster_usd
FROM orders;

/*
***Median:
Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts
when ordered. This is the average of 2483.16 and 2482.55. This gives the median
of 2482.855. This obviously isn't an ideal way to compute. If we obtain new orders,
we would have to change the limit. SQL didn't even calculate the median for us.
The above used a SUBQUERY, but you could use any method to find the two necessary values,
and then you just need the average of them.
 */
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/* GROUP BY */
SELECT account_id, SUM(standard_qty) AS standard_sum, SUM(gloss_qty) AS gloss_sum, SUM(poster_qty) AS poster_sum
FROM orders
GROUP BY account_id
ORDER BY account_id;

/* QUIZ: GROUP BY */
SELECT a.name AS account_name, o.occurred_at AS date
FROM accounts a
JOIN orders o ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

SELECT a.name AS company_name, SUM(o.total_amt_usd) AS order_usd
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

SELECT a.name AS account_name, w.channel, w.occurred_at AS date
FROM accounts a
JOIN web_events w ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

SELECT channel, COUNT(occurred_at) AS channel_use_count
FROM web_events
GROUP BY channel;

SELECT a.primary_poc AS primary_contact
FROM accounts a
JOIN web_events w ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

SELECT a.name AS account_name, MIN(o.total_amt_usd) AS total_usd
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY total_usd;

SELECT r.name AS region_name, COUNT(s.id) AS sales_reps
FROM region r
JOIN sales_reps s ON r.id = s.region_id
GROUP BY region_name
ORDER BY sales_reps;

/* GROUP BY II */
SELECT account_id, channel, COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, channel;

SELECT account_id, channel, COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, events DESC;

/* QUIZ: GROUP BY II */
SELECT a.name, AVG(o.standard_qty), AVG(o.gloss_qty), AVG(o.poster_qty)
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

SELECT a.name, AVG(o.standard_amt_usd), AVG(o.gloss_amt_usd), AVG(o.poster_amt_usd)
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

SELECT s.name, w.channel, COUNT(w.occurred_at) AS occurrences
FROM web_events w
JOIN accounts a ON a.id = w.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY w.channel, s.name
ORDER BY occurrences DESC;

SELECT r.name, w.channel, COUNT(w.occurred_at) AS occurrences
FROM web_events w
JOIN accounts a ON a.id = w.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN region r ON r.id = s.region_id
GROUP BY w.channel, r.name
ORDER BY occurrences DESC;

/* DISTINCT */
SELECT account_id, channel, COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, events DESC;

SELECT DISTINCT account_id, channel
FROM web_events
ORDER BY account_id;

/* QUIZ DISTINCT*/
SELECT DISTINCT a.name AS account_name, COUNT(r.id)
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
GROUP BY a.name
ORDER BY a.name;

/*
***Provided Solution: No. of rows are same (351)
*/
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM sales_reps;

/* Q2: My solution */
SELECT DISTINCT s.name AS sales_rep_names, COUNT(a.*)
FROM accounts a
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY sales_rep_names;

/*
*** Provided Solution
*/
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

SELECT DISTINCT id, name
FROM sales_reps;

/* HAVING */
SELECT account_id, SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY 1
HAVING SUM(total_amt_usd) >= 250000;

/* QUIZ: Having */
SELECT s.id AS "SalesMan ID", s.name AS "SalesMan NAME", COUNT(a.id) AS "Accounts"
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5
ORDER BY "Accounts" DESC;

SELECT a.id AS account_id, a.name AS account_name, COUNT(o.*) AS orders
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(o.*) > 20
ORDER BY orders DESC;

SELECT a.id AS account_id, a.name AS account_name, COUNT(o.*) AS orders
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY orders DESC
LIMIT 1;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent DESC;

SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent DESC;

SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

SELECT a.id AS account_id, a.name AS account_name, w.channel, COUNT(w.channel) AS fb_channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id
WHERE w.channel IN ('facebook')
GROUP BY a.id, a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY fb_channel DESC;

SELECT a.id AS account_id, a.name AS account_name, w.channel, COUNT(w.channel) AS fb_channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id
WHERE w.channel IN ('facebook')
GROUP BY a.id, a.name, w.channel
ORDER BY fb_channel DESC
LIMIT 1;

SELECT a.id AS account_id, a.name AS account_name, w.channel AS channel, COUNT(w.*) AS fb_channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY fb_channel DESC
LIMIT 10;

/* DATE */
SELECT DATE_TRUNC('day', occurred_at) AS day, SUM(standard_qty) AS standard_qty
FROM orders
GROUP BY DATE_TRUNC('day', occurred_at)
ORDER BY DATE_TRUNC('day', occurred_at);

SELECT DATE_PART('dow', occurred_at) AS day_of_week, SUM(total) AS total_qty
FROM orders 
GROUP BY 1
ORDER BY 2 DESC;

/* QUIZ: DATE */
