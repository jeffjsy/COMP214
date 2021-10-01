/* Module 3 Lab Exercises */

/*1. List the book title and retail price for all books with a retail price lower than the average retail
price of all books sold by JustLee Books.*/
SELECT title, retail
FROM books
WHERE retail < (SELECT AVG(retail)
FROM books);

/*2. Determine which books cost less than the average cost of other books in the same category. */
SELECT a.title, b.category, a.cost
FROM books a, (SELECT category, AVG(cost) averagecost
FROM books
GROUP BY category)b
WHERE a.category = b.category
AND a.cost < b.averagecost;

/*3. Determine which orders were shipped to the same state as order 1014.*/
SELECT order#
FROM orders
WHERE shipstate = (SELECT shipstate FROM ORDERS
WHERE order#= 1014);

/*4. Determine which orders had a higher total amount due than order 1008.*/
SELECT oi.order#, SUM(oi.quantity*oi.paideach)
FROM orderitems oi, books b
WHERE oi.isbn = b.isbn
GROUP BY OI.ORDER#
HAVING SUM(oi.quantity*oi.paideach)> (SELECT SUM(oi.quantity*oi.paideach)
FROM orderitems oi, books b
WHERE oi.isbn = b.isbn
AND oi.order# = 1008)

