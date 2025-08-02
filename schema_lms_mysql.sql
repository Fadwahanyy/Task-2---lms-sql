create database LMS;
use LMS;

-- USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50),
    password VARCHAR(255),
    gender VARCHAR(10),
    phone VARCHAR(15),
    date_of_birth DATE,
    user_role ENUM('student', 'instructor', 'admin'),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- ADMINS TABLE
CREATE TABLE admins (
    id INT PRIMARY KEY,
    role_title VARCHAR(50),
    FOREIGN KEY (id) REFERENCES users(id)
);

-- STUDENTS TABLE
CREATE TABLE students (
    id INT PRIMARY KEY,
    gpa DECIMAL(3,2) CHECK (gpa BETWEEN 0 AND 4.0),
    school_name VARCHAR(100),
    FOREIGN KEY (id) REFERENCES users(id)
);

-- INSTRUCTORS TABLE
CREATE TABLE instructors (
    id INT PRIMARY KEY,
    specialization VARCHAR(100),
    department VARCHAR(100),
    FOREIGN KEY (id) REFERENCES users(id)
);

-- COURSES TABLE
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    category VARCHAR(50),
    start_date DATE,
    end_date DATE,
    instructor_id INT,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (instructor_id) REFERENCES users(id)
);

-- ENROLLMENTS TABLE
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    course_id INT,
    status VARCHAR(20),
    final_grade DECIMAL(5,2),
    progress INT CHECK (progress BETWEEN 0 AND 100),
    completion_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    INDEX (user_id),
    INDEX (course_id)
);

-- ASSIGNMENTS TABLE
CREATE TABLE assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    title VARCHAR(100),
    description TEXT,
    due_date DATE,
    max_score INT,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    INDEX (course_id)
);

-- SUBMISSIONS TABLE
CREATE TABLE submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    student_id INT,
    submitted_at DATETIME,
    score DECIMAL(5,2),
    feedback TEXT,
    FOREIGN KEY (assignment_id) REFERENCES assignments(id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    CHECK (score >= 0 AND score <= 100),
    INDEX (assignment_id),
    INDEX (student_id)
);

-- SUBMISSION AUDIT TABLE
CREATE TABLE submission_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id INT,
    student_id INT,
    old_score DECIMAL(5,2),
    new_score DECIMAL(5,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(id)
);

-- VIEW: user_scores
CREATE VIEW user_scores AS
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    c.title AS course_title,
    a.title AS assignment_title,
    s.score
FROM submissions s
JOIN users u ON s.student_id = u.id
JOIN assignments a ON s.assignment_id = a.id
JOIN courses c ON a.course_id = c.id;

-- TRIGGER: Update final_grade after a new submission
DELIMITER //

CREATE TRIGGER trg_update_final_grade
AFTER INSERT ON submissions
FOR EACH ROW
BEGIN
    DECLARE avg_score DECIMAL(5,2);
    DECLARE course_id INT;

    SELECT course_id INTO course_id
    FROM assignments
    WHERE id = NEW.assignment_id;

    SELECT AVG(score) INTO avg_score
    FROM submissions s
    JOIN assignments a ON s.assignment_id = a.id
    WHERE s.student_id = NEW.student_id
      AND a.course_id = course_id;

    UPDATE enrollments
    SET final_grade = avg_score
    WHERE user_id = NEW.student_id
      AND course_id = course_id;
END;
//

DELIMITER ;

