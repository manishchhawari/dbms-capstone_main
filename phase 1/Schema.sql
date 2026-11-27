
-- ==========================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- PHASE 1: DATABASE SCHEMA
-- ==========================================

CREATE DATABASE IF NOT EXISTS payroll_management;

USE payroll_management;

-- 1. EMPLOYEE TABLE
CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    department VARCHAR(50) NOT NULL,
    designation VARCHAR(50),
    joining_date DATE NOT NULL,
    employment_status ENUM('Active', 'Inactive')
        DEFAULT 'Active'
);

-- 2. ATTENDANCE TABLE
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    status ENUM('Present', 'Absent', 'Half-Day', 'Leave')
        NOT NULL,
    late_minutes INT DEFAULT 0,

    CONSTRAINT fk_attendance_employee
        FOREIGN KEY (employee_id)
        REFERENCES Employee(employee_id),

    CONSTRAINT uq_employee_attendance
        UNIQUE (employee_id, attendance_date),

    CONSTRAINT chk_late_minutes
        CHECK (late_minutes >= 0)
);

-- 3. LEAVE TABLE
CREATE TABLE Leave_Request (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type ENUM('Casual', 'Sick', 'Earned', 'Unpaid')
        NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255),
    leave_status ENUM('Pending', 'Approved', 'Rejected')
        DEFAULT 'Pending',

    CONSTRAINT fk_leave_employee
        FOREIGN KEY (employee_id)
        REFERENCES Employee(employee_id),

    CONSTRAINT chk_leave_dates
        CHECK (end_date >= start_date)
);

-- 4. SALARY TABLE
CREATE TABLE Salary (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    basic_salary DECIMAL(12,2) NOT NULL,
    hra DECIMAL(12,2) DEFAULT 0,
    allowances DECIMAL(12,2) DEFAULT 0,
    deductions DECIMAL(12,2) DEFAULT 0,
    effective_from DATE NOT NULL,

    CONSTRAINT fk_salary_employee
        FOREIGN KEY (employee_id)
        REFERENCES Employee(employee_id),

    CONSTRAINT chk_basic_salary
        CHECK (basic_salary >= 0),

    CONSTRAINT chk_hra
        CHECK (hra >= 0),

    CONSTRAINT chk_allowances
        CHECK (allowances >= 0),

    CONSTRAINT chk_deductions
        CHECK (deductions >= 0),

    CONSTRAINT uq_employee_salary_date
        UNIQUE (employee_id, effective_from)
);

-- 5. PAYROLL TABLE
CREATE TABLE Payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    salary_id INT NOT NULL,
    payroll_month DATE NOT NULL,
    gross_salary DECIMAL(12,2) NOT NULL,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    total_deductions DECIMAL(12,2) DEFAULT 0,
    net_salary DECIMAL(12,2) NOT NULL,
    payment_status ENUM('Pending', 'Paid')
        DEFAULT 'Pending',
    payment_date DATE,

    CONSTRAINT fk_payroll_employee
        FOREIGN KEY (employee_id)
        REFERENCES Employee(employee_id),

    CONSTRAINT fk_payroll_salary
        FOREIGN KEY (salary_id)
        REFERENCES Salary(salary_id),

    CONSTRAINT uq_employee_payroll_month
        UNIQUE (employee_id, payroll_month),

    CONSTRAINT chk_gross_salary
        CHECK (gross_salary >= 0),

    CONSTRAINT chk_net_salary
        CHECK (net_salary >= 0)
);

-- 6. ROLE TABLE
CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE
);

-- 7. USER ACCOUNT TABLE
CREATE TABLE User_Account (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    role_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    CONSTRAINT fk_user_employee
        FOREIGN KEY (employee_id)
        REFERENCES Employee(employee_id),

    CONSTRAINT fk_user_role
        FOREIGN KEY (role_id)
        REFERENCES Role(role_id)
);

-- DEFAULT ROLES
INSERT INTO Role (role_name)
VALUES ('Admin'), ('HR'), ('Employee');
