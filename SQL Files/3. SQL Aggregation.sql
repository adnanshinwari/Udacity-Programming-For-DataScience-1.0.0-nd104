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
/* 1. Find the total amount of poster_qty paper ordered in the orders table. */
SELECT SUM(poster_qty) AS poster
FROM orders;

/* 2. Find the total amount of standard_qty paper ordered in the orders table. */
SELECT SUM(standard_qty) as standard
FROM orders;

/* 3. Find the total dollar amount of sales using the total_amt_usd in the orders table. */
SELECT SUM(standard_amt_usd) AS total_amount
FROM orders;

/* 4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
		This should give a dollar amount for each order in the table. */
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

/* 5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator. */
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_unit_price
FROM orders;

/* MIN MAX AVG */
SELECT MIN(standard_qty) as standard_min, MIN(gloss_qty) AS gloss_min, MIN(poster_qty) AS poster_min,
		MAX(standard_qty) as standard_max, MAX(gloss_qty) AS gloss_max, MAX(poster_qty) AS poster_max
FROM orders;

SELECT AVG(standard_qty) AS standard_avg, AVG(gloss_qty) AS gloss_avg, AVG(poster_qty) AS poster_avg
FROM orders;

/* QUIZ: MIN MAX AVG */
/* 1. When was the earliest order ever placed? You only need to return the date. */
SELECT MIN(occurred_at) AS earliest_order
FROM orders;

/* 2. Try performing the same query as in question 1 without using an aggregation function. */
SELECT occurred_at AS earliest_order
FROM orders
ORDER BY occurred_at
LIMIT 1;

/* 3. When did the most recent (latest) web_event occur? */
SELECT MAX(occurred_at) AS latest_webevent
FROM web_events;

/* 4. Try to perform the result of the previous query without using an aggregation function. */
SELECT occurred_at AS latest_webevent
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

/* 5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean
		amount of each paper type purchased per order. Your final answer should have 6 values
		- one for each paper type for the average number of sales, as well as the average amount. */
SELECT AVG(standard_qty) AS avg_std_qty, AVG(standard_amt_usd) AS avg_std_usd,
		AVG(gloss_qty) AS avg_gloss_qty, AVG(gloss_amt_usd) AS avg_gloss_usd,
		AVG(poster_qty) AS avg_poster_qty, AVG(poster_amt_usd) AS avg_poster_usd
FROM orders;

/* 6. Via the video, you might be interested in how to calculate the MEDIAN.
		Though this is more advanced than what we have covered so far try finding
		- what is the MEDIAN total_usd spent on all orders?
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
/* 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order. */
SELECT a.name AS account_name, o.occurred_at AS date
FROM accounts a
JOIN orders o ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/* 2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders
		in usd and the company name. */
SELECT a.name AS company_name, SUM(o.total_amt_usd) AS order_usd
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

/* 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
		Your query should return only three values - the date, channel, and account name. */
SELECT a.name AS account_name, w.channel, w.occurred_at AS date
FROM accounts a
JOIN web_events w ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

/* 4. Find the total number of times each type of channel from the web_events was used.
		Your final table should have two columns - the channel and the number of times the channel was used. */
SELECT channel, COUNT(occurred_at) AS channel_use_count
FROM web_events
GROUP BY channel;

/* 5. Who was the primary contact associated with the earliest web_event? */
SELECT a.primary_poc AS primary_contact
FROM accounts a
JOIN web_events w ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

/* 6. What was the smallest order placed by each account in terms of total usd.
		Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest. */
SELECT a.name AS account_name, MIN(o.total_amt_usd) AS total_usd
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY total_usd;

/* 7. Find the number of sales reps in each region.
		Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps. */
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
/* 1. For each account, determine the average amount of each type of paper they purchased across their orders.
		Your result should have four columns - one for the account name and one for the average quantity
		purchased for each of the paper types for each account. */
SELECT a.name, AVG(o.standard_qty), AVG(o.gloss_qty), AVG(o.poster_qty)
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

/* 2. For each account, determine the average amount spent per order on each paper type.
		Your result should have four columns - one for the account name and one for the average amount spent on each paper type. */
SELECT a.name, AVG(o.standard_amt_usd), AVG(o.gloss_amt_usd), AVG(o.poster_amt_usd)
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name;

/* 3. Determine the number of times a particular channel was used in the web_events table for each sales rep.
		Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
		Order your table with the highest number of occurrences first. */
SELECT s.name, w.channel, COUNT(w.occurred_at) AS occurrences
FROM web_events w
JOIN accounts a ON a.id = w.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY w.channel, s.name
ORDER BY occurrences DESC;

/* 4. Determine the number of times a particular channel was used in the web_events table for each region.
		Your final table should have three columns - the region name, the channel, and the number of occurrences.
		Order your table with the highest number of occurrences first. */
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
/* 1. Use DISTINCT to test if there are any accounts associated with more than one region. */
SELECT DISTINCT a.name AS account_name, COUNT(r.id)
FROM region r
JOIN sales_reps s ON r.id = s.region_id
JOIN accounts a ON s.id = a.sales_rep_id
GROUP BY a.name
ORDER BY a.name;

/* 2. Have any sales reps worked on more than one account? */
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
/* 1. How many of the sales reps have more than 5 accounts that they manage? */
SELECT s.id AS "SalesMan ID", s.name AS "SalesMan NAME", COUNT(a.id) AS "Accounts"
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5
ORDER BY "Accounts" DESC;

