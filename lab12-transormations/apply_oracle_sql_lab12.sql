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
--   sql> @apply_oracle_lab11.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab11/apply_oracle_lab11.sql

-- Open log file.
SPOOL apply_oracle_lab12.log

-- ------------------------------------------------------------------
-- Step 1
-- ------------------------------------------------------------------
CREATE TABLE calendar
( calendar_id              NUMBER
, calendar_name              VARCHAR2(10)      CONSTRAINT nn_calendar_1 NOT NULL
, calendar_short_name           VARCHAR2(3)      CONSTRAINT nn_calendar_2 NOT NULL
, start_date            DATE        CONSTRAINT nn_calendar_3 NOT NULL
, end_date              DATE        CONSTRAINT nn_calendar_4 NOT NULL
, created_by            NUMBER      CONSTRAINT nn_calendar_5 NOT NULL
, creation_date         DATE        CONSTRAINT nn_calendar_6 NOT NULL
, last_updated_by       NUMBER      CONSTRAINT nn_calendar_7 NOT NULL
, last_updated_date     DATE        CONSTRAINT nn_calendar_8 NOT NULL
, CONSTRAINT pk_calendar_1 PRIMARY KEY(calendar_id)
, CONSTRAINT fk_calendar_1 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_calendar_2 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

CREATE SEQUENCE calendar_s1;

-- ------------------------------------------------------------------
-- Step 2
-- ------------------------------------------------------------------
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'January', 'JAN', '01-JAN-2009', '31-JAN-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'February', 'FEB', '01-FEB-2009', '28-FEB-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'March', 'MAR', '01-MAR-2009', '31-MAR-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'April', 'APR', '01-APR-2009', '30-APR-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'May', 'MAY', '01-MAY-2009', '31-MAY-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'June', 'JUN', '01-JUN-2009', '30-JUN-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'July', 'JUL', '01-JUL-2009', '31-JUL-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'August', 'AUG', '01-AUG-2009', '31-AUG-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'September', 'SEP', '01-SEP-2009', '30-SEP-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'October', 'OCT', '01-OCT-2009', '31-OCT-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'November', 'NOV', '01-NOV-2009', '30-NOV-2009', 1, SYSDATE, 1, SYSDATE);
INSERT INTO calendar VALUES (calendar_s1.NEXTVAL, 'December', 'DEC', '01-DEC-2009', '31-DEC-2009', 1, SYSDATE, 1, SYSDATE);

-- ------------------------------------------------------------------
-- Step 3
-- ------------------------------------------------------------------
CREATE TABLE transaction_reversal
( transaction_id              NUMBER
, transaction_account         VARCHAR2(15)
, transaction_type            NUMBER
, transaction_date            DATE
, transaction_amount          FLOAT
, rental_id                   NUMBER
, payment_method_type         NUMBER
, payment_account_number      VARCHAR2(19)
, created_by                  NUMBER
, creation_date               DATE
, last_updated_by             NUMBER
, last_update_date            DATE
)
ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload2.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload2.dis'
      LOGFILE     'UPLOAD':'transaction_upload2.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL     )
      LOCATION
       ( 'transaction_upload2.csv'
       )
    );
--'

INSERT INTO transaction
SELECT transaction_s1.NEXTVAL AS transaction_id
,      transaction_account
,      transaction_type
,      transaction_date
,      transaction_amount
,      rental_id
,      (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'VISA_CARD' 
        AND common_lookup_table = 'TRANSACTION'
        AND common_lookup_column = 'PAYMENT_METHOD_TYPE') AS payment_method_type
,      payment_account_number
,      created_by
,      creation_date
,      last_updated_by
,      last_update_date
FROM transaction_reversal;

-- Fix Step 11
UPDATE transaction SET transaction_account = '111-111-111-111' WHERE transaction_account != '222-222-222-222';
-- ------------------------------------------------------------------
-- Verify Step 3
-- ------------------------------------------------------------------
COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

-- ------------------------------------------------------------------
-- Step 4
-- ------------------------------------------------------------------
SET WRAP OFF
COLUMN jan FORMAT A8
COLUMN feb FORMAT A8
COLUMN mar FORMAT A8
COLUMN fq1 FORMAT A8
COLUMN apr FORMAT A8
COLUMN may FORMAT A8
COLUMN jun FORMAT A8
COLUMN fq2 FORMAT A8
COLUMN jul FORMAT A8
COLUMN aug FORMAT A8
COLUMN sep FORMAT A8
COLUMN fq3 FORMAT A8
COLUMN oct FORMAT A8
COLUMN nov FORMAT A8
COLUMN dec FORMAT A8
COLUMN fq4 FORMAT A8
SELECT il.transaction
,       il.jan
,       il.feb
,       il.mar
,       il.fq1
,       il.mar
,       il.apr
,       il.may
,       il.fq2
,       il.jun
,       il.jul
,       il.aug
,       il.fq3
,       il.sep
,       il.oct
,       il.nov
,       il.dec
,       il.fq4
FROM(
SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "TRANSACTION"
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END AS "SORTKEY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JAN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FEB"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(1,2,3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FQ1"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "APR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(4,5,6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FQ2"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUL"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "AUG"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "SEP"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(7,8,9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FQ3"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "OCT"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "NOV"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "DEC"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FQ4"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END
ORDER BY SORTKEY) il;

-- Close log file.
SPOOL OFF
