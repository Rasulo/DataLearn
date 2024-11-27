drop table if exists orders_final_table;
create table orders_final_table as 
(
	SELECT *
	from
	(
		SELECT *, COALESCE(returned, 'No') as returned_2 from ORDERS
		left join (SELECT DISTINCT order_id, returned FROM returns) t1 using(order_id)
		left join people using(region)
	) t1
);
ALTER TABLE orders_final_table     
DROP COLUMN returned;

ALTER TABLE orders_final_table     
RENAME COLUMN returned_2 to returned;


--Key Metrics
SELECT 
	DATE_PART('year', order_date) as year, --Filter by date
	ROUND(SUM(sales), 2) as total_sales, --Total Sales
	ROUND(SUM(profit), 2) as total_profit, --Total Profit
	CONCAT(ROUND(SUM(profit) / SUM(sales) * 100, 2), '%') as profit_ratio, --Profit Ratio
	ROUND(SUM(profit) / COUNT(DISTINCT order_id), 2) as profit_per_order, --Profit per Order
	ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) as sales_per_customer, --Sales per Customer
	ROUND(AVG(discount), 2) as avg_discount --Average Discount
FROM orders_final_table
GROUP BY year
ORDER BY year;

--Product Metrics
SELECT 
	segment,
	ROUND(SUM(sales), 2) as sales_by_segment --Sales by segment
FROM orders_final_table
GROUP BY segment
ORDER BY sales_by_segment DESC

SELECT 
	category,
	ROUND(SUM(sales), 2) as sales_by_category --Sales by category
FROM orders_final_table
GROUP BY category
ORDER BY sales_by_category DESC

SELECT 
	region,
	ROUND(SUM(sales), 2) as sales_by_region --Sales by region
FROM orders_final_table
GROUP BY region
ORDER BY sales_by_region DESC

--Customer Metrics
SELECT 
	customer_id,
	customer_name,
	ROUND(SUM(sales), 2) as sales_by_customer, --Sales and Profit by Customer with ranking by profit
	ROUND(SUM(profit), 2) as profit_by_customer
FROM orders_final_table
GROUP BY customer_id, customer_name
ORDER BY profit_by_customer DESC


