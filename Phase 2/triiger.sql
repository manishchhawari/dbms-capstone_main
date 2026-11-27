
-- ==========================================
-- PAYROLL & ATTENDANCE MANAGEMENT SYSTEM
-- FILE: trigger.sql
-- PHASE 2: DATABASE TRIGGERS
-- MySQL 8.0+
-- ==========================================

USE payroll_management;

DELIMITER $$

-- ==========================================
-- TRIGGER 1: BEFORE INSERT ATTENDANCE
-- ==========================================

DROP TRIGGER IF EXISTS Before_Attendance_Insert$$

CREATE TRIGGER Before_Attendance_Insert
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
    -- Check employee exists and is active
    IF NOT EXISTS (
        SELECT 1
        FROM Employee
        WHERE employee_id = NEW.employee_id
          AND employment_status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist or is inactive';
    END IF;

    -- Validate late minutes
    IF NEW.late_minutes IS NULL OR NEW.late_minutes < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Late minutes cannot be negative or NULL';
    END IF;

    -- Validate check-in and check-out
    IF NEW.check_in IS NOT NULL
       AND NEW.check_out IS NOT NULL
       AND NEW.check_out <= NEW.check_in THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Check-out must be later than check-in';
    END IF;

    -- Validate attendance status
    IF NEW.status = 'Absent'
       AND (NEW.check_in IS NOT NULL OR NEW.check_out IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Absent employee cannot have check-in or check-out';
    END IF;
END$$


-- ==========================================
-- TRIGGER 2: BEFORE UPDATE ATTENDANCE
-- ==========================================

DROP TRIGGER IF EXISTS Before_Attendance_Update$$

CREATE TRIGGER Before_Attendance_Update
BEFORE UPDATE ON Attendance
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Employee
        WHERE employee_id = NEW.employee_id
          AND employment_status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist or is inactive';
    END IF;

    IF NEW.late_minutes IS NULL OR NEW.late_minutes < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Late minutes cannot be negative or NULL';
    END IF;

    IF NEW.check_in IS NOT NULL
       AND NEW.check_out IS NOT NULL
       AND NEW.check_out <= NEW.check_in THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Check-out must be later than check-in';
    END IF;

    IF NEW.status = 'Absent'
       AND (NEW.check_in IS NOT NULL OR NEW.check_out IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Absent employee cannot have check-in or check-out';
    END IF;
END$$


-- ==========================================
-- TRIGGER 3: BEFORE INSERT LEAVE REQUEST
-- ==========================================

DROP TRIGGER IF EXISTS Before_Leave_Insert$$

CREATE TRIGGER Before_Leave_Insert
BEFORE INSERT ON Leave_Request
FOR EACH ROW
BEGIN
    IF NEW.start_date IS NULL OR NEW.end_date IS NULL
       OR NEW.end_date < NEW.start_date THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid leave dates';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Employee
        WHERE employee_id = NEW.employee_id
          AND employment_status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist or is inactive';
    END IF;

    -- Check overlapping approved leaves
    IF NEW.leave_status = 'Approved' AND EXISTS (
        SELECT 1
        FROM Leave_Request
        WHERE employee_id = NEW.employee_id
          AND leave_status = 'Approved'
          AND NEW.start_date <= end_date
          AND NEW.end_date >= start_date
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overlapping approved leave already exists';
    END IF;
END$$


-- ==========================================
-- TRIGGER 4: BEFORE UPDATE LEAVE REQUEST
-- ==========================================

DROP TRIGGER IF EXISTS Before_Leave_Update$$

CREATE TRIGGER Before_Leave_Update
BEFORE UPDATE ON Leave_Request
FOR EACH ROW
BEGIN
    IF NEW.start_date IS NULL OR NEW.end_date IS NULL
       OR NEW.end_date < NEW.start_date THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid leave dates';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Employee
        WHERE employee_id = NEW.employee_id
          AND employment_status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist or is inactive';
    END IF;

    -- Exclude current leave record while checking overlap
    IF NEW.leave_status = 'Approved' AND EXISTS (
        SELECT 1
        FROM Leave_Request
        WHERE employee_id = NEW.employee_id
          AND leave_status = 'Approved'
          AND leave_id <> OLD.leave_id
          AND NEW.start_date <= end_date
          AND NEW.end_date >= start_date
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overlapping approved leave already exists';
    END IF;
END$$

DELIMITER ;


-- ==========================================
-- VERIFY TRIGGERS
-- ==========================================

SHOW TRIGGERS;
