
-- ==================================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: sample_data.sql
-- PHASE 2: SAMPLE DATA
-- MySQL 8.0+
-- ==================================================

USE payroll_management;

-- ==================================================
-- 1. EMPLOYEE DATA (10 EMPLOYEES)
-- ==================================================

INSERT INTO Employee
(first_name, last_name, email, phone, department,
 designation, joining_date, employment_status)
VALUES
('Aarav', 'Sharma', 'aarav@company.com', '9876543210',
 'IT', 'Software Developer', '2024-01-10', 'Active'),

('Ananya', 'Verma', 'ananya@company.com', '9876543211',
 'HR', 'HR Executive', '2024-02-15', 'Active'),

('Rohan', 'Gupta', 'rohan@company.com', '9876543212',
 'Finance', 'Accountant', '2023-06-20', 'Active'),

('Priya', 'Singh', 'priya@company.com', '9876543213',
 'IT', 'Frontend Developer', '2024-03-12', 'Active'),

('Karan', 'Mehta', 'karan@company.com', '9876543214',
 'Marketing', 'Marketing Executive', '2023-08-01', 'Active'),

('Ishita', 'Kapoor', 'ishita@company.com', '9876543215',
 'IT', 'Backend Developer', '2024-04-05', 'Active'),

('Aditya', 'Mishra', 'aditya@company.com', '9876543216',
 'Finance', 'Financial Analyst', '2023-11-18', 'Active'),

('Sneha', 'Patel', 'sneha@company.com', '9876543217',
 'HR', 'HR Manager', '2022-09-25', 'Active'),

('Rahul', 'Yadav', 'rahul@company.com', '9876543218',
 'IT', 'Database Administrator', '2024-05-15', 'Active'),

('Meera', 'Joshi', 'meera@company.com', '9876543219',
 'Marketing', 'Marketing Manager', '2022-07-10', 'Active');


-- ==================================================
-- 2. SALARY DATA
-- ==================================================

INSERT INTO Salary
(employee_id, basic_salary, hra, allowances,
 deductions, effective_from)
VALUES
(1, 40000, 10000, 5000, 2000, '2025-01-01'),
(2, 35000, 8000, 4000, 1500, '2025-01-01'),
(3, 45000, 12000, 5000, 2500, '2025-01-01'),
(4, 38000, 9000, 4000, 1800, '2025-01-01'),
(5, 30000, 7000, 3000, 1200, '2025-01-01'),
(6, 42000, 11000, 5000, 2200, '2025-01-01'),
(7, 48000, 13000, 6000, 3000, '2025-01-01'),
(8, 55000, 15000, 7000, 3500, '2025-01-01'),
(9, 50000, 14000, 6000, 2800, '2025-01-01'),
(10, 60000, 18000, 8000, 4000, '2025-01-01');


-- ==================================================
-- 3. ATTENDANCE DATA (JANUARY 2026)
-- ==================================================

INSERT INTO Attendance
(employee_id, attendance_date, check_in, check_out,
 status, late_minutes)
VALUES
(1, '2026-01-01', '09:00:00', '17:00:00', 'Present', 0),
(2, '2026-01-01', '09:15:00', '17:00:00', 'Present', 15),
(3, '2026-01-01', '09:00:00', '17:00:00', 'Present', 0),
(4, '2026-01-01', '09:30:00', '17:00:00', 'Present', 30),
(5, '2026-01-01', NULL, NULL, 'Absent', 0),
(6, '2026-01-01', '09:00:00', '17:00:00', 'Present', 0),
(7, '2026-01-01', '09:10:00', '17:00:00', 'Present', 10),
(8, '2026-01-01', '09:00:00', '17:00:00', 'Present', 0),
(9, '2026-01-01', '09:20:00', '17:00:00', 'Present', 20),
(10, '2026-01-01', '09:00:00', '17:00:00', 'Present', 0);


-- ==================================================
-- 4. ATTENDANCE DATA (FEBRUARY 2026)
-- ==================================================