/* 2. How many accounts have more than 20 orders? */
SELECT a.id AS account_id, a.name AS account_name, COUNT(o.*) AS orders
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(o.*) > 20
ORDER BY orders DESC;

/* 3. Which account has the most orders? */
SELECT a.id AS account_id, a.name AS account_name, COUNT(o.*) AS orders
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY orders DESC
LIMIT 1;

/* 4. Which accounts spent more than 30,000 usd total across all orders? */
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent DESC;

/* 5. Which accounts spent less than 1,000 usd total across all orders? */
SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent DESC;

/* 6. Which account has spent the most with us? */
SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

/* 7. Which account has spent the least with us? */
SELECT a.id AS account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

/* 8. Which accounts used facebook as a channel to contact customers more than 6 times? */
SELECT a.id AS account_id, a.name AS account_name, w.channel, COUNT(w.channel) AS fb_channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id
WHERE w.channel IN ('facebook')
GROUP BY a.id, a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY fb_channel DESC;

/* 9. Which account used facebook most as a channel?  */
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

/* 10. Which channel was most frequently used by most accounts? */
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
/* 1. Find the sales in terms of total dollars for all orders in each year,
		ordered from greatest to least. Do you notice any trends in the yearly sales totals? */
SELECT DATE_PART('year', occurred_at) AS ord_year, SUM(total_amt_usd) AS total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/* 2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset? */
SELECT DATE_PART('month', occurred_at) AS month, SUM(total_amt_usd) AS total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/* 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset? */
SELECT DATE_PART('year', occurred_at) AS year, SUM(total) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/* 4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset? */
SELECT DATE_PART('month', occurred_at) AS month, SUM(total) AS total_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/* 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars? */
SELECT DATE_TRUNC('month', o.occurred_at) AS date, SUM(o.gloss_amt_usd) AS total_spent
FROM orders o
JOIN accounts a ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/* CASE */
SELECT id, account_id, occurred_at, channel,
		CASE WHEN channel = 'facebook' THEN 'yes' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

SELECT id, account_id, occurred_at, channel,
		CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

SELECT id, account_id, occurred_at, channel,
		CASE WHEN channel = 'facebook' OR channel = 'direct' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

SELECT account_id, occurred_at, total,
		CASE WHEN total > 500 THEN 'Over 500'
			WHEN total > 300 THEN '301-500'
			WHEN total > 100 THEN '101-300'
			ELSE '100 or under' END AS total_group
FROM orders;

SELECT account_id, occurred_at, total,
		CASE WHEN total > 500 THEN 'Over 500'
			WHEN total > 300 AND total <= 500 THEN '301-500'
			WHEN total > 100 AND total <= 300 THEN '101-300'
			ELSE '100 or under' END AS total_group
FROM orders;

/* CASE: Example */
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT account_id,
		CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
			ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

/* CASE II */
SELECT CASE WHEN total > 500 THEN 'Over 500'
			ELSE '500 or under' END AS total_group,
			COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/* QUIZ: CASE */
/* 1. Write a query to display for each order, the account ID,
		total amount of the order, and the level of the order - ‘Large’ or ’Small’
		- depending on if the order is $3000 or more, or smaller than $3000. */
SELECT account_id, total,
   CASE WHEN total > 3000 THEN 'Large'
   ELSE 'Small' END AS order_level
FROM orders
ORDER BY 2 DESC;

/* 2. Write a query to display the number of orders in each of three categories,
		based on the 'total' amount of each order. The three categories are:
		'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'. */
SELECT CASE WHEN total >= 2000 THEN 'At least 2000'
			WHEN total >= 1000 AND total < 2000 THEN 'BETWEEN 1000 and 2000'
			ELSE 'Less than 1000' END AS order_category,
			COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/* 3. We would like to understand 3 different levels of customers based on the amount
		associated with their purchases. The top level includes anyone with a Lifetime Value
		(total sales of all orders) greater than 200,000 usd. The second level is between
		200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd.
		Provide a table that includes the level associated with each account.
		You should provide the account name, the total sales of all orders for the customer, and the level.
		Order with the top spending customers listed first. */
SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

/* 4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent
		by customers only in 2016 and 2017.
		Keep the same levels as in the previous question.
		Order with the top spending customers listed first. */
SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

/* 5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
		Create a table with the sales rep name, the total number of orders, and a column with top or not depending on
		if they have more than 200 orders. Place the top sales people first in your final table. */
SELECT s.name, COUNT(o.*) AS order_count,
		CASE WHEN COUNT(o.*) >= 200 THEN 'top'
		ELSE 'Not' END AS top_performing
FROM sales_reps s
JOIN accounts a ON s.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

/* 6. The previous didn't account for the middle, nor the dollar amount associated with the sales.
		Management decides they want to see these characteristics represented as well.
		We would like to identify top performing sales reps, which are sales reps associated with more
		than 200 orders or more than 750000 in total sales.
		The middle group has any rep with more than 150 orders or 500000 in sales.
		Create a table with the sales rep name, the total number of orders, total sales across all orders,
		and a column with top, middle, or low depending on this criteria.
		Place the top sales people based on dollar amount of sales first in your final table.
		You might see a few upset sales people by this criteria! */
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
        CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;