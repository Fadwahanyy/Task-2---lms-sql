INSERT INTO users (first_name, last_name, email, username, password, gender, phone, date_of_birth, user_role)
VALUES
('Ali', 'Ahmed', 'ali.khan@gmail.com', 'aliAhm', 'pass123', 'Male', '0500000001', '2000-05-15', 'student'),
('Sara', 'Yousef', 'sara.yousef@gmail.com', 'saray', 'pass456', 'Female', '0500000002', '1985-11-22', 'instructor'),
('Admin', 'User', 'admin@gmail.com', 'admin1', 'adminpass', 'Other', '0500000000', '1990-01-01', 'admin');

INSERT INTO admins (id, role_title)
VALUES (3, 'System Administrator');

INSERT INTO students (id, gpa, school_name)
VALUES (1, 3.5, 'International School');

INSERT INTO instructors (id, specialization, department)
VALUES (2, 'Computer Science', 'Engineering');

INSERT INTO courses (title, description, category, start_date, end_date, instructor_id)
VALUES ('Database Systems', 'Intro to DBMS concepts', 'Technology', '2024-09-01', '2024-12-15', 2);

INSERT INTO enrollments (user_id, course_id, status, final_grade, progress, completion_date)
VALUES (1, 1, 'active', NULL, 0, NULL);

INSERT INTO assignments (course_id, title, description, due_date, max_score)
VALUES (1, 'SQL Basics Assignment', 'Write basic SQL queries', '2024-10-01', 100);

INSERT INTO submissions (assignment_id, student_id, submitted_at, score, feedback)
VALUES (1, 1, NOW(), 85.00, 'Well done');

SELECT * FROM user_scores;

SELECT * FROM enrollments WHERE user_id = 1 AND course_id = 1;

SELECT * FROM submission_audit;
