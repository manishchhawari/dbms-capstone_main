
-- =============================================
-- TEST CASES
-- DBMS CAPSTONE PROJECT
-- =============================================

USE employee_management;

-- TEST CASE 1: Verify Database Tables
SHOW TABLES;

-- TEST CASE 2: Check Employee Records
SELECT * FROM employee;

-- TEST CASE 3: Check Department Records
SELECT * FROM department;

-- TEST CASE 4: Check Attendance Records
SELECT * FROM attendance;

-- TEST CASE 5: Check Salary Records
SELECT * FROM salary;

-- TEST CASE 6: Test INSERT Operation
INSERT INTO department (department_name)
VALUES ('Testing Department');

-- TEST CASE 7: Test UPDATE Operation
UPDATE department
SET department_name = 'Quality Assurance'
WHERE department_name = 'Testing Department';

-- TEST CASE 8: Test DELETE Operation
DELETE FROM department
WHERE department_name = 'Quality Assurance';

-- TEST CASE 9: Test WHERE Condition
SELECT *
FROM employee
WHERE employee_id > 0;

-- TEST CASE 10: Test Aggregate Functions
SELECT
    COUNT(*) AS total_employees,
    AVG(salary_amount) AS average_salary,
    MAX(salary_amount) AS highest_salary,
    MIN(salary_amount) AS lowest_salary
FROM salary;

-- TEST CASE 11: Test GROUP BY
SELECT department_id, COUNT(*) AS employee_count
FROM employee
GROUP BY department_id;

-- TEST CASE 12: Test JOIN
SELECT
    e.employee_id,
    e.employee_name,
    d.department_name
FROM employee e
JOIN department d
ON e.department_id = d.department_id;

-- TEST CASE 13: Test Subquery
SELECT *
FROM employee
WHERE employee_id IN (
    SELECT employee_id
    FROM salary
    WHERE salary_amount > (
        SELECT AVG(salary_amount)
        FROM salary
    )
);

-- TEST CASE 14: Test Transaction
START TRANSACTION;

UPDATE employee
SET employee_name = employee_name
WHERE employee_id = 1;

ROLLBACK;

-- TEST CASE 15: Test Constraint Validation
-- Expected: Duplicate primary key should fail.
-- Run separately after checking employee_id = 1 exists.

-- INSERT INTO employee
-- (employee_id, employee_name, department_id)
-- VALUES (1, 'Duplicate Test', 1);

-- TEST CASE 16: Verify Indexes
SHOW INDEX FROM employee;

-- TEST CASE 17: Verify Stored Procedures
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

-- TEST CASE 18: Verify Triggers
SHOW TRIGGERS;

-- TEST CASE 19: Verify Views
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- TEST CASE 20: Query Execution Plan
EXPLAIN
SELECT *
FROM employee
WHERE employee_id = 1;

-- =============================================
-- END OF TEST_CASE.SQL
-- =============================================
