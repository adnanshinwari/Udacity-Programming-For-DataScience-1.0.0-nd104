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