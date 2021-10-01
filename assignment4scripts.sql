--Sequence 
CREATE SEQUENCE sq_bs_sequence
    START WITH 1001
    INCREMENT BY 1; 
    
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 001, 006, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 002, 003, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 003, 002, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 004, 007, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 005, 009, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 006, 001, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 007, 002, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 008, 010, 2);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 009, 008, 1);
INSERT INTO bs_shopcart
VALUES (sq_bs_sequence.NEXTVAL, 010, 009, 1);

--Index 
CREATE INDEX index_orders 
    ON bs_orders (order_date, ship_date);

--Trigger 1. Fires when inserting new customer record to bs_customer and records change in bs_custhistory
CREATE OR REPLACE TRIGGER bs_trigger_new 
    AFTER
    INSERT 
    ON bs_customers
    FOR EACH ROW
BEGIN        
    INSERT INTO bs_custhistory(change_type, by_user, change_date)
    VALUES ('INSERT', USER, SYSDATE);
END;

--Testing for bs_trigger_new
INSERT INTO bs_customers 
VALUES (111, 'Jeffrey Sy');

--Trigger 2. Fires when customer record is updated or deleted. Change is recorded in table bs_custhistory    
CREATE OR REPLACE TRIGGER bs_trigger_update 
    AFTER
    UPDATE OR DELETE 
    ON bs_customers
    FOR EACH ROW
DECLARE
    tr_changes VARCHAR2(10);
BEGIN
    tr_changes := CASE            
            WHEN UPDATING THEN 'UPDATE'
            WHEN DELETING THEN 'DELETE'
    END;
    
    INSERT INTO bs_custhistory(change_type, by_user, change_date)
    VALUES (tr_changes, USER, SYSDATE);
END;

--Testing for the 2nd trigger
UPDATE bs_customers
SET customer_id = 210, name = 'James Bond'
WHERE customer_id = 110;

--Procedure 1. Sums the current amount of books in bs_shopchart table
CREATE OR REPLACE PROCEDURE counting_proc
    AS
    CURSOR c_count IS 
    SELECT SUM(quantity) FROM bs_shopcart;
    
    lv_shopcount bs_shopcart.quantity%TYPE;
BEGIN
    OPEN c_count;
    FETCH c_count INTO lv_shopcount;
    
    DBMS_OUTPUT.PUT_LINE('Total quantity of Books ordered: '||lv_shopcount);
    CLOSE c_count;    
END counting_proc;

--Running procedure 1 and displaying to DBMS output. 
EXEC counting_proc;

--Procedure 2. Display customers in table to DBMS output
CREATE OR REPLACE PROCEDURE p_custdisplay
AS
    lv_custid bs_customers.customer_id%TYPE;
    lv_custname bs_customers.name%TYPE;
    CURSOR c_cust IS
    SELECT bs_customers.customer_id, bs_customers.name FROM bs_customers;
BEGIN
    OPEN c_cust;
    LOOP
        FETCH c_cust into lv_custid, lv_custname;
        EXIT WHEN c_cust%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Customer ID: '||lv_custid||' - Customer Name: '||lv_custname);
    END LOOP;
    CLOSE c_cust;
END p_custdisplay;

--Testing for proecdure 2. Displays to dbms output
EXEC p_custdisplay;

--Function to input the book_id number, returns the book author's name. 
CREATE OR REPLACE FUNCTION fc_bookauthor
    (fc_book_id IN NUMBER)
RETURN VARCHAR2
IS 
    lv_bookid NUMBER := fc_book_id;
    lv_authorname VARCHAR2(40);
    lv_bookname VARCHAR2(40);
BEGIN
    SELECT B.BOOK_TITLE, A.FIRST_NAME||' '||A.LAST_NAME AS fullname
    INTO lv_bookname, lv_authorname
    FROM BS_BOOK B 
    INNER JOIN BS_AUTHOR A
    ON B.AUTHOR_ID = A.AUTHOR_ID
    WHERE B.BOOK_ID = lv_bookid;
    
    RETURN lv_authorname;    
END;


--Testing harness for function
DECLARE
    lv_id_request VARCHAR(30);
BEGIN
    lv_id_request := fc_bookauthor(10);
    DBMS_OUTPUT.PUT_LINE('Author name: '||lv_id_request);
END;

        
/*
DROP TABLE BS_SHOPCART;
DROP TABLE BS_ORDERS;
DROP TABLE BS_CUSTOMERS;
DROP TABLE BS_BOOK;
DROP TABLE BS_AUTHOR;
DROP TABLE BS_CUSTHISTORY;
DROP SEQUENCE sq_bs_sequence;
DROP INDEX index_orders;
DROP TRIGGER bs_trigger_new;
DROP TRIGGER bs_trigger_update;
DROP PROCEDURE counting_proc;
DROP PROCEDURE p_custdisplay;
DROP FUNCTION fc_bookauthor;
*/
