/*
Summary:
Statement:			How To Use It						Other Description
SELECT				SELECT Col1, Col2, …				Provide the columns you want
FROM				FROM Table							Provide the table where the columns exist
LIMIT				LIMIT **10 **						Limits based number of rows returned
ORDER BY			ORDER BY Col						Orders table based on the column. Used with DESC.
WHERE				WHERE Col > 5						A conditional statement to filter your results
LIKE				WHERE Col LIKE '%me%'				Only pulls rows where column has 'me' within the text
IN					WHERE Col IN ('Y', 'N')				A filter for only rows with column of 'Y' or 'N'
NOT					WHERE Col NOT IN ('Y', 'N')			NOT is frequently used with LIKE and IN
AND					WHERE **Col1 > 5 AND Col2 < 3** 	Filter rows where two or more conditions must be true
OR					WHERE Col1 > 5 OR Col2 < 3			Filter rows where at least one condition must be true
BETWEEN				WHERE Col BETWEEN 3 AND 5			Often easier syntax than using an AND
*/

/* LIMIT */
SELECT occurred_at, account_id, channel 
FROM web_events 
LIMIT 15;

/* ORDER BY */
SELECT *
FROM orders
ORDER BY occurred_at
LIMIT 100;

/* ORDER BY & DESC */
SELECT *
FROM orders
ORDER BY occurred_at DESC
LIMIT 100;

/* PRACTICE */
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

/* ORDER BY II */

SELECT account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/* QUIZ: ORDER BY II */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/*
Q3 Quiz: Compare the results:
Query 1:
All of the orders for each account_id are grouped together, &
then within each of those groupings, the orders appear from the
greatest order amount to the least.

Query 2:
Since you sorted by the total_amt_usd first, the orders appear from
greatest to least regardless of which account_id they were from.
Then they are sorted by account_id next.(The secondary sorting by
account_id is difficult to see here, since only if there were two
orders with equal total_amt_usd would there need to be any sorting
by account_id)
*/

/* WHERE */
SELECT *
FROM orders
WHERE account_id = 4251
ORDER BY occurred_at
LIMIT 1000;

/* QUIZ: WHERE */
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/* WHERE with Non-Numeric Data */
SELECT *
FROM accounts
WHERE name = 'United Technologies';

SELECT *
FROM accounts
WHERE name != 'United Technologies';

/* QUIZ: WHERE with Non-Numeric Data */
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

/* Arithematic Operators */
SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty
FROM orders;

SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty,
gloss_qty + poster_qty
FROM orders;

SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty,
gloss_qty + poster_qty AS nonstandard_qty
FROM orders;

SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

/* QUIZ: Arithematic Operators */
SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id, poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;

/* LIKE */
SELECT *
FROM web_events_full
WHERE referrer_url LIKE '%google%';

/* QUIZ: LIKE */
SELECT *
FROM accounts
WHERE name LIKE 'C%';

SELECT *
FROM accounts
WHERE name LIKE '%one%';

SELECT *
FROM accounts
WHERE name LIKE '%s';

/* IN */
SELECT *
FROM accounts
WHERE name IN ('Walmart', 'Apple');

SELECT *
FROM orders
WHERE account_id IN (1001, 1021);

/* QUIZ: IN */
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

/* NOT */
SELECT sales_rep_id, name
FROM accounts
WHERE sales_rep_id IN (321500, 321570)
ORDER BY sales_rep_id;

SELECT sales_rep_id, name
FROM accounts
WHERE sales_rep_id NOT IN (321500, 321570)
ORDER BY sales_rep_id;

/* QUIZ: NOT */
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

/* AND & BETWEEN */
SELECT *
FROM orders
WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01'
ORDER BY occurred_at DESC;

SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-04-01' AND '2016-10-01'
ORDER BY occurred_at DESC;

/* QUIZ: AND & BETWEEN */
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY occurred_at DESC;

/* OR */
SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty
FROM orders
WHERE standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0;

SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty
FROM orders
WHERE (standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0) AND occurred_at >= '2016-10-01';

/* QUIZ: OR */
SELECT id 
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND 
      ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');