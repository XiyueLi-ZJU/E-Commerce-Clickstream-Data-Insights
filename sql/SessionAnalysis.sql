-- On average, how many pages do users visit in a session?

SELECT AVG(page_count) AS avg_page_count 
FROM(
	SELECT session_id, COUNT(page_num) AS page_count
	FROM clickstream
	GROUP BY session_id
); 

-- On average, how many products do users visit in a session?

SELECT AVG(product_count) as avg_product_count
FROM (
SELECT session_id, COUNT(DISTINCT(product_id)) as product_count
FROM clickstream
GROUP BY session_id
ORDER BY session_id
);

-- What percentage of sessions are single-page sessions?

SELECT 
    (COUNT(single_page_sessions.session_id) * 100.0 / COUNT(all_sessions.session_id)) AS percentage_single_page_sessions
FROM
    (SELECT session_id FROM clickstream GROUP BY session_id HAVING COUNT(page_num) = 1) AS single_page_sessions,
    (SELECT session_id FROM clickstream GROUP BY session_id) AS all_sessions;

-- Which products are frequently reviewed together? (Find products that are frequently reviewed in the same session.)
SELECT a.product_id AS product1, b.product_id AS product_2, count(*) as frequency
FROM (SELECT session_id, product_id FROM clickstream) a
JOIN (SELECT session_id, product_id FROM clickstream) b
ON a.session_id = b.session_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY frequency DESC
LIMIT 10;

-- Impact of product price on session count
SELECT product_id,price, count(*) as counts
FROM clickstream
GROUP BY product_id,price
ORDER BY counts DESC;

-- Impact of model photography on session count
SELECT model_photography_id, count(*) as counts
FROM clickstream
GROUP BY model_photography_id
ORDER BY counts DESC;