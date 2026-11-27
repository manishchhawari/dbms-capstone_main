
-- =============================================
-- ROLE AND PERMISSION MANAGEMENT
-- DBMS CAPSTONE PROJECT
-- =============================================

-- 1. Create Roles
CREATE ROLE IF NOT EXISTS 'admin_role';
CREATE ROLE IF NOT EXISTS 'hr_role';
CREATE ROLE IF NOT EXISTS 'employee_role';

-- 2. Admin Permissions
GRANT ALL PRIVILEGES
ON employee_management.*
TO 'admin_role';

-- 3. HR Permissions
GRANT SELECT, INSERT, UPDATE
ON employee_management.employee
TO 'hr_role';

GRANT SELECT, INSERT, UPDATE
ON employee_management.attendance
TO 'hr_role';

GRANT SELECT, INSERT, UPDATE
ON employee_management.salary
TO 'hr_role';

GRANT SELECT
ON employee_management.department
TO 'hr_role';

-- 4. Employee Permissions
GRANT SELECT
ON employee_management.employee
TO 'employee_role';

GRANT SELECT
ON employee_management.attendance
TO 'employee_role';

GRANT SELECT
ON employee_management.salary
TO 'employee_role';

-- 5. Create Database Users
CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
IDENTIFIED BY 'Admin@123';

CREATE USER IF NOT EXISTS 'hr_user'@'localhost'
IDENTIFIED BY 'HR@123';

CREATE USER IF NOT EXISTS 'employee_user'@'localhost'
IDENTIFIED BY 'Employee@123';

-- 6. Assign Roles to Users
GRANT 'admin_role' TO 'admin_user'@'localhost';

GRANT 'hr_role' TO 'hr_user'@'localhost';

GRANT 'employee_role' TO 'employee_user'@'localhost';

-- 7. Set Default Roles
SET DEFAULT ROLE 'admin_role'
TO 'admin_user'@'localhost';

SET DEFAULT ROLE 'hr_role'
TO 'hr_user'@'localhost';

SET DEFAULT ROLE 'employee_role'
TO 'employee_user'@'localhost';

-- 8. Verify Permissions
SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'hr_user'@'localhost';
SHOW GRANTS FOR 'employee_user'@'localhost';

-- =============================================
-- END OF ROLE_PERMISSION.SQL
-- =============================================
