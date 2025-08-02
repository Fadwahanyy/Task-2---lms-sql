CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50),
    password VARCHAR(255),
    gender VARCHAR(10),
    phone VARCHAR(15),
    date_of_birth DATE,
    user_role VARCHAR(20) CHECK (user_role IN ('student', 'instructor', 'admin')),
    is_deleted BOOLEAN DEFAULT FALSE
);


CREATE TABLE admins (
    id INT PRIMARY KEY REFERENCES users(id),
    role_title VARCHAR(50)
);


CREATE TABLE students (
    id INT PRIMARY KEY REFERENCES users(id),
    gpa DECIMAL(3,2) CHECK (gpa BETWEEN 0 AND 4.0),
    school_name VARCHAR(100)
);


CREATE TABLE instructors (
    id INT PRIMARY KEY REFERENCES users(id),
    specialization VARCHAR(100),
    department VARCHAR(100)
);


CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    category VARCHAR(50),
    start_date DATE,
    end_date DATE,
    instructor_id INT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);


CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    course_id INT REFERENCES courses(id),
    status VARCHAR(20),
    final_grade DECIMAL(5,2),
    progress INT CHECK (progress BETWEEN 0 AND 100),
    completion_date DATE
);


CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(id),
    title VARCHAR(100),
    description TEXT,
    due_date DATE,
    max_score INT,
    is_deleted BOOLEAN DEFAULT FALSE
);


CREATE TABLE submissions (
    id SERIAL PRIMARY KEY,
    assignment_id INT REFERENCES assignments(id),
    student_id INT REFERENCES users(id),
    submitted_at TIMESTAMP,
    score DECIMAL(5,2) CHECK (score BETWEEN 0 AND 100),
    feedback TEXT
);


CREATE TABLE submission_audit (
    id SERIAL PRIMARY KEY,
    submission_id INT REFERENCES submissions(id),
    student_id INT,
    old_score DECIMAL(5,2),
    new_score DECIMAL(5,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE VIEW user_scores AS
SELECT 
    u.first_name || ' ' || u.last_name AS user_name,
    c.title AS course_title,
    a.title AS assignment_title,
    s.score
FROM submissions s
JOIN users u ON s.student_id = u.id
JOIN assignments a ON s.assignment_id = a.id
JOIN courses c ON a.course_id = c.id;

CREATE FUNCTION update_final_grade()
RETURNS TRIGGER AS $$
DECLARE
    avg_score DECIMAL(5,2);
    course_id INT;
BEGIN
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

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_final_grade
AFTER INSERT ON submissions
FOR EACH ROW
EXECUTE FUNCTION update_final_grade();
