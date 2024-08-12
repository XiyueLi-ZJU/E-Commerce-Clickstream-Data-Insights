-- What's the most popular (frequently reviewed) product categoey?
SELECT category_id, COUNT(*) as category_count
FROM clickstream
GROUP BY category_id
ORDER BY category_count DESC
LIMIT 10;

-- What 's the most popular product categoey in each country?
WITH CatCounts AS (
	SELECT country_id, category_id, COUNT(*) as category_count
	FROM clickstream
	GROUP BY country_id, category_id
),
RankedCat AS (
	SELECT country_id, category_id, category_count,
	RANK() OVER (PARTITION BY country_id ORDER BY category_count DESC) as rank
	FROM CatCounts
)

SELECT con.country,cat.category,r.category_count
FROM RankedCat r
JOIN category_dim cat ON r.category_id = cat.category_id
JOIN country_dim con on r.country_id = con.country_id
WHERE r.rank = 1
ORDER BY con.country;

-- What's the most popular product?
SELECT product_id, COUNT(*) as product_count
FROM clickstream
GROUP BY product_id
ORDER BY product_count DESC
LIMIT 10;

-- What's the most popular product in each country?
WITH ProductCounts AS (
    SELECT country_id, product_id, COUNT(*) as product_count
    FROM clickstream
    GROUP BY country_id, product_id
),
RankedProducts AS (
    SELECT country_id, product_id, product_count,
    RANK() OVER (PARTITION BY country_id ORDER BY product_count DESC) as rank
    FROM ProductCounts
)
SELECT con.country,r.product_id, r.product_count
FROM RankedProducts r
LEFT JOIN country_dim con ON r.country_id = con.country_id
WHERE r.rank = 1;

-- For each product category, which product is most popular? 

WITH product_cat_counts AS (
	SELECT category_id, product_id, count(*) as product_count
	FROM clickstream
	GROUP BY category_id, product_id
),
product_cat_counts_rank AS (
	SELECT category_id, product_id,product_count,
	RANK() OVER (PARTITION BY category_id ORDER BY product_count DESC) as rank
	FROM product_cat_counts
)

SELECT cat.category,r.product_id, r.product_count
FROM product_cat_counts_rank r
LEFT JOIN category_dim cat ON r.category_id=cat.category_id
WHERE r.rank=1;

-- How does the color preference vary by product category?

WITH cat_color_counts AS (
	SELECT category_id, color_id, count(*) as total_counts
	FROM clickstream
	GROUP BY category_id, color_id
	ORDER BY category_id, total_counts DESC
),
cat_color_counts_rank AS (
	SELECT category_id, color_id, total_counts, Rank() OVER (PARTITION BY category_id ORDER BY total_counts DESC) as rank
	FROM cat_color_counts
)

SELECT cat.category, col.color,r.total_counts
FROM cat_color_counts_rank r
LEFT JOIN category_dim cat ON r.category_id = cat.category_id 
LEFT JOIN color_dim col ON r.color_id = col.color_id
WHERE r.rank=1;
