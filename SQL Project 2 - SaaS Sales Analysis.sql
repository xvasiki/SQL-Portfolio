
---Which sales rep has the highest total sales?---
SELECT Contact_name, ROUND(SUM(` Sales `),2) AS `Total Sales` FROM `sales_data.saas_sales`
GROUP BY Contact_name
ORDER BY `Total Sales` DESC
LIMIT 1;
---Diane Murray had the highest total sales at 25,043.07---

---Which sales rep has the highest average sales?---
SELECT Contact_name, ROUND(AVG(` Sales `),2) AS `Average Sales` FROM `sales_data.saas_sales`
GROUP BY Contact_name
ORDER BY `Average Sales` DESC
LIMIT 1;
---Megan Smith had the highest average sales at 1751.29---

---What are the top 5 sold products?---
SELECT Product, ROUND(SUM(` Sales `),2) AS `Total Sales`, COUNT(Product) AS `Count Sold` FROM `sales_data.saas_sales`
GROUP BY Product
ORDER BY `Total Sales` DESC
LIMIT 5;
--- ContactMatcher, FinanceHub, Site Analytics, Marketing Suite - Gold, and Big OI Database are the top 5 selling products.---

---Which sales reps have the lowest profit in each segment (SMB, Strategic, Enterprise)?---
WITH RankedProfits AS(
 SELECT Contact_name, Segment, ROUND(SUM(` Profit `),2) AS `Total Profit`,
 ROW_NUMBER() OVER(PARTITION BY Segment ORDER BY ROUND(SUM(` Profit `),2)) AS rank
 FROM `sales_data.saas_sales`
 GROUP BY Contact_name, Segment
)
SELECT Contact_name, Segment,`Total Profit`
FROM RankedProfits
WHERE rank = 1
ORDER BY `Total Profit` ASC;
---Faith C., Emily F., and Joshua V. had the lowest profits in their respective segments.---

---What are the top selling products in the United States, Germany, and Japan?---
WITH RankedSales AS(
 SELECT Country, Product, ROUND(SUM(` Sales `),2 ) AS `Total Sales`,
 ROW_NUMBER() OVER(PARTITION BY Country ORDER BY ROUND(SUM(` Sales `),2 ) DESC ) AS rank
 FROM `sales_data.saas_sales`
 WHERE Country IN ('United States','Germany','Japan')
 GROUP BY Country, Product
)
SELECT Country, Product, `Total Sales`
FROM RankedSales
WHERE rank = 1
ORDER BY Country, `Total Sales` DESC;
---The top selling products in the US, GR, and JP are: US<>ContactMatcher, GR<>Big OI Database, and JP<>Site Analytics. ---

---Display the top 3 sales reps for each segment based on total sales. Also include the total quantity sold and total profits for each rep. ---
WITH RankedSales AS(
SELECT Contact_name, Segment,
ROUND(SUM(` Sales `),2) AS `Total Sales`,
SUM(Quantity) AS `Total Count`,
SUM(` Profit `) AS `Total Profits`,
ROW_NUMBER() OVER(PARTITION BY Segment ORDER BY ROUND(SUM(` Sales `),2) DESC) AS rank
FROM `sales_data.saas_sales`
GROUP BY Contact_name, Segment
)
SELECT Contact_name, Segment,`Total Sales`, `Total Count`, `Total Profits`
FROM RankedSales
WHERE rank = 1
ORDER BY `Total Sales` DESC;
---Diane M., Nicholas S., and Cameron M. were the highest selling sales reps in each segment---
