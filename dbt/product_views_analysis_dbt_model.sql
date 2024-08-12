-- models/product_views_analysis_dbt_model.sql

{{ config(materialized='table') }}

WITH product_views AS (
	SELECT date_id, category_id,product_id, count(*) AS total_views
	FROM clickstream
	GROUP BY date_id, category_id,product_id
	ORDER BY date_id, category_id,product_id DESC
)
SELECT p.date_id, c.category, p.product_id, p.total_views
FROM product_views p
LEFT JOIN category_dim c
ON p.category_id = c.category_id

