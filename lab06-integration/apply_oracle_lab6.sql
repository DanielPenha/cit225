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
--   sql> @apply_oracle_lab6.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
-- @/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

-- Call the setup scripts.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql
@/home/student/Data/cit225/oracle/lib/seed_oracle_store.sql

-- Open log file.
SPOOL apply_oracle_lab6.log

-- ------------------------------------------------------------------
-- Step 1a
-- ------------------------------------------------------------------
ALTER TABLE rental_item
ADD rental_item_price NUMBER
ADD rental_item_type NUMBER;

-- DO NOT ADD until new columns can be filled with data!
-- ------------------------------------------------------------------
-- ALTER TABLE rental_item
-- ADD CONSTRAINT nn_rental_item_7 NOT NULL(rental_item_price)
-- ADD CONSTRAINT fk_rental_item_5 FOREIGN KEY(rental_item_type) REFERENCES common_lookup(common_lookup_id)
-- ADD CONSTRAINT nn_rental_item_8 NOT NULL(rental_item_type);

-- ------------------------------------------------------------------
-- Verify Step 1a
-- ------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 2
-- ------------------------------------------------------------------
CREATE TABLE price
( price_id              NUMBER
, item_id               NUMBER      CONSTRAINT nn_price_1 NOT NULL
, price_type            NUMBER      
, active_flag           VARCHAR2(1) CONSTRAINT nn_price_2 NOT NULL
, start_date            DATE        CONSTRAINT nn_price_3 NOT NULL
, end_date              DATE        
, amount                NUMBER      CONSTRAINT nn_price_4 NOT NULL
, created_by            NUMBER      CONSTRAINT nn_price_5 NOT NULL
, creation_date         DATE        CONSTRAINT nn_price_6 NOT NULL
, last_updated_by       NUMBER      CONSTRAINT nn_price_7 NOT NULL
, last_updated_date     DATE        CONSTRAINT nn_price_8 NOT NULL
, CONSTRAINT pk_price_1 PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1 FOREIGN KEY(item_id) REFERENCES item(item_id)
, CONSTRAINT fk_price_2 FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT yn_price CHECK (active_flag IN('Y','N'))
, CONSTRAINT fk_price_3 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

-- ------------------------------------------------------------------
-- Verify Step 2a
-- ------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Verify Step 2b
-- ------------------------------------------------------------------
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- ------------------------------------------------------------------
-- Step 3a
-- ------------------------------------------------------------------
ALTER TABLE item
RENAME COLUMN item_release_date TO release_date;
-- ------------------------------------------------------------------
-- Verify Step 3a
-- ------------------------------------------------------------------
SET NULL ''
COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   TABLE_NAME
,        column_id
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS NULLABLE
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 3b
-- ------------------------------------------------------------------
INSERT INTO item VALUES
( item_s1.nextval
, '9973-16348-2'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'ITEM'
   AND common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Baywatch', NULL, 'R', (TRUNC(SYSDATE) - 1)
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
, '9973-16348-3'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'ITEM'
   AND common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Alien', 'Covenant', 'R', (TRUNC(SYSDATE) - 1)
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
, '9973-16348-4'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'ITEM'
   AND common_lookup_type = 'DVD_WIDE_SCREEN')
, 'King Arthur', 'Legend of the Sword', 'PG-13', (TRUNC(SYSDATE) - 1)
, 1, SYSDATE, 1, SYSDATE);

-- ------------------------------------------------------------------
-- Verify Step 3b
-- ------------------------------------------------------------------
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- ------------------------------------------------------------------
-- Step 3c
-- ------------------------------------------------------------------
INSERT INTO member VALUES
( member_s1.nextval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MEMBER'
   AND common_lookup_type = 'GROUP')
, 'R11-514-39'
, '1111-3333-1111-1111'
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MEMBER'
   AND common_lookup_type = 'VISA_CARD')
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
, 'Harry', NULL, 'Potter'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, 'Provo', 'Utah', '84602'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 'E Campus Dr.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, '1', '301', '422-4636'
, 1, SYSDATE, 1, SYSDATE);



INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
, 'Ginny', NULL, 'Potter'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, 'Provo', 'Utah', '84602'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 'E Campus Dr.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, '1', '301', '422-4636'
, 1, SYSDATE, 1, SYSDATE);


INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'CONTACT'
   AND common_lookup_type = 'CUSTOMER')
, 'Lily', 'Luna', 'Potter'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, 'Provo', 'Utah', '84602'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 'E Campus Dr.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_context = 'MULTIPLE'
   AND common_lookup_type = 'HOME')
, '1', '301', '422-4636'
, 1, SYSDATE, 1, SYSDATE);

