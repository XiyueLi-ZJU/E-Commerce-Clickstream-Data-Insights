-- Monthly session trends (Number of website visits per month)
SELECT month,COUNT(DISTINCT(session_id))
FROM clickstream
GROUP BY month
ORDER BY month;

-- Daily session trends (Number of website visits per day)
SELECT date_id,COUNT(DISTINCT(session_id))
FROM clickstream
GROUP BY date_id
ORDER BY date_id;

-- Are there specific days of the week when session activity peaks?

SELECT day_of_week,COUNT(day_of_week) AS day_of_week_count FROM calendar
RIGHT JOIN clickstream
ON clickstream.date_id=calendar.date_id
GROUP BY day_of_week
ORDER BY day_of_week_count DESC;

-- How do product preferences change from April to August?
SELECT month, product_id, count(*) AS total_count
FROM clickstream
WHERE month between 4 AND 8
GROUP BY month, product_id
ORDER BY month, product_id DESC;

-- How do product preferences change from April to August?
SELECT product_id, 
	SUM (CASE WHEN month = 4 THEN 1 ELSE 0 END) AS "April_views",
	SUM (CASE WHEN month = 5 THEN 1 ELSE 0 END) AS "May_views",
	SUM (CASE WHEN month = 6 THEN 1 ELSE 0 END) AS "June_views",
	SUM (CASE WHEN month = 7 THEN 1 ELSE 0 END) AS "July_views",
	SUM (CASE WHEN month = 8 THEN 1 ELSE 0 END) AS "August_views"
FROM clickstream
GROUP BY product_id
ORDER BY product_id;

-- How do product preferences change daily?
WITH product_views AS (
	SELECT date_id, category_id,product_id, count(*) AS total_views
	FROM clickstream
	GROUP BY date_id, category_id,product_id
	ORDER BY date_id, category_id,product_id DESC
)
SELECT p.date_id, c.category, p.product_id, p.total_views
FROM product_views p
LEFT JOIN category_dim c
ON p.category_id = c.category_id;