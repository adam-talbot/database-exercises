USE fruits_db;

SHOW tables;

DESCRIBE fruits;

SHOW COLUMNS
FROM fruits;

SELECT *
FROM fruits;

SELECT
	name,
	quantity
FROM fruits;

USE chipotle;

SHOW TABLES;

DESCRIBE orders;

SELECT *
FROM orders;

SELECT 
	item_name,
	quantity
FROM orders;

SELECT DISTINCT 
	item_name
FROM orders;

SELECT 
	*
FROM orders
WHERE item_name = 'Chicken Bowl';

SELECT 
	item_name,
	order_id
FROM orders
WHERE item_name = 'Chicken Bowl';

SELECT 
	*
FROM orders
WHERE item_price = '$2.39';

SELECT 
	*
FROM orders
WHERE id = 10;

SELECT 
	*
FROM orders
WHERE quantity BETWEEN 3 and 5;
-- range is inclusive

SELECT *
FROM orders
WHERE order_id > 1500;

SELECT *
FROM orders
WHERE order_id <> 1;

-- adding an alias
SELECT
	item_name AS 'Multiple Item Order',
	quantity AS Number
FROM orders
WHERE quantity >= 2;

-- doesn't matter how you indent or break up lines, just make it as readable as possible
-- rule of thumb - if your querie can fit on one line, thats fine, it it exceeds one line, break it up in a way that makes sense


