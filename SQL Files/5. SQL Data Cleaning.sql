/* Cleaning with String Functions */
SELECT first_name, last_name, phone_number,
		LEFT(phone_number, 3) AS area_code,
		RIGHT(phone_number, 8) AS phone_number_only
		RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt
FROM demo.customer_data;

/* QUIZ: LEFT & RIGHT */
/* 1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using.
	A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.*/
SELECT RIGHT(website,3) AS ext, COUNT(*) AS company_count 
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* 2. There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull
		the first letter of each company name to see the distribution of company names that begin with each letter (or number). */
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) AS company_count
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* 3. Use the accounts table and a CASE statement to create two groups: one group of company names
		that start with a number and a second group of those company names that start with a letter.
		What proportion of company names start with a letter? */
/* 350 companies start with letters and only one company start with number (3) */
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('1','2','3','4','5','6','7','8','9','0') THEN 1 ELSE 0 END AS num,
		CASE WHEN LEFT(UPPER(name), 1) IN ('1','2','3','4','5','6','7','8','9','0') THEN 0 ELSE 1 END AS letter
		FROM accounts) t1;
		
/* 4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else? */
/* 80 company names start with vowels, 271 company names do not start with vowels */
SELECT SUM(vowels) AS vowels, SUM(non_vowels) AS non_vowels
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowels,
		CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS non_vowels
		FROM accounts) t1;
		
/* QUIZ: POSITION, STRPOS & SUBSTR*/
/* 1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc. */
SELECT primary_poc AS full_names, LEFT(UPPER(primary_poc), POSITION(' ' IN primary_poc) - 1) AS first_name,
		RIGHT(UPPER(primary_poc), LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts;

/* 2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns. */
SELECT name AS full_names, LEFT(UPPER(name), POSITION(' ' IN name) - 1) AS first_name,
		RIGHT(UPPER(name), LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM sales_reps;

/* QUIZ: CONCAT */
WITH t1 AS (SELECT name AS company_names, primary_poc AS full_names, LEFT(UPPER(primary_poc), POSITION(' ' IN primary_poc) - 1) AS first_name,
													RIGHT(UPPER(primary_poc), LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
					FROM accounts)
					
SELECT LOWER(first_name || '.' || last_name || '@' || company_names || '.com') AS emails
FROM t1;