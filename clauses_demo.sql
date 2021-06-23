USE albums_db;

SHOW COLUMNS
FROM albums;

DESCRIBE albums;

SELECT *
FROM albums;

SELECT DISTINCT
	artist
FROM albums;

SELECT name
FROM albums
WHERE release_date = 1990;

-- LIKE and % wildcard
SELECT name
FROM albums
WHERE name LIKE '%at%';

-- look for "the"
SELECT *
FROM albums
WHERE name LIKE '%the%';

-- last letter is a
SELECT *
FROM albums
WHERE name LIKE '%a';

-- first letter is a
SELECT *
FROM albums
WHERE name LIKE 'a%';

-- _ can also be used as single letter wildcard
SELECT *
FROM albums
WHERE name LIKE '%_a%';

-- starts with b and ends with k
SELECT *
FROM albums
WHERE name LIKE 'b%a';

-- use like and %
SELECT *
FROM albums
WHERE release_date LIKE '199%';

SELECT artist, name, sales
FROM albums
WHERE sales BETWEEN 10 and 20;

USE chipotle;

SELECT *
FROM orders
WHERE item_name LIKE '%chicken%';

SELECT DISTINCT
	item_name
FROM orders
WHERE item_name LIKE '%chicken%';

SELECT DISTINCT
	item_name
FROM orders
WHERE item_name LIKE '%chicken%';

SELECT *
FROM orders
WHERE item_name = 'Veggie Soft Tacos'
	OR item_name = 'Crispy Tacos'
	OR item_name = 'Steak Bowl';
	
SELECT *
FROM orders
WHERE item_name IN('Veggie Soft Tacos', 'Crispy Tacos', 'Steak Bowl');

USE join_example_db;

SELECT *
FROM users
WHERE role_id IS NOT NULL;

SELECT *
FROM users
WHERE role_id IS NULL;

-- and is run before or, if not controlled with ()
USE chipotle;

SELECT *
FROM orders;

-- OR returns all that meet any
-- AND return only records that meet all

