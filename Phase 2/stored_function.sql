
-- ==========================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: stored_function.sql
-- PHASE 2: STORED FUNCTIONS
-- MySQL 8.0+
-- ==========================================

USE payroll_management;

DELIMITER $$

-- ==========================================
-- FUNCTION 1: CALCULATE GROSS SALARY
-- Basic Salary + HRA + Allowances
-- ==========================================

DROP FUNCTION IF EXISTS CalculateGrossSalary$$

CREATE FUNCTION CalculateGrossSalary(
    p_basic_salary DECIMAL(12,2),
    p_hra DECIMAL(12,2),
    p_allowances DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_gross_salary DECIMAL(12,2);

    IF p_basic_salary IS NULL
       OR p_hra IS NULL
       OR p_allowances IS NULL
       OR p_basic_salary < 0
       OR p_hra < 0
       OR p_allowances < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary components cannot be NULL or negative';
    END IF;

    SET v_gross_salary =
        p_basic_salary + p_hra + p_allowances;

    RETURN v_gross_salary;
END$$


-- ==========================================
-- FUNCTION 2: CALCULATE TAX
-- Simplified educational tax calculation
-- ==========================================

DROP FUNCTION IF EXISTS CalculateTax$$

CREATE FUNCTION CalculateTax(
    p_annual_income DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_tax DECIMAL(12,2);

    IF p_annual_income IS NULL OR p_annual_income < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Annual income cannot be NULL or negative';
    END IF;

    -- Simplified illustrative tax slabs
    IF p_annual_income <= 300000 THEN
        SET v_tax = 0;

    ELSEIF p_annual_income <= 600000 THEN
        SET v_tax = (p_annual_income - 300000) * 0.05;

    ELSEIF p_annual_income <= 900000 THEN
        SET v_tax = 15000 +
                    (p_annual_income - 600000) * 0.10;

    ELSEIF p_annual_income <= 1200000 THEN
        SET v_tax = 45000 +
                    (p_annual_income - 900000) * 0.15;

    ELSE
        SET v_tax = 90000 +
                    (p_annual_income - 1200000) * 0.20;
    END IF;

    RETURN v_tax;
END$$

DELIMITER ;


-- ==========================================
-- TEST STORED FUNCTIONS
-- ==========================================

SELECT CalculateGrossSalary(40000, 10000, 5000)
AS Gross_Salary;

SELECT CalculateTax(800000)
AS Annual_Tax;
