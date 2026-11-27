
-- ==================================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: attendance_report.sql
-- PHASE 3: ATTENDANCE REPORTS
-- MySQL 8.0+
-- ==================================================

USE payroll_management;

-- ==================================================
-- 1. MONTHLY ATTENDANCE SUMMARY
-- Shows Present, Absent, Half-Day and Leave counts
-- ==================================================

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.department,

    DATE_FORMAT(a.attendance_date, '%M %Y') AS report_month,

    COUNT(*) AS total_recorded_days,

    SUM(CASE
        WHEN a.status = 'Present' THEN 1
        ELSE 0
    END) AS present_days,

    SUM(CASE
        WHEN a.status = 'Absent' THEN 1
        ELSE 0
    END) AS absent_days,

    SUM(CASE
        WHEN a.status = 'Half-Day' THEN 1
        ELSE 0
    END) AS half_days,

    SUM(CASE
        WHEN a.status = 'Leave' THEN 1
        ELSE 0
    END) AS leave_days,

    SUM(a.late_minutes) AS total_late_minutes

FROM Employee e
INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    YEAR(a.attendance_date),
    MONTH(a.attendance_date)

ORDER BY
    e.employee_id,
    YEAR(a.attendance_date),
    MONTH(a.attendance_date);


-- ==================================================
-- 2. ATTENDANCE SUMMARY FOR A PARTICULAR MONTH
-- Example: January 2026
-- ==================================================

SET @report_month = '2026-01-01';

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.department,

    COUNT(a.attendance_id) AS recorded_days,

    SUM(CASE
        WHEN a.status = 'Present' THEN 1
        ELSE 0
    END) AS present_days,

    SUM(CASE
        WHEN a.status = 'Absent' THEN 1
        ELSE 0
    END) AS absent_days,

    SUM(CASE
        WHEN a.status = 'Half-Day' THEN 1
        ELSE 0
    END) AS half_days,

    SUM(CASE
        WHEN a.status = 'Leave' THEN 1
        ELSE 0
    END) AS leave_days

FROM Employee e
LEFT JOIN Attendance a
    ON e.employee_id = a.employee_id
    AND YEAR(a.attendance_date) = YEAR(@report_month)
    AND MONTH(a.attendance_date) = MONTH(@report_month)

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department

ORDER BY e.employee_id;


-- ==================================================
-- 3. INDIVIDUAL EMPLOYEE ATTENDANCE REPORT
-- Example: Employee ID 1
-- ==================================================

SET @employee_id = 1;

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    a.attendance_date,
    a.check_in,
    a.check_out,
    a.status,
    a.late_minutes

FROM Employee e
INNER JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE e.employee_id = @employee_id

ORDER BY a.attendance_date;


-- ==================================================
-- 4. DEPARTMENT-WISE ATTENDANCE REPORT
-- ==================================================

SELECT
    e.department,

    COUNT(a.attendance_id) AS total_records,

    SUM(CASE
        WHEN a.status = 'Present' THEN 1
        ELSE 0
    END) AS present_count,

    SUM(CASE
        WHEN a.status = 'Absent' THEN 1
        ELSE 0
    END) AS absent_count,

    ROUND(
        100.0 * SUM(
            CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(a.attendance_id), 0),
        2
    ) AS present_percentage

FROM Employee e
LEFT JOIN Attendance a
    ON e.employee_id = a.employee_id

GROUP BY e.department

ORDER BY present_percentage DESC;


-- ==================================================
-- 5. EMPLOYEE ATTENDANCE DETAILS FOR JANUARY-MARCH
-- ==================================================

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,

    COUNT(a.attendance_id) AS total_days_recorded,

    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END)
        AS present_days,

    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END)
        AS absent_days,

    SUM(a.late_minutes) AS total_late_minutes

FROM Employee e
LEFT JOIN Attendance a
    ON e.employee_id = a.employee_id

WHERE a.attendance_date >= '2026-01-01'
  AND a.attendance_date < '2026-04-01'

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name

ORDER BY e.employee_id;
