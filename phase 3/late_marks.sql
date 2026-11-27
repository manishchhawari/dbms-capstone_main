
-- ==================================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: late_marks_report.sql
-- PHASE 3: LATE MARKS REPORT
-- MySQL 8.0+
-- ==================================================

USE payroll_management;

-- ==================================================
-- 1. COMPLETE LATE MARKS REPORT
-- Shows all employees who arrived late
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    e.department,

    a.attendance_date,
    a.check_in,
    a.late_minutes

FROM Attendance a

INNER JOIN Employee e
    ON a.employee_id = e.employee_id

WHERE a.late_minutes > 0

ORDER BY a.attendance_date, a.late_minutes DESC;


-- ==================================================
-- 2. EMPLOYEE-WISE LATE ATTENDANCE SUMMARY
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    e.department,

    COUNT(a.attendance_id) AS total_late_days,

    SUM(a.late_minutes) AS total_late_minutes,

    ROUND(AVG(a.late_minutes), 2)
        AS average_late_minutes

FROM Employee e

INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE a.late_minutes > 0

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department

ORDER BY total_late_minutes DESC;


-- ==================================================
-- 3. MONTHLY LATE MARKS REPORT
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    DATE_FORMAT(a.attendance_date, '%M %Y')
        AS report_month,

    COUNT(*) AS late_days,

    SUM(a.late_minutes) AS total_late_minutes

FROM Employee e

INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE a.late_minutes > 0

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    YEAR(a.attendance_date),
    MONTH(a.attendance_date)

ORDER BY
    YEAR(a.attendance_date),
    MONTH(a.attendance_date),
    total_late_minutes DESC;


-- ==================================================
-- 4. DEPARTMENT-WISE LATE ATTENDANCE REPORT
-- ==================================================

SELECT
    e.department,

    COUNT(a.attendance_id) AS total_late_records,

    COUNT(DISTINCT a.employee_id) AS employees_arriving_late,

    SUM(a.late_minutes) AS total_late_minutes,

    ROUND(AVG(a.late_minutes), 2)
        AS average_late_minutes

FROM Employee e

INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE a.late_minutes > 0

GROUP BY e.department

ORDER BY total_late_minutes DESC;


-- ==================================================
-- 5. EMPLOYEES WITH 2 OR MORE LATE MARKS
-- ==================================================

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    e.department,

    COUNT(a.attendance_id) AS late_days,

    SUM(a.late_minutes) AS total_late_minutes

FROM Employee e

INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE a.late_minutes > 0

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department

HAVING COUNT(a.attendance_id) >= 2

ORDER BY late_days DESC;


-- ==================================================
-- 6. LATE MARKS FOR A PARTICULAR EMPLOYEE
-- Change employee ID as required
-- ==================================================

SET @employee_id = 1;

SELECT
    e.employee_id,

    CONCAT(e.first_name, ' ', e.last_name)
        AS employee_name,

    a.attendance_date,
    a.check_in,
    a.late_minutes

FROM Attendance a

INNER JOIN Employee e
    ON a.employee_id = e.employee_id

WHERE a.employee_id = @employee_id
  AND a.late_minutes > 0

ORDER BY a.attendance_date;


-- ==================================================
-- 7. TOTAL LATE MINUTES FOR THE COMPANY
-- ==================================================

SELECT
    COUNT(*) AS total_late_records,

    COUNT(DISTINCT employee_id)
        AS total_employees_arriving_late,

    SUM(late_minutes) AS company_total_late_minutes,

    ROUND(AVG(late_minutes), 2)
        AS company_average_late_minutes

FROM Attendance

WHERE late_minutes > 0;
