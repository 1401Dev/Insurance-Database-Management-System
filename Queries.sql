-- including the schema
use ins_mng;

-- 1) Retrieve the average policy price and duration of the policy
SELECT AVG(sum) AS Average_Price, AVG(duration) AS Average_Duration 
FROM policy1;

-- 2) The query shows how many customers are handled by each agent, order by agn_id in descending order
SELECT agn_id, count(DISTINCT cus_id) AS no_of_cus
FROM agent1
GROUP BY agn_id
ORDER BY agn_id DESC;

-- 3) Retrieving the name of the admin under whom employeeID 78741 works
SELECT a_fname AS First_Name, a_lname AS Last_Name
FROM admin AS a
JOIN employee2 AS e
	ON a.admin_id = adminID
WHERE e.empID = '78741';

-- 4) Retrieve policynumber, policy type along with the no of policies sold
SELECT policynumber, count(policynumber) AS Policy_Sold, pt.p_type
FROM policy2 p2
LEFT JOIN policy_type pt ON  p2.policynumber=pt.p_no
GROUP BY 1;

-- 5) List of all the customers along with their name and phone number who does not have policy no. 10000 and 10005 
SELECT cus_id, cus_fname, cus_phno, policy_no 
FROM customer1
WHERE policy_no NOT IN (
	SELECT policynumber
    FROM policy2
    WHERE policynumber = 10000 AND policynumber = 10005);
    
-- 6) Retriving the first name of all the customers who have 1 or more than 1 policies, order by their first name
SELECT c1.cus_fname
FROM customer1 c1
WHERE (SELECT count(*)
	  FROM policy2 p2
      WHERE p2.custid = c1.cus_id
      GROUP BY p2.custid) >= 1
ORDER BY c1.cus_fname;

-- 7) Retrieve the name of the highest priced policy (total_amt)
SELECT p_type
FROM policy_type
WHERE p_no IN (SELECT policyNO
			  FROM payment2
              WHERE receiptNO IN (SELECT receipt_no
								 FROM payment1
								 WHERE total_amt IN (SELECT total_amt
													 FROM payment1
													 WHERE total_amt >= ALL(SELECT total_amt
																			FROM payment1))));

-- 8) Retrieve the list of first name of 5 customers who have highest payment_due
SELECT cus_fname
FROM customer1
WHERE policy_no IN (SELECT policyNO
					FROM payment2
					WHERE receiptNO IN (SELECT receipt_no
										FROM payment1
										WHERE payment_due > ANY (SELECT payment_due
																 FROM payment1)))
LIMIT 5;
                                                                 
 -- 9) Retrieve the required policy document for the customer id 6473
 SELECT doc
 FROM policy1 AS p
 WHERE EXISTS (SELECT *
			   FROM customer1 AS c
               WHERE p.policy_no = c.policy_no
               AND c.cus_id = '6473');

-- 10) Selecting the policy numbers that have no payment due greater than $100
SELECT p2.policyNO
FROM payment2 AS p2
WHERE NOT EXISTS (SELECT *
				  FROM payment1 AS p1
                  WHERE p1.receipt_no = p2.receiptNO
                  AND p1.payment_due > 100);					