-- ------------------------------------------------------------------
-- Verify Step 3c
-- ------------------------------------------------------------------
COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- ------------------------------------------------------------------
-- Step 3d
-- ------------------------------------------------------------------
INSERT INTO rental VALUES
( rental_s1.nextval
, (SELECT contact_id
   FROM contact
   WHERE first_name = 'Harry'
   AND last_name = 'Potter')
, SYSDATE, SYSDATE + 1
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO rental_item VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_barcode = '9973-16348-2')
, 1, SYSDATE, 1, SYSDATE
, NULL, NULL);

INSERT INTO rental_item VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_barcode = '24543-02392')
, 1, SYSDATE, 1, SYSDATE
, NULL, NULL);


INSERT INTO rental VALUES
( rental_s1.nextval
, (SELECT contact_id
   FROM contact
   WHERE first_name = 'Ginny'
   AND last_name = 'Potter')
, SYSDATE, SYSDATE + 3
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO rental_item VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_barcode = '9973-16348-3')
, 1, SYSDATE, 1, SYSDATE
, NULL, NULL);


INSERT INTO rental VALUES
( rental_s1.nextval
, (SELECT contact_id
   FROM contact
   WHERE first_name = 'Lily'
   AND last_name = 'Potter')
, SYSDATE, SYSDATE + 5
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO rental_item VALUES
( rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id
   FROM item
   WHERE item_barcode = '9973-16348-4')
, 1, SYSDATE, 1, SYSDATE
, NULL, NULL);

-- ------------------------------------------------------------------
-- Verify Step 3d
-- ------------------------------------------------------------------
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 4a
-- ------------------------------------------------------------------
DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;

-- ------------------------------------------------------------------
-- Verify Step 4a
-- ------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- ------------------------------------------------------------------
-- Step 4b
-- ------------------------------------------------------------------
ALTER TABLE common_lookup
ADD common_lookup_table VARCHAR2(30)
ADD common_lookup_column VARCHAR2(30)
ADD common_lookup_code VARCHAR2(30);

-- ------------------------------------------------------------------
-- Verify Step 4b
-- ------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 4c-1
-- ------------------------------------------------------------------
UPDATE common_lookup
SET common_lookup_table = 
    CASE
      WHEN common_lookup_context <> 'MULTIPLE' THEN
         common_lookup_context
      ELSE
        'ADDRESS'
       END -- end case statement
,   common_lookup_column = 
    CASE
      WHEN common_lookup_context <> 'MULTIPLE' THEN
         common_lookup_context || '_TYPE'
      ELSE
        'ADDRESS_TYPE'
       END;

UPDATE common_lookup
SET common_lookup_code = 
    CASE
      WHEN common_lookup_context <> 'MULTIPLE' THEN
         'Old'
      ELSE
        'New'
       END;

-- ------------------------------------------------------------------
-- Verify Step 4c-1
-- ------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 4c-2
-- ------------------------------------------------------------------
ALTER TABLE common_lookup
DROP CONSTRAINT nn_clookup_1;

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, NULL
, 'HOME'
, 'Home'
, 1, SYSDATE, 1, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'New');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, NULL
, 'WORK'
, 'Work'
, 1, SYSDATE, 1, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'New');

-- ------------------------------------------------------------------
-- Verify Step 4c-2
-- ------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A20
COLUMN common_lookup_column FORMAT A20
COLUMN common_lookup_type   FORMAT A20
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ------------------------------------------------------------------
-- Step 4c-3
-- ------------------------------------------------------------------
UPDATE telephone
SET telephone_type = 
CASE
  WHEN telephone_type = (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'ADDRESS'
     AND common_lookup_column = 'ADDRESS_TYPE'
     AND common_lookup_type = 'HOME') 
  THEN (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'TELEPHONE'
     AND common_lookup_column = 'TELEPHONE_TYPE'
     AND common_lookup_type = 'HOME')
  ELSE (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'TELEPHONE'
     AND common_lookup_column = 'TELEPHONE_TYPE'
     AND common_lookup_type = 'WORK')
  END;

-- ------------------------------------------------------------------
-- Verify Step 4c-3
-- ------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;


-- ------------------------------------------------------------------
-- Step 4d-1
-- ------------------------------------------------------------------
ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY common_lookup_table CONSTRAINT nn_clookup_8 NOT NULL
MODIFY common_lookup_column CONSTRAINT nn_clookup_9 NOT NULL;

-- ------------------------------------------------------------------
-- Verify Step 4d-1
-- ------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ------------------------------------------------------------------
-- Step 4d-2
-- ------------------------------------------------------------------
CREATE UNIQUE INDEX common_lookup_u2
  ON common_lookup(common_lookup_table,common_lookup_column,common_lookup_type);

-- ------------------------------------------------------------------
-- Verify Step 4d-2
-- ------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';



-- Commit inserted records.
COMMIT;

-- Close log file.
SPOOL OFF
