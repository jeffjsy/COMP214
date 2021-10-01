/*1. The home page of the Brewbean’s Web site has an option for members to log on with their IDs
and passwords. Develop a procedure named MEMBER_CK_SP that accepts the ID and password
as inputs, checks whether they make up a valid logon, and returns the member name and cookie
value. The name should be returned as a single text string containing the first and last name. 
The head developer wants the number of parameters minimized so that the same
parameter is used to accept the password and return the name value. Also, if the user doesn’t
enter a valid username and password, return the value INVALID in a parameter named
p_check. Test the procedure using a valid logon first, with the username rat55 and password
kile. Then try it with an invalid logon by changing the username to rat. */

CREATE OR REPLACE PROCEDURE member_ck_sp
    (p_userid IN bb_shopper.username%TYPE,
    p_password IN OUT VARCHAR2,
    p_cookie OUT VARCHAR2,
    p_check OUT VARCHAR2) IS
BEGIN
    SELECT firstname||' '||lastname, cookie
    INTO p_password, p_cookie
    FROM bb_shopper
    WHERE username = p_userid
    AND password = p_password;
    DBMS_OUTPUT.PUT_LINE('User: '||p_password);
    DBMS_OUTPUT.PUT_LINE('Cookie: '||p_cookie);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid login');    
    p_check := 'INVALID';
END member_ck_sp;

DECLARE  
  t_user VARCHAR2(20):='kile'; 
  t_cookie bb_shopper.cookie%TYPE;
  t_check VARCHAR2(10); 
BEGIN 
  member_ck_sp('rat55', t_user, t_cookie, t_check); --correct login
  member_ck_sp('rat', t_user, t_cookie, t_check); --incorrect login
END; 

/*2. Create a procedure named DDPAY_SP that identifies whether a donor currently has an completed pledge with no monthly payments. 
A donor ID is the input to the procedure. Using the donor ID, the procedure needs to determine whether the donor has any currently 
completed pledges based on the status field and is/was not  on a monthly payment plan. If so, the procedure is to return the Boolean 
value TRUE. Otherwise, the value FALSE should be returned. Test the procedure with an anonymous block. */
CREATE OR REPLACE PROCEDURE ddpay_sp
    (p_id IN NUMBER,
    p_resp OUT BOOLEAN) IS
    p_status NUMBER;
    p_paymon NUMBER;    
BEGIN
    SELECT idstatus, paymonths
    INTO p_status, p_paymon
    FROM dd_pledge
    WHERE idpledge = p_id;

    IF p_status != 10 AND p_paymon > 1 
    THEN p_resp := FALSE;
    ELSIF p_status = 10 AND p_paymon > 0 
    THEN p_resp := TRUE;
    END IF;    
END ddpay_sp;

DECLARE
    p_id dd_pledge.idpledge%TYPE:= 107;
    p_resp BOOLEAN;
BEGIN
ddpay_sp(p_id, p_resp);

IF p_resp = TRUE 
    THEN
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;

/*3. Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is the correct amount. 
The procedure needs to accept two values as input: a payment amount and a pledge ID. Based on these inputs,
the procedure should confirm that the payment is the correct monthly increment amount, based on pledge data
in the database. If it isn’t, a custom Oracle error using error number 20050 and the message “Incorrect payment 
amount - planned payment = ??” should be raised. The ?? should be replaced by the correct payment amount. The 
database query in the procedure should be formulated so that no rows are returned if the pledge isn’ton a monthly 
payment plan or the pledge isn’t found. If the query returns no rows, the procedure should display the message 
“No payment information.” Test the procedure with the pledge ID 104 and the payment amount $25. Then test with the 
same pledge ID but the payment amount $20.Finally,test the procedure with a pledge ID for a pledge that doesn’t
have monthly payments associated with it. */

CREATE OR REPLACE PROCEDURE ddckpay_sp
    (p_id IN NUMBER,
    p_amt IN NUMBER,
    p_result OUT VARCHAR2) IS    
    p_paymon dd_pledge.paymonths%TYPE;
    p_plid dd_pledge.idpledge%TYPE;
    p_plamt dd_pledge.pledgeamt%TYPE;
    p_total dd_pledge.pledgeamt%TYPE;
    p_except EXCEPTION;
    
