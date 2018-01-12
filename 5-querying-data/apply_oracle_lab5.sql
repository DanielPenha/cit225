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
--   sql> @apply_oracle_lab5.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
-- @/home/student/Data/cit225/oracle/lab4/apply_oracle_lab4.sql

-- Add your lab here:
-- ----------------------------------------------------------------------
SPOOL apply_oracle_lab5.txt
-- ----------------------------------------------------------------------
-- Step 1a
-- ----------------------------------------------------------------------
SELECT member_id, contact_id
FROM contact
JOIN member
USING (member_id);

-- ----------------------------------------------------------------------
-- Step 1b
-- ----------------------------------------------------------------------
SELECT contact_id, address_id
FROM address
JOIN contact
USING (contact_id);

-- ----------------------------------------------------------------------
-- Step 1c
-- ----------------------------------------------------------------------
SELECT address_id, street_address_id
FROM street_address
JOIN address
USING (address_id);

-- ----------------------------------------------------------------------
-- Step 2a
-- ----------------------------------------------------------------------
SELECT c.contact_id, s.system_user_id
FROM contact c
JOIN system_user s
ON c.created_by = s.system_user_id;

-- ----------------------------------------------------------------------
-- Step 2b
-- ----------------------------------------------------------------------
SELECT c.contact_id, s.system_user_id
FROM contact c
JOIN system_user s
ON c.last_updated_by = s.system_user_id;

-- ----------------------------------------------------------------------
-- Step 3a
-- ----------------------------------------------------------------------
SELECT   s1.system_user_id
,        s1.created_by
,        s2.system_user_id
FROM     system_user s1
JOIN     system_user s2
ON       s1.created_by = s2.system_user_id;

-- ----------------------------------------------------------------------
-- Step 3b
-- ----------------------------------------------------------------------
SELECT   s1.system_user_id
,        s1.last_updated_by
,        s2.system_user_id
FROM     system_user s1
JOIN     system_user s2
ON       s1.last_updated_by = s2.system_user_id;

-- ----------------------------------------------------------------------
-- Step 3c
-- ----------------------------------------------------------------------
SELECT   s1.system_user_name AS "System User"
,        s1.system_user_id AS "System ID"
,        s2.system_user_name AS "Created User"
,        s2.system_user_id AS "Created By"
,        s3.system_user_name AS "Updated User"
,        s3.system_user_id AS "Updated By"
FROM     system_user s1
JOIN     system_user s2
ON       s1.created_by = s2.system_user_id
JOIN     system_user s3
ON       s1.last_updated_by = s3.system_user_id;

-- ----------------------------------------------------------------------
-- Step 4
-- ----------------------------------------------------------------------
SELECT   r.rental_id
,        ri.rental_id
,        ri.item_id
,        i.item_id
FROM     rental_item ri
JOIN     rental r
ON       ri.rental_id = r.rental_id
JOIN     item i
ON       ri.item_id = i.item_id;

ALTER TABLE rental DROP CONSTRAINT nn_rental_3;

COMMIT;

SPOOL OFF;
