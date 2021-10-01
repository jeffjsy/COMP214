/*3-9 Create a PL/SQL block that retrieves and displays information for a specific project based on
Project ID. Display the following on a single row of output: project ID, project name, number of
pledges made, total dollars pledged, and the average pledge amount. */

DECLARE
    proj_id dd_project.idproj%TYPE := 504;
    proj_name dd_project.projname%TYPE;
    pledge_sum dd_pledge.pledgeamt%TYPE;
    pledge_avg dd_pledge.pledgeamt%TYPE;
    pledge_count NUMBER(4);
BEGIN
    SELECT COUNT(*), SUM(pledgeamt), AVG(pledgeamt)
    INTO pledge_count, pledge_sum, pledge_avg
    FROM dd_pledge 
    JOIN dd_project USING (idproj)
    WHERE idproj = proj_id
    GROUP by idproj;

    SELECT projname
    INTO proj_name
    FROM dd_project
    WHERE idproj = proj_id; 

DBMS_OUTPUT.PUT_LINE('Project ID: '|| proj_id || '. Project Name: '|| proj_name || '. Number of Pledges: '|| pledge_count || '. Pledge Total: '|| pledge_sum || '. Pledge Average: '|| pledge_avg);
END;

/*3-10 Create a PL/SQL block to handle adding a new project. Create and use a sequence named
DD_PROJID_SEQ to handle generating and populating the project ID. The first number issued
by this sequence should be 530, and no caching should be used. Use a record variable to
handle the data to be added. Data for the new row should be the following: project name = HK
Animal Shelter Extension, start = 1/1/2013, end = 5/31/2013, and fundraising goal = $65,000.
Any columns not addressed in the data list are currently unknown.*/

CREATE SEQUENCE DD_PROJID_SEQ    
    START WITH 530    
    INCREMENT BY 1
    NOCACHE;
DECLARE
    new_proj_data dd_project%ROWTYPE;    
BEGIN
    SELECT dd_projid_seq.NEXTVAL
    INTO new_proj_data.idproj
    FROM DUAL;
    
    new_proj_data.projname := 'HK Animal Shelter Extension';
    new_proj_data.projstartdate := '1-JAN-2013';
    new_proj_data.projenddate := '31-MAY-2013';
    new_proj_data.projfundgoal := 65000;
    
    INSERT INTO dd_project
    VALUES new_proj_data;
END; 

/*3-11 Create a PL/SQL block to retrieve and display data for all pledges made in a specified month.
One row of output should be displayed for each pledge. Include the following in each row
of output:
• Pledge ID, donor ID, and pledge amount
• If the pledge is being paid in a lump sum, display “Lump Sum.”
• If the pledge is being paid in monthly payments, display “Monthly - #” (with the #
representing the number of months for payment).
• The list should be sorted to display all lump sum pledges first.*/

DECLARE
    pledges dd_pledge%ROWTYPE;
    month_start dd_pledge.pledgedate%type := '01-MAR-13';
    month_end dd_pledge.pledgedate%type := '31-MAR-13';    
BEGIN 
    FOR pledges IN(
        SELECT idpledge, iddonor, pledgeamt, CASE
        WHEN PAYMONTHS = 0 
        THEN 'Lump Sum'
        ELSE 'Monthly - ' || PAYMONTHS
        END AS payments
        FROM DD_PLEDGE
        WHERE PLEDGEDATE >= month_start AND PLEDGEDATE <= month_end
        ORDER BY PAYMONTHS)
    LOOP DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || PLEDGES.IDPLEDGE || '. Donor ID: '|| PLEDGES.IDDONOR || '. Pledge Amount: $' ||PLEDGES.PLEDGEAMT || '. Monthly Payments: ' || PLEDGES. payments || '.');
    END LOOP;
END; 


/*3-12 Create a PL/SQL block to retrieve and display information for a specific pledge. Display the
pledge ID, donor ID, pledge amount, total paid so far, and the difference between the pledged
amount and total paid amount.*/

DECLARE
    pledges dd_pledge%ROWTYPE;
    total_payments dd_payment.payamt%TYPE;
    paid_amt dd_pledge.pledgeamt%TYPE;
    balance dd_pledge.pledgeamt%TYPE;
    months_paid NUMBER(5);    
BEGIN
    SELECT *
    INTO pledges
    FROM dd_pledge
    WHERE idpledge = 105;
    
    SELECT SUM(payamt)
    INTO total_payments
    FROM dd_payment
    WHERE dd_payment.idpledge = pledges.idpledge;
    
months_paid := pledges.paymonths;
paid_amt := total_payments;
IF pledges.paymonths = 0 
    THEN paid_amt := pledges.pledgeamt;
    ELSE paid_amt := months_paid * (pledges.pledgeamt/pledges.paymonths);
END IF;
balance := pledges.pledgeamt - total_payments;
DBMS_OUTPUT.PUT_LINE('Pledge ID: ' || pledges.idpledge);
DBMS_OUTPUT.PUT_LINE('Donor ID: ' || pledges.iddonor);
DBMS_OUTPUT.PUT_LINE('Pledge Amount: ' || pledges.pledgeamt);
DBMS_OUTPUT.PUT_LINE('Amount Paid: ' || total_payments);
DBMS_OUTPUT.PUT_LINE('Balance: ' || balance);
END; 

/*3-13 Create a PL/SQL block to modify the fundraising goal amount for a specific project. In addition,
display the following information for the project being modified: project name, start date,
previous fundraising goal amount, and new fundraising goal amount.*/

DECLARE 
    project_name dd_project.projname%TYPE;
    start_date dd_project.projstartdate%TYPE;
    fund_goal dd_project.projfundgoal%TYPE;
    proj_id dd_project.idproj%TYPE := '500';
    new_fund_goal dd_project.projfundgoal%TYPE := '15000';
    
BEGIN
    SELECT projname, projstartdate, projfundgoal
    INTO project_name, start_date, fund_goal
    FROM dd_project
    WHERE idproj = proj_id;

UPDATE dd_project
SET projfundgoal = new_fund_goal
WHERE idproj = proj_id;

DBMS_OUTPUT.PUT_LINE('Project Name: ' || project_name);
DBMS_OUTPUT.PUT_LINE('Start date: '|| start_date);
DBMS_OUTPUT.PUT_LINE('Previous Goal: ' || fund_goal);
DBMS_OUTPUT.PUT_LINE('Current Goal: ' || new_fund_goal);
END;  
    