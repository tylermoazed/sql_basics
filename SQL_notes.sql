/*
Quiz: Write a query that limits the response to only the first 15 rows and 
includes the occurred_at, account_id, and channel fields in the web_events table.
*/

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

/*
In order to gain some practice using ORDER BY:

Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.

Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.

Write a query to return the bottom 20 orders in terms of least total. Include the id, account_id, and total.
*/

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

SELECT id, account_id, total
FROM orders
ORDER BY total
LIMIT 20;

/*
Write a query that returns the top 5 rows from orders ordered according to newest to 
oldest, but with the largest total_amt_usd for each date listed first for each date
*/

SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;

/*
Write a query that returns the top 10 rows from orders ordered according to oldest to 
newest, but with the smallest total_amt_usd for each date listed first for each date. 
*/

SELECT *
FROM orders
ORDER BY occurred_at, total_amt_usd
LIMIT 10;

/*
Pull the first 5 rows and all columns from the orders table that have a dollar amount 
of gloss_amt_usd greater than or equal to 1000
*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*Pull the first 10 rows and all columns from the orders table that have a 
total_amt_usd less than 500.
*/

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/*
Filter the accounts table to include the company name, website, and the primary point 
of contact for Exxon Mobil in the accounts table.
*/

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

/*Arithmetic Operators:
Create a column that divides the standard_amt_usd by the standard_qty to find the unit 
price for standard paper for each order. Limit the results to the first 10 orders, and 
include the id and account_id fields
*/
SELECT id, account_id, standard_amt_usd / standard_qty AS unit_price_usd
FROM orders
LIMIT 10;

/*
Write a query that finds the percentage of revenue that comes from poster paper for each 
order. You will need to use only the columns that end with _usd. (Try to do this without 
using the total column). Include the id and account_id fields.
*/

SELECT id, account_id, 
poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd) AS poster_pct
FROM orders
LIMIT 10;

/*
avoid divide by zero error */

SELECT id, account_id, 
poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd+.0001) AS poster_pct
FROM orders;

/*
Use the accounts table to find

All the companies whose names start with 'C'. 

All companies whose names contain the string 'one' somewhere in the name.

All companies whose names end with 's'.
*/

SELECT *
FROM accounts
WHERE name LIKE 'C%' OR name LIKE '%one%' OR name like '%s';

/*
Questions using IN operator

Use the accounts table to find the account name, primary poc, and sales rep id for 
Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

/*
Use the web_events table to find all information regarding individuals who were 
contacted via organic or adwords.
*/

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

/*
Questions using the NOT operator
We can pull all of the rows that were excluded from the queries in the previous 
two concepts with our new operator.
*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%one%' AND name NOT like '%s';

/*
Write a query that returns all the orders where the standard_qty is over 1000, 
the poster_qty is 0, and the gloss_qty is 0.
*/
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

/*
Using the accounts table find all the companies whose names 
do not start with 'C' and end with 's'.
*/
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT like '%s';


/*
Use the web_events table to find all information regarding individuals who were 
contacted via organic or adwords and started their account at any point in 2016 sorted 
from newest to oldest.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

/*
Questions using the OR operator
Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table.
*/
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

/*
Write a query that returns a list of orders where the standard_qty is zero and either 
the gloss_qty or poster_qty is over 1000.
*/

SELECT *
FROM orders
WHERE (gloss_qty > 1000 OR poster_qty > 1000) AND standard_qty = 0;

/*
Find all the company names that start with a 'C' or 'W', and the primary contact contains 
'ana' or 'Ana', but it doesn't contain 'eana'.
*/
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND 
((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');

JOINS

/*
Essentially ideas that are aimed at database normalization:

Are the tables storing logical groupings of the data?
Can I make changes in a single location, rather than in many tables for the same information?
Can I access and manipulate data quickly and efficiently?
*/

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Try pulling all the data from the accounts table, and all the data from the orders table.
*/
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


/*
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the 
website and the primary_poc from the accounts table.
*/

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website,
accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
ALIAS examples

FROM tablename t1
JOIN tablename2 t2

and

SELECT col1 + col2 total, col3

- a space after the actual table or column name creates an alias
*/

/*
Provide a table for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the event, 
and the channel for each event. Additionally, you might choose to add a fourth column 
to assure only Walmart events were chosen. 
*/

SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

/*
Provide a table that provides the region for each sales_rep along with their associated 
accounts. Your final table should include three columns: the region name, the sales rep 
name, and the account name. Sort the accounts alphabetically (A-Z) according to account 
name. 
*/

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;


/*
Provide the name for each region for every order, as well as the account name and 
the unit price they paid (total_amt_usd/total) for the order. Your final table should 
have 3 columns: region name, account name, and unit price. A few accounts have 0 for 
total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

