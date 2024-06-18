-- create_summary.sql

-- Calculate mean price_per_unit and total_sold
CREATE TABLE movement AS
SELECT upc, AVG(price) AS mean_price, SUM(units) AS total_sold
FROM raw_movement
GROUP BY upc;

-- Drop the temporary table
DROP TABLE raw_movement;