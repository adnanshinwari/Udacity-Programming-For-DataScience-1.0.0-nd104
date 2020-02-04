/* Cleaning with String Functions */
SELECT first_name, last_name, phone_number,
		LEFT(phone_number, 3) AS area_code,
		RIGHT(phone_number, 8) AS phone_number_only
		RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt
FROM demo.customer_data;