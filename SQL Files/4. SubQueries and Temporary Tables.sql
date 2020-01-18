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