INSERT INTO Attendance
(employee_id, attendance_date, check_in, check_out,
 status, late_minutes)
VALUES
(1, '2026-02-01', '09:00:00', '17:00:00', 'Present', 0),
(2, '2026-02-01', '09:25:00', '17:00:00', 'Present', 25),
(3, '2026-02-01', '09:00:00', '17:00:00', 'Present', 0),
(4, '2026-02-01', NULL, NULL, 'Absent', 0),
(5, '2026-02-01', '09:10:00', '17:00:00', 'Present', 10),
(6, '2026-02-01', '09:00:00', '17:00:00', 'Present', 0),
(7, '2026-02-01', '09:00:00', '17:00:00', 'Present', 0),
(8, '2026-02-01', '09:15:00', '17:00:00', 'Present', 15),
(9, '2026-02-01', '09:00:00', '17:00:00', 'Present', 0),
(10, '2026-02-01', NULL, NULL, 'Absent', 0);


-- ==================================================
-- 5. ATTENDANCE DATA (MARCH 2026)
-- ==================================================

INSERT INTO Attendance
(employee_id, attendance_date, check_in, check_out,
 status, late_minutes)
VALUES
(1, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0),
(2, '2026-03-01', '09:10:00', '17:00:00', 'Present', 10),
(3, '2026-03-01', NULL, NULL, 'Absent', 0),
(4, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0),
(5, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0),
(6, '2026-03-01', '09:30:00', '17:00:00', 'Present', 30),
(7, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0),
(8, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0),
(9, '2026-03-01', '09:15:00', '17:00:00', 'Present', 15),
(10, '2026-03-01', '09:00:00', '17:00:00', 'Present', 0);


-- ==================================================
-- 6. LEAVE REQUEST DATA
-- ==================================================

INSERT INTO Leave_Request
(employee_id, leave_type, start_date, end_date,
 reason, leave_status)
VALUES
(1, 'Casual', '2026-01-10', '2026-01-11',
 'Personal work', 'Approved'),

(2, 'Sick', '2026-02-05', '2026-02-06',
 'Health reasons', 'Approved'),

(3, 'Earned', '2026-03-10', '2026-03-12',
 'Family function', 'Pending'),

(4, 'Casual', '2026-01-15', '2026-01-15',
 'Personal work', 'Rejected'),

(5, 'Sick', '2026-03-05', '2026-03-06',
 'Medical reasons', 'Approved');


-- ==================================================
-- 7. USER ACCOUNT DATA
-- DEMO PASSWORD HASHES ARE PLACEHOLDERS.
-- Replace with actual bcrypt hashes before login.
-- ==================================================

INSERT INTO User_Account
(employee_id, role_id, username, password_hash)
VALUES
(1, 3, 'aarav', 'REPLACE_WITH_BCRYPT_HASH'),
(2, 2, 'ananya', 'REPLACE_WITH_BCRYPT_HASH'),
(3, 3, 'rohan', 'REPLACE_WITH_BCRYPT_HASH'),
(4, 3, 'priya', 'REPLACE_WITH_BCRYPT_HASH'),
(5, 3, 'karan', 'REPLACE_WITH_BCRYPT_HASH'),
(6, 3, 'ishita', 'REPLACE_WITH_BCRYPT_HASH'),
(7, 3, 'aditya', 'REPLACE_WITH_BCRYPT_HASH'),
(8, 3, 'sneha', 'REPLACE_WITH_BCRYPT_HASH'),
(9, 3, 'rahul', 'REPLACE_WITH_BCRYPT_HASH'),
(10, 3, 'meera', 'REPLACE_WITH_BCRYPT_HASH');


-- ==================================================
-- 8. VERIFY SAMPLE DATA
-- ==================================================

SELECT * FROM Employee;

SELECT * FROM Salary;

SELECT * FROM Attendance;

SELECT * FROM Leave_Request;

SELECT * FROM User_Account;

SELECT COUNT(*) AS Total_Employees
FROM Employee;

SELECT COUNT(*) AS Total_Attendance_Records
FROM Attendance;
