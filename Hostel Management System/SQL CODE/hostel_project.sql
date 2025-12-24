-- ------------------------------------------------------------
-- CLEAN START (DROP OLD DATABASE)
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS hostel_management;
CREATE DATABASE hostel_management;
USE hostel_management;

-- ------------------------------------------------------------
-- TABLES (DDL)
-- ------------------------------------------------------------

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    hostel_block VARCHAR(20),
    room_no VARCHAR(10)
);

CREATE TABLE Admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE MessManagers (
    manager_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE ComplaintCategory (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    description TEXT
);

CREATE TABLE HostelRooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hostel_block VARCHAR(20),
    room_no VARCHAR(10),
    capacity INT,
    current_occupancy INT
);

CREATE TABLE Complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    admin_id INT,
    category_id INT,
    description TEXT,
    status VARCHAR(30) DEFAULT 'Pending',
    date_raised DATE,
    date_resolved DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id),
    FOREIGN KEY (category_id) REFERENCES ComplaintCategory(category_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    manager_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (manager_id) REFERENCES MessManagers(manager_id)
);

-- ------------------------------------------------------------
-- SAMPLE DATA (DML)
-- ------------------------------------------------------------

INSERT INTO Students (name, email, password, hostel_block, room_no)
VALUES 
('Faheem Tanveer', 'faheem@pes.edu', 'faheem123', 'Block D', '204'),
('Dhruv Hegde', 'dhruv@pes.edu', 'dhruv123', 'Block C', '115');

INSERT INTO Admins (name, email, password)
VALUES ('MR.X.', 'X@pes.edu', 'admin123');

INSERT INTO MessManagers (name, email, password)
VALUES ('Anil Kumar', 'anil.mess@pes.edu', 'mess123');

INSERT INTO ComplaintCategory (category_name, description)
VALUES 
('Wi-Fi', 'Internet connectivity issues'),
('Cleanliness', 'Hygiene related issues'),
('Electricity', 'Electrical issues');

INSERT INTO HostelRooms (hostel_block, room_no, capacity, current_occupancy)
VALUES 
('Block D', '204', 3, 1),
('Block C', '115', 3, 1);

INSERT INTO Complaints (student_id, admin_id, category_id, description, status, date_raised)
VALUES
(1, 1, 1, 'No internet connection since morning', 'Pending', '2025-10-08'),
(2, 1, 2, 'Dustbins not cleaned regularly', 'In Progress', '2025-10-09');

INSERT INTO Feedback (student_id, manager_id, rating, comments, feedback_date)
VALUES
(1, 1, 4, 'Food quality improved but still oily', '2025-10-08'),
(2, 1, 2, 'Rice was undercooked today', '2025-10-09');

-- ------------------------------------------------------------
-- TRIGGERS
-- ------------------------------------------------------------

DELIMITER //

-- Trigger 1: Auto mark complaint as resolved when date_resolved is updated
CREATE TRIGGER update_status_after_resolution
BEFORE UPDATE ON Complaints
FOR EACH ROW
BEGIN
    IF NEW.date_resolved IS NOT NULL THEN
        SET NEW.status = 'Resolved';
    END IF;
END //

-- Trigger 2: Prevent exceeding hostel room capacity OR invalid room number
CREATE TRIGGER check_room_capacity
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE occ INT;
    DECLARE cap INT;

    SELECT current_occupancy, capacity INTO occ, cap
    FROM HostelRooms
    WHERE room_no = NEW.room_no
    LIMIT 1;

    IF occ IS NULL OR cap IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room not found.';
    ELSEIF occ >= cap THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room capacity exceeded!';
    ELSE
        UPDATE HostelRooms
        SET current_occupancy = current_occupancy + 1
        WHERE room_no = NEW.room_no;
    END IF;
END //

-- Trigger 3: Auto-insert feedback reminder when new manager is added
CREATE TRIGGER new_manager_feedback_reminder
AFTER INSERT ON MessManagers
FOR EACH ROW
BEGIN
    INSERT INTO Feedback (student_id, manager_id, comments, feedback_date)
    VALUES (1, NEW.manager_id, 'Please submit feedback for the new manager', CURDATE());
END //

DELIMITER ;

-- ------------------------------------------------------------
-- STORED PROCEDURES This procedure inserts a new complaint with a default status of Pending and today’s date.”

--This helps in UI integration
-- ------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE RaiseComplaint (
    IN p_student_id INT,
    IN p_admin_id INT,
    IN p_category_id INT,
    IN p_description TEXT
)
BEGIN
    INSERT INTO Complaints 
        (student_id, admin_id, category_id, description, status, date_raised)
    VALUES 
        (p_student_id, p_admin_id, p_category_id, p_description, 'Pending', CURDATE());
END //
--This procedure resolves a complaint by updating the resolved date.
--When this runs, Trigger 1 auto-updates the status
CREATE PROCEDURE ResolveComplaint (
    IN p_complaint_id INT
)
BEGIN
    UPDATE Complaints
    SET date_resolved = CURDATE()
    WHERE complaint_id = p_complaint_id;
END //

DELIMITER ;

-- ------------------------------------------------------------
-- FUNCTION
-- ------------------------------------------------------------

DELIMITER //

CREATE FUNCTION AvgManagerRating(p_manager_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE avg_rating DECIMAL(3,2);

    SELECT AVG(rating) INTO avg_rating
    FROM Feedback
    WHERE manager_id = p_manager_id;

    RETURN IFNULL(avg_rating, 0);
END //

DELIMITER ;

-- ------------------------------------------------------------
-- VIEWI ,created a view that joins Students, Complaints, and ComplaintCategory.

--This makes it easier to display complaint information in a readable format without writing complex joins repeatedly.
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW complaint_details AS
SELECT
    c.complaint_id,
    c.student_id,
    s.name AS student_name,
    cc.category_name,
    c.description,
    c.status,
    c.date_raised,
    c.date_resolved
FROM Complaints c
JOIN Students s ON c.student_id = s.student_id
JOIN ComplaintCategory cc ON c.category_id = cc.category_id
USE hostel_management;
SELECT * FROM complaints ORDER BY complaint_id DESC LIMIT 1;;