BEGIN
    SELECT idpledge, pledgeamt, paymonths
    INTO p_plid, p_plamt, p_paymon
    FROM dd_pledge
    WHERE idpledge = p_id;    
IF p_paymon = 0 THEN 
    RAISE p_except;
END IF;
p_total := p_plamt / p_paymon;

IF p_amt = p_total THEN
    p_result := 'Correct Payment';
ELSIF p_amt != p_total THEN
    RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment = '|| p_total);
END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No payment information');
    WHEN p_except THEN DBMS_OUTPUT.PUT_LINE('No payment information');
END ddckpay_sp;


DECLARE  --testing harness 1
  t_id NUMBER(3) := 104;
  t_amt NUMBER(2) := 25;
  t_result VARCHAR2(100);
BEGIN 
  ddckpay_sp(t_id, t_amt, t_result);
  DBMS_OUTPUT.PUT_LINE(t_result);
END; 

DECLARE  --testing harness 2
  t_id NUMBER(3) := 104;
  t_amt NUMBER(2) := 20;
  t_result VARCHAR2(100);
BEGIN 
  ddckpay_sp(t_id, t_amt, t_result);
  DBMS_OUTPUT.PUT_LINE(t_result);
END; 

DECLARE  --testing harness 3
  t_id NUMBER(3) := 101;
  t_amt NUMBER(2) := 25;
  t_result VARCHAR2(100);
BEGIN 
  ddckpay_sp(t_id, t_amt, t_result);
  DBMS_OUTPUT.PUT_LINE(t_result);
END;     

/* 4. The Reporting and Analysis Department has a database containing tables that hold summarized data to make report generation simpler and more efficient. They want to schedule some jobs to run nightly to update summary tables. Create two procedures to update the following tables(assuming that existing data in the tables is deleted before these procedures run):
Create the PROD_SALES_SUM_SP procedure to update the BB_PROD_SALES
table, which holds total sales dollars and total sales quantity by product ID, month,
and year. The order date should be used for the month and year information.
Create the SHOP_SALES_SUM_SP procedure to update the BB_SHOP_SALES
table, which holds total dollar sales by shopper ID. The total should include only
product amounts—no shipping or tax amounts.

The BB_SHOP_SALES and BB_PROD_SALES tables have already been created. Use the
DESCRIBE command to review their table structures. Run pl/sql block to execute and present results for both procedures. */

CREATE OR REPLACE PROCEDURE prod_sales_sum_sp IS
CURSOR cur_prod_sales IS
    SELECT bi.idproduct id,
    TO_CHAR(b.dtordered,'MON') mth,
    TO_CHAR(b.dtordered, 'YYYY') yr,
    SUM(bi.quantity) qty,
    SUM(bi.quantity*bi.price) totalsum
    FROM bb_basket b INNER JOIN bb_basketitem bi
    USING (idbasket)
    WHERE b.orderplaced = 1
    GROUP BY bi.idproduct,TO_CHAR(b.dtordered,'MON'),TO_CHAR(b.dtordered, 'YYYY');
BEGIN
FOR each_sale IN cur_prod_sales LOOP
  INSERT INTO bb_prod_sales (idproduct, month, year, qty, total)
  VALUES (each_sale.id, each_sale.mth, each_sale.yr, each_sale.qty, each_sale.totalsum);
END LOOP;
END;

CREATE OR REPLACE PROCEDURE shop_sales_sum_sp IS
CURSOR cur_shop_sales IS
    SELECT idshopper id,
    SUM(bi.quantity*bi.price) total
    FROM bb_shopper s INNER JOIN bb_basket b
    USING (idshopper)
    INNER JOIN bb_basketitem bi
    USING (idbasket)
    WHERE b.orderplaced = 1
    GROUP BY idshopper;
BEGIN
FOR each_sale in cur_shop_sales LOOP
    INSERT INTO bb_shop_sales (idshopper, total)
    VALUES (each_sale.id, each_sale.total);
    END LOOP;
END;



        
