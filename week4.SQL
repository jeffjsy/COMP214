/*DECLARE
    lv_day DATE;
BEGIN
    lv_day := SYSDATE;
    DBMS_OUTPUT.PUT_LINE(lv_day);
END;
//////////////////
DECLARE
    lv_test_date DATE := '10-DEC-2012';
    lv_test_num NUMBER(3) := 10;
    lv_test_txt VARCHAR2(10);
BEGIN
    lv_test_txt := '???????';
    DBMS_OUTPUT.PUT_LINE(lv_test_date);
    DBMS_OUTPUT.PUT_LINE(lv_test_num);
    DBMS_OUTPUT.PUT_LINE(lv_test_txt);
END;
/////////////////
DECLARE
    lv_total_num NUMBER(6,2) := 50;
BEGIN
    IF lv_total_num > 200 THEN
    dbms_output.put_line('high');
    ELSEIF lv_total_num > 100 THEN
    dbms_output.put_line('mid');
    ELSE
    dbms_output.put_line('low');
    END IF;
END; 
/////////////////////////// 
DECLARE
    lv_bal_num NUMBER(8,2) := 150.00;
    lv_pay_num NUMBER(8,2) := 195.00;
    lv_due_bln BOOLEAN;
BEGIN
    IF (lv_bal_num - lv_pay_num) > 0 THEN
    lv_due_bln := TRUE;
    DBMS_OUTPUT.PUT_LINE('DUE');
ELSE
    lv_due_bln := FALSE;
    DBMS_OUTPUT.PUT_LINE('FULLY PAID');
    END IF;
END;
///////////////////////////// */
DECLARE
    lv_total_num NUMBER(6,2) :=200;
    lv_price_num NUMBER(5,2) :=32;
    lv_spent_num NUMBER(6,2) := 0;
    lv_qty_num NUMBER(6) :=0;
BEGIN
    WHILE(lv_spent_num + lv_price_num) < lv_total_num LOOP
    lv_spent_num := lv_spent_num + lv_price_num;
    lv_qty_num := lv_qty_num + 1;
    END LOOP;
DBMS_OUTPUT.put_line('TOTAL SPENT='||lv_spent_num);
DBMS_OUTPUT.put_line('qty purchased ='||LV_qty_num);
END;
