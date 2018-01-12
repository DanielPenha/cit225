-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab10.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

-- Open log file.
SPOOL apply_oracle_lab10.log

-- ----------------------------------------------------------------------
-- Step 1
-- ----------------------------------------------------------------------
SET PAGESIZE 99
SELECT   DISTINCT c.contact_id
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY c.contact_id;


-- ----------------------------------------------------------------------
-- Step 1a
-- ----------------------------------------------------------------------
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;

-- ----------------------------------------------------------------------
-- Step 1b
-- ----------------------------------------------------------------------
SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;

-- ----------------------------------------------------------------------
-- Step 1c
-- ----------------------------------------------------------------------
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;

SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

INSERT INTO rental
SELECT NVL(r.rental_id,rental_s1.NEXTVAL) AS rental_id
,      r.contact_id
,      r.check_out_date
,      r.return_date
,      r.created_by
,      r.creation_date
,      r.last_updated_by
,      r.last_update_date
FROM (SELECT DISTINCT
             r.rental_id
      ,      c.contact_id
      ,      TRUNC(tu.check_out_date) AS check_out_date
      ,      TRUNC(tu.return_date) AS return_date
      ,      3 AS created_by
      ,      TRUNC(SYSDATE) AS creation_date
      ,      3 AS last_updated_by
      ,      TRUNC(SYSDATE) AS last_update_date
      FROM member m INNER JOIN contact c
      ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
      ON   c.first_name = tu.first_name
      AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
      AND  c.last_name = tu.last_name
      AND  tu.account_number = m.account_number LEFT JOIN rental r
      ON   c.contact_id = r.customer_id
      AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
      AND  TRUNC(tu.return_date) = TRUNC(r.return_date)) r;

SELECT   COUNT(*) AS "Rental after count"
FROM     rental;

-- ----------------------------------------------------------------------
-- Step 2
-- ----------------------------------------------------------------------


SELECT   COUNT(*) AS "Rental Item Before Count"
FROM     rental_item;

INSERT INTO rental_item
SELECT rental_item_s1.NEXTVAL AS rental_item_id
, r.rental_id
,      r.item_id
,      r.created_by
,      r.creation_date
,      r.last_updated_by
,      r.last_update_date
,      r.rental_item_price
,      r.rental_item_type
FROM    (SELECT   r.rental_id
         ,        tu.item_id
         ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
         ,        cl.common_lookup_id AS rental_item_type
         ,        3 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        3 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM member m INNER JOIN contact c
      ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
      ON   c.first_name = tu.first_name
      AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
      AND  c.last_name = tu.last_name
      AND  tu.account_number = m.account_number INNER JOIN common_lookup cl
        ON cl.common_lookup_type = tu.rental_item_type
        AND cl.common_lookup_table = 'RENTAL_ITEM' LEFT JOIN rental r
      ON   c.contact_id = r.customer_id
      AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
      AND  TRUNC(tu.return_date) = TRUNC(r.return_date)) r ;
			
SELECT   COUNT(*) AS "Rental Item After Count"
FROM     rental_item;

-- ----------------------------------------------------------------------
-- Step 3
-- ----------------------------------------------------------------------



INSERT INTO transaction
SELECT NVL(r.transaction_id,transaction_s1.NEXTVAL) AS transaction_id
,      r.transaction_account
,      r.transaction_type
,      r.transaction_date
,      r.transaction_amount
,      r.rental_id
,      r.payment_method_type
,      r.payment_account_number
,      r.created_by
,      r.creation_date
,      r.last_updated_by
,      r.last_update_date
FROM (SELECT t.transaction_id AS transaction_id
      ,      tu.account_number AS transaction_account
      ,      cl1.common_lookup_id AS transaction_type
      ,      TRUNC(tu.transaction_date) AS transaction_date
 --     ,      SUM(tu.transaction_amount) OVER (PARTITION BY r.rental_id) AS transaction_amount
      ,      SUM(tu.transaction_amount / 1.06) AS transaction_amount
      ,      r.rental_id
      ,      cl2.common_lookup_id AS payment_method_type
      ,      tu.payment_account_number
      ,      3 AS created_by
      ,      TRUNC(SYSDATE) AS creation_date
      ,      3 AS last_updated_by
      ,      TRUNC(SYSDATE) AS last_update_date
      FROM member m INNER JOIN contact c
      ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
      ON   c.first_name = tu.first_name
      AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
      AND  c.last_name = tu.last_name
      AND  tu.account_number = m.account_number INNER JOIN rental r
      ON   c.contact_id = r.customer_id
      AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
      AND  TRUNC(tu.return_date) = TRUNC(r.return_date)INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2
ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
AND t.TRANSACTION_TYPE = cl1.common_lookup_id
AND t.TRANSACTION_DATE = tu.transaction_date
AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
AND t.PAYMENT_METHOD_type = cl2.common_lookup_id
AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
GROUP BY t.transaction_id, tu.account_number, cl1.common_lookup_id, tu.transaction_date,
r.rental_id, cl2.common_lookup_id, tu.payment_account_number) r;

-- Commit inserted records.
COMMIT;

-- Close log file.
SPOOL OFF