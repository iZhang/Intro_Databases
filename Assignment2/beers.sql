--(a) Find all beers served at Satisfaction.

SELECT beer
FROM serves
WHERE bar = 'Satisfaction'

--(b) Find the names and addresses of bars frequented by Amy.

SELECT name, address
FROM bar
WHERE name IN (SELECT bar FROM frequents WHERE drinker = 'Amy')

--(c) Find the names of bars serving atleast one beer liked by Amy for no more than $2.50.

SELECT bar
FROM serves
WHERE beer IN (SELECT beer FROM likes WHERE drinker = 'Amy')
AND price < 2.51

--(d) Find the names of bars frequented by both Ben andDan.

SELECT bar
FROM frequents
WHERE drinker = 'Ben'
INTERSECT
SELECT bar  
FROM frequents
WHERE drinker = 'Dan'

--(e) Find the names of bars frequented by either Ben orDan, but not both.

(SELECT bar
FROM frequents
WHERE drinker = 'Ben' OR drinker = 'Dan')
EXCEPT
(SELECT bar
FROM frequents
WHERE drinker = 'Ben'
INTERSECT
SELECT bar  
FROM frequents
WHERE drinker = 'Dan')

--(f) For each bar, find all beers served there that are liked by no one who frequents there.

SELECT bar, beer
FROM serves
EXCEPT
(SELECT bar,beer  FROM frequents NATURAL JOIN likes)

--(g) Find names of all drinkers who frequent only those bars that serve some beers they like.

(SELECT name
FROM drinker)
EXCEPT
(
SELECT drinker FROM 
(
	(SELECT drinker,bar
	FROM frequents)
	EXCEPT
	(SELECT drinker,bar
	FROM likes NATURAL JOIN serves)

) AS alias
)

--(h) Find	names	of	all	drinkers	who	frequent	every bar	that	serves	some	beers	they	like.

(SELECT name
FROM drinker)
EXCEPT
(
SELECT drinker FROM 
(
	(SELECT drinker,bar
	FROM likes NATURAL JOIN serves)
	EXCEPT
	(SELECT drinker,bar
	FROM frequents)

) AS alias
)

--(i) Find,	for	each	drinker,	the	bar(s)	he	or	she	frequents	the	most.	The	output	should	be	list	of (drinker,	bar)	pairs.	If	some	drinker	� does	not	frequent	any	bar,	you	should	still	output	(NULL).

SELECT *
FROM frequents
WHERE (drinker, times_a_week) IN
(	
	SELECT drinker, MAX(times_a_week)
	FROM frequents
	GROUP BY drinker
)

--(j) For	each	bar,	find	the	total	number	of	drinkers	who	frequent	it,	as	well	as	the	average	price	of	beers	it	serves.	Sort	the	output	by	the	number	of	drinkers (in	descending	order).

(SELECT bar, count(*)
FROM frequents
GROUP BY frequents.bar
ORDER BY count(*) DESC)

NATURAL JOIN 

(SELECT bar, avg(price)
FROM serves
GROUP BY bar)
