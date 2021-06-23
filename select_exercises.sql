-- select db to use
USE albums_db;

-- see basic info for selected db
DESCRIBE albums;

-- see how many rows there are
SELECT *
FROM albums;
-- there are 31 rows

-- see how many unique artist names there are in albums table
SELECT DISTINCT 
	artist
FROM albums;
-- there are 23

-- what is the primary key the albums table
DESCRIBE albums;
-- the primary key is id

-- what is the oldest and most recent release date for any album
SELECT 
	release_date
FROM albums;
-- 1967 is oldest and 2011 is the newest (use sort on column from output      

-- use min function to find oldest release date
SELECT 
	MIN(release_date)
FROM albums;
-- 1967

-- use max function to find newest release date
SELECT 
	MAX(release_date)
FROM albums;
-- 2011

-- use max function to find newest release date and add an alias
SELECT 
	MAX(release_date)
	as max_release_date
FROM albums;
-- 2011

-- name of all albums by Pink Floyd
SELECT 
	name
FROM albums
WHERE artist = 'Pink Floyd';
-- The Dark Side of the Moon and The Wall

-- the year Sgt. Pepper's Lonely Hearts Club Band was released 
SELECT 
	release_date
FROM albums
WHERE name = "Sgt. Pepper's Lonely Hearts Club Band";
-- 1967

-- the year Sgt. Pepper's Lonely Hearts Club Band was released using different method to handle ' in album name
SELECT 
	release_date
FROM albums
WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';
-- 1967

-- genre for album Nevermind
SELECT 
	genre
FROM albums
WHERE name = 'Nevermind';
-- Grunge, Alternative rock

-- which albums were released in the 1990s
SELECT 
	name
FROM albums
WHERE release_date BETWEEN 1990 AND 1999;
-- 11 results

-- Which albums had less than 20 million certified sales
SELECT 
	name
FROM albums
WHERE sales < 20;
-- 13 results

-- All the albums with a genre of "Rock"
SELECT 
	name
FROM albums
WHERE genre = 'Rock';
-- 5 results
-- these query results do not include albums with a genre of "Hard rock" or "Progressive rock" since we are only looking for "Rock" only, not if genre includes "rock"

-- All the albums with a genre that contains "rock"
SELECT 
	name
FROM albums
WHERE genre like '%rock%';
-- 23 results
-- this is a way to get any genres that contain this word