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
--   sql> @apply_oracle_lab4.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab2/apply_oracle_lab2.sql
-- Do not run. Adds unnecessary records.
-- @/home/student/Data/cit225/oracle/lib/seed_oracle_store.sql

-- Add your lab here:
-- ----------------------------------------------------------------------
SPOOL apply_oracle_lab4.txt


-- ----------------------------------------------------------------------
-- Step 1: Add Users
-- ----------------------------------------------------------------------
INSERT INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( system_user_lab_s1.nextval
, 'REACHERJ'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'SYSTEM_USER_LAB'
        AND common_lookup_meaning = 'Database Administrator')
, (SELECT common_lookup_lab_id 
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE' 
        AND common_lookup_meaning = 'Home')
, 'Jack'
, 'Reacher'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( system_user_lab_s1.nextval
, 'OWENSR'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'SYSTEM_USER_LAB'
        AND common_lookup_meaning = 'Database Administrator')
, (SELECT common_lookup_lab_id 
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE' 
        AND common_lookup_meaning = 'Home')
, 'Ray'
, 'Owens'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 1
-- ----------------------------------------------------------------------
SELECT * FROM system_user_lab;

-- ----------------------------------------------------------------------
-- Step 2: Add Methods of Payment
-- ----------------------------------------------------------------------
INSERT INTO common_lookup_lab
( common_lookup_lab_id
, common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( common_lookup_lab_s1.nextval
, 'MEMBER_LAB'
, 'AMERICAN_EXPRESS_CARD'
, 'American Express Card'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO common_lookup_lab
( common_lookup_lab_id
, common_lookup_context
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( common_lookup_lab_s1.nextval
, 'MEMBER_LAB'
, 'DINERS_CLUB_CARD'
, 'Diners Club Card'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 2
-- ----------------------------------------------------------------------
SELECT   *
FROM     common_lookup_lab
WHERE    common_lookup_context = 'MEMBER_LAB'
AND      common_lookup_type IN ('AMERICAN_EXPRESS_CARD','DINERS_CLUB_CARD');

-- ----------------------------------------------------------------------
-- Step 3: Add Members
-- ----------------------------------------------------------------------
INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( member_lab_s1.nextval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'Individual Membership')
, 'X15-500-01'
, '9876-5432-1234-5678'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'American Express Card')
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( member_lab_s1.nextval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning ='Individual Membership')
, 'X15-500-02'
, '9876-5432-1234-5679'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'Diners Club Card')
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 3
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   m.member_lab_id
,        m.member_type
,        m.account_number
,        m.credit_card_number
,        cl.common_lookup_meaning AS credit_card_type
FROM     member_lab m INNER JOIN common_lookup_lab cl
ON       m.credit_card_type = cl.common_lookup_lab_id
WHERE    common_lookup_context = 'MEMBER_LAB'
AND      common_lookup_type IN ('AMERICAN_EXPRESS_CARD','DINERS_CLUB_CARD');


-- ----------------------------------------------------------------------
-- Step 4: Add Contacts
-- ----------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( contact_lab_s1.nextval
, (SELECT member_lab_id
        FROM member_lab 
        WHERE account_number = 'X15-500-01')
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'CONTACT_LAB'
        AND common_lookup_meaning = 'Customer')
, 'John'
, 'Jones'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( contact_lab_s1.nextval
, (SELECT member_lab_id
        FROM member_lab 
        WHERE account_number = 'X15-500-01')
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'CONTACT_LAB'
        AND common_lookup_meaning = 'Customer')
, 'Jane'
, 'Jones'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 4
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   c.contact_lab_id
,        m.credit_card_type
,        c.member_lab_id
,        c.contact_type
,        c.last_name
,        c.first_name
FROM     member_lab m INNER JOIN common_lookup_lab cl1
ON       m.credit_card_type = cl1.common_lookup_lab_id INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN common_lookup_lab cl2
ON       c.contact_type = cl2.common_lookup_lab_id
WHERE    cl1.common_lookup_context = 'MEMBER_LAB'
AND      cl1.common_lookup_type IN ('AMERICAN_EXPRESS_CARD','DINERS_CLUB_CARD')
AND      cl2.common_lookup_context = 'CONTACT_LAB'
AND      cl2.common_lookup_type = 'CUSTOMER';

-- ----------------------------------------------------------------------
-- Step 5: Add Addresses
-- ----------------------------------------------------------------------
INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( address_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'John' AND last_name = 'Jones') -- NO NATURAL KEY
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( address_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'Jane' AND last_name = 'Jones') -- NO NATURAL KEY
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 5
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   c.contact_lab_id
,        a.address_type
,        c.first_name
,        c.last_name
,        a.city
,        a.state_province
,        a.postal_code
FROM     contact_lab c INNER JOIN common_lookup_lab cl1
ON       c.contact_type = cl1.common_lookup_lab_id INNER JOIN address_lab a
ON       c.contact_lab_id = a.contact_lab_id INNER JOIN common_lookup_lab cl2
ON       a.address_type = cl2.common_lookup_lab_id
WHERE    cl1.common_lookup_context = 'CONTACT_LAB'
AND      cl1.common_lookup_type = 'CUSTOMER'
AND      cl2.common_lookup_context = 'MULTIPLE'
AND      cl2.common_lookup_type = 'HOME';

-- ----------------------------------------------------------------------
-- Step 6: Add Addresses
-- ----------------------------------------------------------------------
INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( street_address_lab_s1.nextval
, (SELECT address_lab_id
        FROM address_lab
        WHERE contact_lab_id = (SELECT contact_lab_id
                FROM contact_lab 
                WHERE first_name = 'John' AND last_name = 'Jones')) -- NO NATURAL KEY
, '372 East 12300 South'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( street_address_lab_s1.nextval
, (SELECT address_lab_id
        FROM address_lab
        WHERE contact_lab_id = (SELECT contact_lab_id
                FROM contact_lab 
                WHERE first_name = 'Jane' AND last_name = 'Jones')) -- NO NATURAL KEY
, '1872 West 5400 South'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 6
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   c.contact_lab_id
,        a.address_lab_id
,        a.address_type
,        c.first_name
,        c.last_name
,        sa.street_address
,        a.city
,        a.state_province
,        a.postal_code
FROM     contact_lab c INNER JOIN common_lookup_lab cl1
ON       c.contact_type = cl1.common_lookup_lab_id INNER JOIN address_lab a
ON       c.contact_lab_id = a.contact_lab_id INNER JOIN street_address_lab sa
ON       a.address_lab_id = sa.address_lab_id INNER JOIN common_lookup_lab cl2
ON       a.address_type = cl2.common_lookup_lab_id
WHERE    cl1.common_lookup_context = 'CONTACT_LAB'
AND      cl1.common_lookup_type = 'CUSTOMER'
AND      cl2.common_lookup_context = 'MULTIPLE'
AND      cl2.common_lookup_type = 'HOME';

-- ----------------------------------------------------------------------
-- Step 7: Add Phone Numbers
-- ----------------------------------------------------------------------
INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( telephone_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'John' AND last_name = 'Jones') -- NO NATURAL KEY
, (SELECT address_lab_id
        FROM address_lab
        WHERE contact_lab_id = (SELECT contact_lab_id
                FROM contact_lab 
                WHERE first_name = 'John' AND last_name = 'Jones')) -- NO NATURAL KEY
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, '001'
, '801'
, '435-7654'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( telephone_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'Jane' AND last_name = 'Jones') -- NO NATURAL KEY
, (SELECT address_lab_id
        FROM address_lab
        WHERE contact_lab_id = (SELECT contact_lab_id
                FROM contact_lab 
                WHERE first_name = 'Jane' AND last_name = 'Jones')) -- NO NATURAL KEY
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, '001'
, '801'
, '435-7655'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 7
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   c.contact_lab_id
,        t.telephone_lab_id
,        t.telephone_type
,        c.first_name
,        c.last_name
,        t.country_code
,        t.area_code
,        t.telephone_number
FROM     contact_lab c INNER JOIN telephone_lab t
ON       c.contact_lab_id = t.contact_lab_id
WHERE    c.first_name IN ('John','Jane')
AND      c.last_name = 'Jones';

-- ----------------------------------------------------------------------
-- Step 8: Add Rentals
-- ----------------------------------------------------------------------
INSERT INTO rental_lab
( rental_lab_id
, customer_lab_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'John' AND last_name = 'Jones') -- NO NATURAL KEY
, '02-JAN-2015'
, '06-JAN-2015'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_lab_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'Jane' AND last_name = 'Jones') -- NO NATURAL KEY
, '03-JAN-2015'
, '05-JAN-2015'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 8
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   r.rental_lab_id
,        r.customer_lab_id
,        r.check_out_date
,        r.return_date
FROM     rental_lab r 
WHERE    r.check_out_date IN ('02-JAN-2015','03-JAN-2015');

-- ----------------------------------------------------------------------
-- Step 9: Add Items
-- ----------------------------------------------------------------------
INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, 'B00N1JQ2UO'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'ITEM_LAB'
        AND common_lookup_meaning ='DVD: Wide Screen')
, 'Guardians of the Galaxy'
, 'PG-13'
, '09-DEC-14'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO item_lab
( item_lab_id
, item_barcode
, item_type
, item_title
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, 'B00OY7YPGK'
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'ITEM_LAB'
        AND common_lookup_meaning ='Blu-ray')
, 'The Maze Runner'
, 'PG-13'
, '16-DEC-14'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 9
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   i.item_lab_id
,        i.item_title
,        i.item_rating
,        i.item_release_date
FROM     item_lab i 
WHERE    i.item_release_date IN ('09-DEC-2014','16-DEC-2014');

-- ----------------------------------------------------------------------
-- Step 10: Add Rental Items
-- ----------------------------------------------------------------------
INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, (SELECT rental_lab_id
        FROM rental_lab
        WHERE customer_lab_id = (SELECT contact_lab_id -- NO NATURAL KEY
                FROM contact_lab 
                WHERE first_name = 'John' AND last_name = 'Jones')) -- NO NATURAL KEY
, (SELECT item_lab_id
        FROM item_lab
        WHERE item_barcode = 'B00N1JQ2UO')
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, (SELECT rental_lab_id
        FROM rental_lab
        WHERE customer_lab_id = (SELECT contact_lab_id -- NO NATURAL KEY
                FROM contact_lab 
                WHERE first_name = 'Jane' AND last_name = 'Jones')) -- NO NATURAL KEY
, (SELECT item_lab_id
        FROM item_lab
        WHERE item_barcode = 'B00OY7YPGK')
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verify Completion of Step 9
-- ----------------------------------------------------------------------
CLEAR COLUMNS
SELECT   ri.rental_item_lab_id
,        ri.rental_lab_id
,        ri.item_lab_id
FROM     rental_item_lab ri INNER JOIN rental_lab r
ON       r.rental_lab_id = ri.rental_lab_id INNER JOIN item_lab i
ON       i.item_lab_id = ri.item_lab_id
WHERE    r.rental_lab_id IN (SELECT   r.rental_lab_id
                             FROM     rental_lab r 
                             WHERE    r.check_out_date IN ('02-JAN-2015','03-JAN-2015'))
AND      i.item_lab_id IN (SELECT   i.item_lab_id
                           FROM     item_lab i
                           WHERE    item_title IN ('Guardians of the Galaxy','The Maze Runner')
                           AND      item_release_date IN ('09-DEC-2014','16-DEC-2014'));

-- ----------------------------------------------------------------------
-- Step 11: Process Order
-- ----------------------------------------------------------------------
-- Yondus Info
INSERT INTO member_lab
( member_lab_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( member_lab_s1.nextval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'Group Membership')
, 'X21-777-01'
, '9876-5432-1234-5678'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'Group Membership')
, 'Yondu'
, 'Udonta'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
, '12129 South State Street'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( telephone_lab_s1.nextval
, contact_lab_s1.currval
, address_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, '001'
, '801'
, '342-8940'
, 1
, SYSDATE
, 1
, SYSDATE);

-- Peters Info
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MEMBER_LAB'
        AND common_lookup_meaning = 'Group Membership')
, 'Peter'
, 'Quill'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO address_lab
( address_lab_id
, contact_lab_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, 'Draper'
, 'Utah'
, '84020'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address_lab
( street_address_lab_id
, address_lab_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
, '12129 South State Street'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO telephone_lab
( telephone_lab_id
, contact_lab_id
, address_lab_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( telephone_lab_s1.nextval
, contact_lab_s1.currval
, address_lab_s1.currval
, (SELECT common_lookup_lab_id
        FROM common_lookup_lab 
        WHERE common_lookup_context = 'MULTIPLE'
        AND common_lookup_meaning = 'Home')
, '001'
, '801'
, '342-8941'
, 1
, SYSDATE
, 1
, SYSDATE);


-- ----------------------------------------------------------------------
-- Verify Completion of Step 11 Accounts
-- ----------------------------------------------------------------------
SELECT   m.member_type
,        m.account_number
,        m.credit_card_number
,        m.credit_card_type
,        c.first_name
,        c.last_name
,        sa.street_address
,        a.city
,        a.state_province
,        a.postal_code
,        t.country_code||' ('||t.area_code||') '||t.telephone_number
FROM     member_lab m INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN address_lab a
ON       c.contact_lab_id = a.contact_lab_id INNER JOIN street_address_lab sa
ON       a.address_lab_id = sa.address_lab_id INNER JOIN telephone_lab t
ON       c.contact_lab_id = t.contact_lab_id
AND      a.address_lab_id = t.address_lab_id;

-- Add Rentals
INSERT INTO rental_lab
( rental_lab_id
, customer_lab_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'Yondu' AND last_name = 'Udonta') -- NO NATURAL KEY
, '08-JAN-2015'
, '12-JAN-2015'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, rental_lab_s1.currval
, (SELECT item_lab_id
        FROM item_lab
        WHERE item_barcode = 'B00N1JQ2UO')
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO rental_lab
( rental_lab_id
, customer_lab_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_lab_s1.nextval
, (SELECT contact_lab_id
        FROM contact_lab 
        WHERE first_name = 'Yondu' AND last_name = 'Udonta') -- NO NATURAL KEY
, '09-JAN-2015'
, '11-JAN-2015'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_lab_s1.nextval
, rental_lab_s1.currval
, (SELECT item_lab_id
        FROM item_lab
        WHERE item_barcode = 'B00OY7YPGK')
, 1
, SYSDATE
, 1
, SYSDATE);


-- ----------------------------------------------------------------------
-- Verify Completion of Step 11 Rentals
-- ----------------------------------------------------------------------
SELECT   r.check_out_date
,        r.return_date
,        ri.rental_item_lab_id
,        i.item_title
FROM     rental_lab r INNER JOIN rental_item_lab ri
ON       r.rental_lab_id = ri.rental_lab_id INNER JOIN item_lab i
ON       ri.item_lab_id = i.item_lab_id
WHERE    r.check_out_date IN ('08-JAN-2015','09-JAN-2015');


COMMIT;
 SPOOL OFF
