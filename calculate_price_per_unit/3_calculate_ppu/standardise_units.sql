-- Create the output table
CREATE TABLE output AS
SELECT movement.upc AS upc,
       mean_price,
       total_sold,
       size1_amount,
       size1_units,
       mean_price / size1_amount AS price_per_unit
FROM movement
LEFT JOIN size ON movement.upc = size.upc;

-- Step 1: Create the standardised_output table with the same structure as output
CREATE TABLE standardised_output AS
SELECT upc,
       mean_price,
       total_sold,
       size1_amount,
       size1_units,
       price_per_unit
FROM output
WHERE 1=0;

-- Step 2: Insert and convert units into standardised_output
INSERT INTO standardised_output (upc, mean_price, total_sold, size1_amount, size1_units, price_per_unit)
SELECT upc,
       mean_price,
       total_sold,
       CASE size1_units
           WHEN 'PO' THEN size1_amount * 453.592
           WHEN 'OZ' THEN size1_amount * 28.3495
           WHEN 'KG' THEN size1_amount * 1000
           WHEN 'CF' THEN size1_amount * 28316.8
           WHEN 'LI' THEN size1_amount * 1000
           WHEN 'QT' THEN size1_amount * 946.353
           WHEN 'YD' THEN size1_amount * 3
           ELSE size1_amount
       END AS size1_amount,
       CASE size1_units
           WHEN 'PO' THEN 'GRAM'
           WHEN 'OZ' THEN 'GRAM'
           WHEN 'KG' THEN 'GRAM'
           WHEN 'CF' THEN 'ML'
           WHEN 'LI' THEN 'ML'
           WHEN 'QT' THEN 'ML'
           WHEN 'YD' THEN 'FT'
           ELSE size1_units
       END AS size1_units,
       CASE size1_units
           WHEN 'PO' THEN mean_price / (size1_amount * 453.592)
           WHEN 'OZ' THEN mean_price / (size1_amount * 28.3495)
           WHEN 'KG' THEN mean_price / (size1_amount * 1000)
           WHEN 'CF' THEN mean_price / (size1_amount * 28316.8)
           WHEN 'LI' THEN mean_price / (size1_amount * 1000)
           WHEN 'QT' THEN mean_price / (size1_amount * 946.353)
           WHEN 'YD' THEN mean_price / (size1_amount * 3)
           ELSE price_per_unit
       END AS price_per_unit
FROM output;

-- Step 3: Calculate the mean and standard deviation for each group
CREATE TEMPORARY TABLE mean_std AS
SELECT size1_units,
       AVG(price_per_unit) AS mean_value
FROM standardised_output
GROUP BY size1_units;

-- Calculate the standard deviation separately
UPDATE mean_std
SET std_dev = (SELECT SQRT(SUM((price_per_unit - mean_value) * (price_per_unit - mean_value)) / COUNT(price_per_unit))
               FROM standardised_output
               WHERE size1_units = mean_std.size1_units);

-- Step 4: Update the price_per_unit in standardised_output
UPDATE standardised_output
SET price_per_unit = (price_per_unit - (SELECT mean_value FROM mean_std WHERE size1_units = standardised_output.size1_units)) /
                     (SELECT std_dev FROM mean_std WHERE size1_units = standardised_output.size1_units);

-- Step 5: Verify the standardised data
SELECT * FROM standardised_output LIMIT 10;

