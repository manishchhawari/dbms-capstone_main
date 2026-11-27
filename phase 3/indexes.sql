
-- ==================================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: indexes.sql
-- PHASE 3: DATABASE INDEXING
-- MySQL 8.0+
-- ==================================================

USE payroll_management;

-- ==================================================
-- 1. ATTENDANCE INDEXES
-- ==================================================

-- Search attendance records by employee
CREATE INDEX idx_attendance_employee
ON Attendance(employee_id);

-- Search attendance by date
CREATE INDEX idx_attendance_date
ON Attendance(attendance_date);

-- Employee-wise monthly attendance reports
CREATE INDEX idx_attendance_employee_date
ON Attendance(employee_id, attendance_date);

-- Find late attendance records quickly
CREATE INDEX idx_attendance_late
ON Attendance(late_minutes);


-- ==================================================
-- 2. EMPLOYEE INDEXES
-- ==================================================

-- Search employees by department
CREATE INDEX idx_employee_department
ON Employee(department);

-- Search active employees
CREATE INDEX idx_employee_status
ON Employee(employment_status);


-- ==================================================
-- 3. SALARY INDEXES
-- ==================================================

-- Search salary records by employee
CREATE INDEX idx_salary_employee
ON Salary(employee_id);

-- Find latest applicable salary
CREATE INDEX idx_salary_employee_effective
ON Salary(employee_id, effective_from);


-- ==================================================
-- 4. PAYROLL INDEXES
-- ==================================================

-- Search payroll by employee
CREATE INDEX idx_payroll_employee
ON Payroll(employee_id);

-- Monthly payroll reports
CREATE INDEX idx_payroll_month
ON Payroll(payroll_month);

-- Search payment status
CREATE INDEX idx_payroll_status
ON Payroll(payment_status);


-- ==================================================
-- 5. LEAVE INDEXES
-- ==================================================

-- Search leave records by employee
CREATE INDEX idx_leave_employee
ON Leave_Request(employee_id);

-- Search leave by date range
CREATE INDEX idx_leave_dates
ON Leave_Request(start_date, end_date);

-- Find approved leaves
CREATE INDEX idx_leave_status
ON Leave_Request(leave_status);


-- ==================================================
-- 6. VERIFY CREATED INDEXES
-- ==================================================

SHOW INDEX FROM Attendance;

SHOW INDEX FROM Employee;

SHOW INDEX FROM Salary;

SHOW INDEX FROM Payroll;

SHOW INDEX FROM Leave_Request;
