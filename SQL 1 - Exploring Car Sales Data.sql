-- Vasiki K. 5/7/24 --
-- Learnings Applied: Aggregate functions, simple subquery, JOINs, aliases, group/order by, table alterations --


-- ALTER TABLE used_car_sales CHANGE pricesold price int(255) --
-- ALTER TABLE used_car_sales CHANGE yearsold year_sold int(255); -- 
-- ALTER TABLE used_car_sales CHANGE Mileage mileage int(255); --
-- ALTER TABLE used_car_sales CHANGE Make make varchar(255); -- 

-- What was the average price each model was sold at?--
SELECT make, ROUND(AVG(price),2) AS 'Average_Selling_Price' 
FROM used_car_sales
GROUP BY make
ORDER BY Average_Selling_Price DESC;

-- What were the highest and lowest selling prices for each make? -- 
-- SELECT ucs.make, ucs.year, MAX(ucs.price) AS 'high', MIN(ucs.price) AS 'low'
-- FROM used_car_sales ucs
-- 	INNER JOIN(
-- 		SELECT make, MAX(price) AS "Highest_Selling_Price", MIN(price) AS "Lowest_Selling_Price"
-- 		FROM used_car_sales
--         GROUP BY make) AS lowest_highest_prices
-- ON ucs.make = lowest_highest_prices.make 
-- AND (ucs.price=lowest_highest_prices.highest_selling_price 
-- OR ucs.price=lowest_highest_prices.lowest_selling_price)
-- GROUP BY ucs.make, ucs.year;


-- Which 5 vehicles had the highest mileage?--
SELECT make, mileage, year_sold, year
FROM used_car_sales
ORDER BY mileage DESC
LIMIT 5;

-- What was the highest mileage in each make sold in 2019?--
-- original query that threw an error because the year column here is non-aggregated (strict mode is enabled). --
SELECT make, MAX(mileage) AS 'Highest_Mileage_2019', year
FROM used_car_sales
WHERE year_sold = 2019
GROUP BY make;

-- So I have to extract the highest mileage for each make via a subquery and recombine it with the original table
-- and then filter for vehicles sold in 2019 -- 

SELECT ucs.make, ucs.mileage AS 'Mileage', ucs.year_sold
FROM used_car_sales ucs
INNER JOIN(
	-- start of subquery -- 
    SELECT make, MAX(mileage) AS 'highest_mileage'
    FROM used_car_sales
    WHERE year_sold = 2019
    GROUP BY make
    ORDER BY highest_mileage DESC) AS max_mileage_per_make
ON ucs.make = max_mileage_per_make.make AND ucs.mileage = max_mileage_per_make.highest_mileage
WHERE year_sold = 2019;

-- What were the top 10 most popular makes sold? --
SELECT make, COUNT(make) AS 'Number_Sold'
FROM used_car_sales
GROUP BY make
ORDER BY Number_Sold DESC
LIMIT 10;

-- How many vehicles were sold whose make year was between 2015 and 2020? -- 
SELECT COUNT(*) AS "Cars_Sold_2015_2020"
FROM used_car_sales
WHERE year_sold BETWEEN 2015 AND 2020
