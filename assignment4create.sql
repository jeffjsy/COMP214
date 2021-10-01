CREATE TABLE bs_author(
author_id NUMBER(3),
first_name VARCHAR2(15),
last_name VARCHAR2(15),
    CONSTRAINT bsauthor_authorid_pk PRIMARY KEY(author_id)
);

INSERT INTO bs_author
VALUES (010, 'Jim', 'Carrey');
INSERT INTO bs_author
VALUES (011, 'Tim', 'Taylor');
INSERT INTO bs_author
VALUES (012, 'Al', 'Bundy');
INSERT INTO bs_author
VALUES (013, 'Rod', 'Stewart');
INSERT INTO bs_author
VALUES (014, 'Linda', 'Nowitzki');
INSERT INTO bs_author
VALUES (015, 'Haya', 'Miyaki');
INSERT INTO bs_author
VALUES (016, 'Bob', 'Dugnutt');
INSERT INTO bs_author
VALUES (017, 'Rey', 'McSriff');
INSERT INTO bs_author
VALUES (018, 'Tony', 'Smerik');
INSERT INTO bs_author
VALUES (019, 'Jeremey', 'Gride');
INSERT INTO bs_author
VALUES (020, 'Dwight', 'Rortugal');

CREATE TABLE bs_book(
book_id NUMBER(3),
author_id NUMBER(3),
book_title VARCHAR2(30),
book_year VARCHAR2(4),
book_price NUMBER(5,2),
    CONSTRAINT book_bookid_pk PRIMARY KEY(book_id),
    CONSTRAINT book_authorid_fk FOREIGN KEY(author_id) REFERENCES bs_author(author_id)
);

INSERT INTO bs_book
VALUES (001, 015, 'Black Ice', '2020', 18.28);
INSERT INTO bs_book
VALUES (002, 016, 'Lions of Lucerne', '2019', 15.30);
INSERT INTO bs_book
VALUES (003, 018, 'The Heathens', '2018', 21.99);
INSERT INTO bs_book
VALUES (004, 015, 'Near Death', '2019', 17.78);
INSERT INTO bs_book
VALUES (005, 017, 'Total Power', '2019', 13.76);
INSERT INTO bs_book
VALUES (006, 015, 'Ocean Prey', '2018', 18.98);
INSERT INTO bs_book
VALUES (007, 019, 'Dead by Dawn', '2020', 22.49);
INSERT INTO bs_book
VALUES (008, 020, 'Takedown', '2017', 15.99);
INSERT INTO bs_book
VALUES (009, 020, 'A Gambling Man', '2020', 20.49);
INSERT INTO bs_book
VALUES (010, 015, 'American Traitor', '2021', 19.28);


CREATE TABLE bs_customers(
customer_id NUMBER(4),
name VARCHAR2(15),
    CONSTRAINT customers_customerid_pk PRIMARY KEY (customer_id)
);

INSERT INTO bs_customers
VALUES (100, 'Lebron James');
INSERT INTO bs_customers
VALUES (101, 'Michael Jordan');
INSERT INTO bs_customers
VALUES (102, 'Stephen Curry');
INSERT INTO bs_customers
VALUES (103, 'Kevin Durant');
INSERT INTO bs_customers
VALUES (104, 'Kyle Lowry');
INSERT INTO bs_customers
VALUES (105, 'DeMar DeRozan');
INSERT INTO bs_customers
VALUES (106, 'Terrence Ross');
INSERT INTO bs_customers
VALUES (107, 'Draymond Green');
INSERT INTO bs_customers
VALUES (108, 'Klay Thompson');
INSERT INTO bs_customers
VALUES (109, 'Rudy Gobert');
INSERT INTO bs_customers
VALUES (110, 'Norman Powell');

CREATE TABLE bs_orders(
order_id NUMBER(4),
customer_id NUMBER(6),
address VARCHAR2(50),
order_date DATE NOT NULL,
ship_date DATE,
    CONSTRAINT bsorder_orderid_pk PRIMARY KEY(order_id),
    CONSTRAINT bsorder_customerid_fk FOREIGN KEY(customer_id) REFERENCES bs_customers(customer_id)
);


INSERT INTO bs_orders
VALUES (001, 100, '27 Surrey St. L0N 5J9. Dufferin County ON', TO_DATE('04-APR-21'), TO_DATE('06-APR-21'));
INSERT INTO bs_orders
VALUES (002, 101, '843 Lawrence Ave. N0N 9N8. Lambton ON', TO_DATE('05-JAN-21'), TO_DATE('07-JAN-21'));
INSERT INTO bs_orders
VALUES (003, 102, '201 Image Rd. B2H 6B7. New Glasgow NS', TO_DATE('28-FEB-21'), TO_DATE('02-MAR-21'));
INSERT INTO bs_orders
VALUES (004, 102, '201 Image Rd. B2H 6B7. New Glasgow NS', TO_DATE('01-MAR-21'), TO_DATE('03-MAR-21'));
INSERT INTO bs_orders
VALUES (005, 103, '65 Jerry St. R6W 5C4. Winkler MB', TO_DATE('10-MAR-21'), TO_DATE('13-MAR-21'));
INSERT INTO bs_orders
VALUES (006, 104, '7 Baskett Dr. E5V 8N9. Deer Island NB', TO_DATE('11-MAR-21'), TO_DATE('14-MAR-21'));
INSERT INTO bs_orders
VALUES (007, 105, '432 Nelson Ave. J8G 0S5. Chatham QC', TO_DATE('15-MAR-21'), TO_DATE('18-MAR-21'));
INSERT INTO bs_orders
VALUES (008, 106, '34 Bottle Dr. E7G 2R9. Plaster Rock NB', TO_DATE('20-MAR-21'), TO_DATE('22-MAR-21'));
INSERT INTO bs_orders
VALUES (009, 107, '52 Pen Dr. N0M 5V9. Middlesex ON', TO_DATE('22-MAR-21'), TO_DATE('24-MAR-21'));
INSERT INTO bs_orders
VALUES (010, 106, '34 Bottle Dr. E7G 2R9. Plaster Rock NB', TO_DATE('24-MAR-21'), TO_DATE('26-mar-21'));


CREATE TABLE bs_shopcart(
shopcart_id NUMBER(4),
order_id NUMBER(4),
book_id NUMBER(3),
quantity NUMBER(3) NOT NULL,
    CONSTRAINT shopcart_shopcartid_pk PRIMARY KEY(shopcart_id),
    CONSTRAINT shopcart_orderid_fk FOREIGN KEY (order_id) REFERENCES bs_orders (order_id),
    CONSTRAINT shopcart_bookid_fk FOREIGN KEY (book_id) REFERENCES bs_book (book_id)
);



CREATE TABLE bs_custhistory(
change_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
change_type VARCHAR2(15),
by_user VARCHAR2(30),
change_date DATE
);

INSERT INTO bs_custhistory
VALUES (1, 'UPDATE', USER, TO_DATE('14-JAN-21'));
INSERT INTO bs_custhistory
VALUES (2, 'UPDATE', USER, TO_DATE('18-FEB-21'));
INSERT INTO bs_custhistory
VALUES (3, 'DELETE', USER, TO_DATE('22-MAR-21'));
INSERT INTO bs_custhistory
VALUES (4, 'DELETE', USER, TO_DATE('07-JUN-21'));
INSERT INTO bs_custhistory
VALUES (5, 'UPDATE', USER, TO_DATE('16-JUL-21'));
