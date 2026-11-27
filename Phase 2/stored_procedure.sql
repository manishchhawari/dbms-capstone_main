
-- ==========================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: stored_procedure.sql
-- PHASE 2: STORED PROCEDURES
-- MySQL 8.0+
-- ==========================================

USE payroll_management;

DELIMITER $$

-- ==========================================
-- PROCEDURE 1: ADD NEW EMPLOYEE
-- ==========================================

DROP PROCEDURE IF EXISTS AddEmployee$$

CREATE PROCEDURE AddEmployee(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_department VARCHAR(50),
    IN p_designation VARCHAR(50),
    IN p_joining_date DATE
)
BEGIN
    IF p_first_name IS NULL OR TRIM(p_first_name) = ''
       OR p_last_name IS NULL OR TRIM(p_last_name) = ''
       OR p_email IS NULL OR TRIM(p_email) = ''
       OR p_department IS NULL OR TRIM(p_department) = ''
       OR p_joining_date IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Required employee details are missing';
    END IF;

    INSERT INTO Employee (
        first_name,
        last_name,
        email,
        phone,
        department,
        designation,
        joining_date
    )
    VALUES (
        p_first_name,
        p_last_name,
        p_email,
        p_phone,
        p_department,
        p_designation,
        p_joining_date
    );

    SELECT LAST_INSERT_ID() AS New_Employee_ID;
END$$


-- ==========================================
-- PROCEDURE 2: UPDATE EMPLOYEE SALARY
-- ==========================================

DROP PROCEDURE IF EXISTS UpdateSalary$$

CREATE PROCEDURE UpdateSalary(
    IN p_employee_id INT,
    IN p_basic_salary DECIMAL(12,2),
    IN p_hra DECIMAL(12,2),
    IN p_allowances DECIMAL(12,2),
    IN p_deductions DECIMAL(12,2),
    IN p_effective_from DATE
)
BEGIN
    DECLARE v_employee_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE employee_id = p_employee_id;

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    IF p_basic_salary IS NULL OR p_basic_salary < 0
       OR p_hra IS NULL OR p_hra < 0
       OR p_allowances IS NULL OR p_allowances < 0
       OR p_deductions IS NULL OR p_deductions < 0
       OR p_effective_from IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid salary details';
    END IF;

    INSERT INTO Salary (
        employee_id,
        basic_salary,
        hra,
        allowances,
        deductions,
        effective_from
    )
    VALUES (
        p_employee_id,
        p_basic_salary,
        p_hra,
        p_allowances,
        p_deductions,
        p_effective_from
    );

    SELECT 'Salary record added successfully' AS Message;
END$$


-- ==========================================
-- PROCEDURE 3: GENERATE MONTHLY PAYROLL
-- ==========================================

DROP PROCEDURE IF EXISTS GeneratePayroll$$

CREATE PROCEDURE GeneratePayroll(
    IN p_employee_id INT,
    IN p_payroll_month DATE
)
BEGIN
    DECLARE v_salary_id INT;
    DECLARE v_basic_salary DECIMAL(12,2);
    DECLARE v_hra DECIMAL(12,2);
    DECLARE v_allowances DECIMAL(12,2);
    DECLARE v_deductions DECIMAL(12,2);

    DECLARE v_gross_salary DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_total_deductions DECIMAL(12,2);
    DECLARE v_net_salary DECIMAL(12,2);

    DECLARE v_annual_income DECIMAL(12,2);
    DECLARE v_employee_count INT DEFAULT 0;

    -- Validate employee
    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE employee_id = p_employee_id
      AND employment_status = 'Active';

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Active employee not found';
    END IF;

    IF p_payroll_month IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payroll month is required';
    END IF;

    -- Find latest applicable salary record
    SELECT
        salary_id,
        basic_salary,
        hra,
        allowances,
        deductions
    INTO
        v_salary_id,
        v_basic_salary,
        v_hra,
        v_allowances,
        v_deductions
    FROM Salary
    WHERE employee_id = p_employee_id
      AND effective_from <= LAST_DAY(p_payroll_month)
    ORDER BY effective_from DESC
    LIMIT 1;

    -- Calculate gross salary
    SET v_gross_salary = CalculateGrossSalary(
        v_basic_salary,
        v_hra,
        v_allowances
    );

    -- Convert monthly gross salary into annual income
    SET v_annual_income = v_gross_salary * 12;

    -- Calculate monthly tax from annual tax
    SET v_tax = CalculateTax(v_annual_income) / 12;

    -- Calculate total deductions
    SET v_total_deductions = v_deductions + v_tax;

    -- Calculate net salary
    SET v_net_salary = v_gross_salary - v_total_deductions;

    IF v_net_salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Deductions cannot exceed gross salary';
    END IF;

    -- Insert payroll record
    INSERT INTO Payroll (
        employee_id,
        salary_id,
        payroll_month,
        gross_salary,
        tax_amount,
        total_deductions,
        net_salary,
        payment_status
    )
    VALUES (
        p_employee_id,
        v_salary_id,
        DATE_FORMAT(p_payroll_month, '%Y-%m-01'),
        v_gross_salary,
        v_tax,
        v_total_deductions,
        v_net_salary,
        'Pending'
    );

    SELECT
        p_employee_id AS Employee_ID,
        v_gross_salary AS Gross_Salary,
        v_tax AS Monthly_Tax,
        v_total_deductions AS Total_Deductions,
        v_net_salary AS Net_Salary,
        'Payroll generated successfully' AS Message;

END$$

DELIMITER ;


-- ==========================================
-- TEST PROCEDURES
-- ==========================================

-- Add employee example:
-- CALL AddEmployee(
--     'Rahul', 'Sharma', 'rahul@example.com',
--     '9876543210', 'IT', 'Developer', '2026-01-01'
-- );

-- Add salary example:
-- CALL UpdateSalary(
--     1, 40000, 10000, 5000, 2000, '2026-01-01'
-- );

-- Generate January 2026 payroll:
-- CALL GeneratePayroll(1, '2026-01-01');

-- View payroll:
-- SELECT * FROM Payroll;
