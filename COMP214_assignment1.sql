/*1. List the name of each officer who has reported more than the average number of crimes officers have reported. */
SELECT co.officer_id, o.first||' '|| o.last AS "Officer Name"
FROM crime_officers co 
    JOIN officers o 
    ON co.officer_id = o.officer_id
GROUP BY co.officer_id, o.first, o.last
HAVING COUNT(*) > (SELECT COUNT(*) / COUNT(DISTINCT officer_id) FROM crime_officers);

/*2. List the names of all criminals who have committed less than average number of crimes and aren’t listed as violent offenders.*/
SELECT crl.criminal_id, crl.first||' '|| crl.last AS "Name of Criminal", crl.v_status
FROM criminals crl
    JOIN crimes cr
    ON crl.criminal_id = cr.criminal_id
GROUP BY crl.criminal_id, crl.first, crl.last, crl.v_status
HAVING COUNT(*) < (SELECT COUNT(*) / COUNT(DISTINCT criminal_id) FROM crimes)
AND crl.v_status = 'N';     

/*pro answer*/
SELECT first, last
FROM criminals JOIN crimes USING (criminal_id)
WHERE v_status = 'N' 
GROUP BY first, last
HAVING COUNT(crime_id) < (SELECT AVG(COUNT(crime_id)) FROM crimes GROUP by criminal_id;

/*3. List appeal information for each appeal that has a less than average number of days between the filing and hearing dates. */
SELECT appeal_id, crime_id, filing_date, hearing_date
FROM appeals
WHERE hearing_date - filing_date < (SELECT AVG(hearing_date - filing_date) FROM appeals);

/*4. List the names of probation officers who have had a less than average number of criminals assigned. */
SELECT first||' '||last AS "P. Officer name"
FROM prob_officers po
JOIN sentences s
ON po.prob_id = s.prob_id
GROUP BY po.first, po.last
HAVING COUNT(*) < (SELECT COUNT(*) / COUNT(DISTINCT criminal_id) FROM sentences);


/*5. List each crime that has had the highest number of appeals recorded.*/
SELECT appeal_id, crime_id
FROM appeals app
WHERE EXISTS (SELECT cc.crime_id FROM crime_charges cc WHERE cc.crime_id = app.crime_id);

SELECT crime_id, COUNT(appeal_id)
FROM appeals
GROUP BY crime_id
HAVING COUNT(appeal_id) = (SELECT MAX(COUNT(appeal_id)) FROM appeals GROUP BY crime_id);


/*6. List the information on crime charges for each charge that has had a fine above average and a sum paid below average.*/
SELECT charge_id, crime_id, crime_code, fine_amount, amount_paid
FROM crime_charges
WHERE fine_amount > (SELECT AVG(fine_amount) FROM crime_charges)
AND amount_paid < (SELECT AVG(amount_paid) FROM crime_charges);

/*7. List the names of all criminals who have had any of the crime code charges involved in crime ID 10089. */
SELECT cl.criminal_id, first||' '||last AS "Name of Criminal", cr.crime_id
FROM criminals cl
INNER JOIN crimes cr ON cl.criminal_id=cr.criminal_id
WHERE cr.crime_id = 10089;

SELECT DISTINCT first, last
FROM criminals JOIN crimes 
USING (criminal_id)
JOIN crime_charges USING (crime_id)
WHERE crime_code IN (SELECT crime_code FROM crime_charges WHERE crime_id = 10089);


