
-- =============================================
-- TRANSACTION MANAGEMENT
-- DBMS CAPSTONE PROJECT
-- =============================================

USE employee_management;

-- 1. START TRANSACTION
START TRANSACTION;

-- 2. UPDATE EMPLOYEE DETAILS
UPDATE employee
SET employee_name = 'Updated Employee'
WHERE employee_id = 1;

-- Verify Update
SELECT *
FROM employee
WHERE employee_id = 1;

-- 3. COMMIT TRANSACTION
-- Permanently saves changes
COMMIT;


-- =============================================
-- 4. ROLLBACK TRANSACTION
-- =============================================

START TRANSACTION;

UPDATE employee
SET employee_name = 'Temporary Employee'
WHERE employee_id = 1;

-- Verify Temporary Change
SELECT *
FROM employee
WHERE employee_id = 1;

-- Undo Changes
ROLLBACK;


-- =============================================
-- 5. SAVEPOINT DEMONSTRATION
-- =============================================

START TRANSACTION;

-- First Update
UPDATE employee
SET employee_name = 'Employee One'
WHERE employee_id = 1;

-- Create Savepoint
SAVEPOINT sp1;

-- Second Update
UPDATE employee
SET employee_name = 'Employee Two'
WHERE employee_id = 2;

-- Create Another Savepoint
SAVEPOINT sp2;

-- Third Update
UPDATE employee
SET employee_name = 'Employee Three'
WHERE employee_id = 3;

-- Rollback to Second Savepoint
ROLLBACK TO SAVEPOINT sp2;

-- Verify Changes
SELECT *
FROM employee
WHERE employee_id IN (1, 2, 3);

-- Save Remaining Changes
COMMIT;


-- =============================================
-- 6. MULTIPLE OPERATIONS TRANSACTION
-- =============================================

START TRANSACTION;

UPDATE salary
SET salary_amount = salary_amount + 1000
WHERE employee_id = 1;

UPDATE attendance
SET status = 'Present'
WHERE employee_id = 1
AND attendance_date = CURRENT_DATE;

-- Verify Operations
SELECT * FROM salary
WHERE employee_id = 1;

SELECT * FROM attendance
WHERE employee_id = 1
AND attendance_date = CURRENT_DATE;

-- Save Transaction
COMMIT;


-- =============================================
-- 7. TRANSACTION STATUS VERIFICATION
-- =============================================

SELECT @@autocommit AS autocommit_status;

-- =============================================
-- END OF TRANSACTION.SQL
-- =============================================
