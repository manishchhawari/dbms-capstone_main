
-- ==================================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: salary_slip.sql
-- PHASE 3: SALARY SLIP REPORT
-- MySQL 8.0+
-- ==================================================

USE payroll_management;

-- ==================================================
-- 1. SALARY SLIP FOR A PARTICULAR EMPLOYEE
-- Change employee ID and month as required
-- ==================================================

SET @employee_id = 1;
SET @payroll_month = '2026-01-01';

SELECT
    p.payroll_id,
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    e.department,
    e.designation,

    DATE_FORMAT(p.payroll_month, '%M %Y')
        AS salary_month,

    s.basic_salary,
    s.hra,
    s.allowances,

    p.gross_salary,
    p.tax_amount,
    s.deductions AS other_deductions,

    p.total_deductions,
    p.net_salary,

    p.payment_status,
    p.payment_date

FROM Payroll p

INNER JOIN Employee e
    ON p.employee_id = e.employee_id

INNER JOIN Salary s
    ON p.salary_id = s.salary_id

WHERE p.employee_id = @employee_id
  AND p.payroll_month = @payroll_month;


-- ==================================================
-- 2. ALL EMPLOYEES SALARY SLIP FOR A PARTICULAR MONTH
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    e.department,

    DATE_FORMAT(p.payroll_month, '%M %Y')
        AS salary_month,

    p.gross_salary,
    p.tax_amount,
    p.total_deductions,
    p.net_salary,
    p.payment_status

FROM Payroll p

INNER JOIN Employee e
    ON p.employee_id = e.employee_id

WHERE p.payroll_month = '2026-01-01'

ORDER BY e.employee_id;


-- ==================================================
-- 3. EMPLOYEE SALARY HISTORY
-- ==================================================

SET @history_employee_id = 1;

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    s.basic_salary,
    s.hra,
    s.allowances,
    s.deductions,

    s.effective_from

FROM Salary s

INNER JOIN Employee e
    ON s.employee_id = e.employee_id

WHERE s.employee_id = @history_employee_id

ORDER BY s.effective_from DESC;


-- ==================================================
-- 4. MONTHLY PAYROLL SUMMARY
-- ==================================================

SELECT
    DATE_FORMAT(payroll_month, '%M %Y')
        AS payroll_month,

    COUNT(*) AS total_employees,

    SUM(gross_salary) AS total_gross_salary,

    SUM(tax_amount) AS total_tax,

    SUM(total_deductions) AS total_deductions,

    SUM(net_salary) AS total_net_salary

FROM Payroll

GROUP BY
    YEAR(payroll_month),
    MONTH(payroll_month)

ORDER BY
    YEAR(payroll_month),
    MONTH(payroll_month);


-- ==================================================
-- 5. PENDING SALARY PAYMENTS
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    p.payroll_month,
    p.net_salary,
    p.payment_status

FROM Payroll p

INNER JOIN Employee e
    ON p.employee_id = e.employee_id

WHERE p.payment_status = 'Pending'

ORDER BY p.payroll_month;


-- ==================================================
-- 6. TOTAL SALARY PAID TO EACH EMPLOYEE
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    COUNT(p.payroll_id) AS total_payroll_records,

    SUM(
        CASE
            WHEN p.payment_status = 'Paid'
            THEN p.net_salary
            ELSE 0
        END
    ) AS total_salary_paid

FROM Employee e

LEFT JOIN Payroll p
    ON e.employee_id = p.employee_id

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name

ORDER BY total_salary_paid DESC;
