# Task-2-lms-sql

## Objective
This project demonstrates the design and implementation of a normalized SQL schema for a **Learning Management System (LMS)**. It includes essential database concepts such as foreign key relationships, check constraints, views, triggers, soft deletes, and audit logging using SQL.

---

##  Schema Overview

###  Users Table
- Centralized table for students, instructors, and admins.
- Role-based separation using `user_role` column.
- Contains standard personal information.

###  Courses Table
- Represents LMS course catalog.
- Linked to instructors.

###  Enrollments Table
- Maps users (students) to courses.
- Tracks completion, progress, and final grades.

###  Assignments Table
- Tasks assigned to students per course.

###  Submissions Table
- Records student submissions and scores for assignments.

###  Submission Audit Table
- Stores historical changes to submission scores (audit log).

---

## 🔗 Relationships
| From       | Type      | To           | Description                             |
|------------|-----------|--------------|-----------------------------------------|
| users      | 1 → M     | enrollments  | Students enrolled in multiple courses   |
| courses    | 1 → M     | enrollments  | Course with multiple student enrollments|
| courses    | 1 → M     | assignments  | Course with multiple assignments        |
| assignments| 1 → M     | submissions  | Assignment submitted by many students   |
| users      | 1 → M     | submissions  | Submissions made by students            |

---

##  Features Implemented

- **Foreign Key Constraints** for all relationships
- **Check Constraints**
  - `score` between 0 and 100
  - `progress` between 0 and 100
  - `gpa` between 0.0 and 4.0
- **Indexes**
  - Foreign key columns
  - `email` in `users`
- **Enum-like role field** (`user_role`) with values: `student`, `instructor`, `admin`
- **Soft Deletes** using `is_deleted` boolean column
- **View**: `user_scores` to fetch student name, course title, assignment title, and score
- **Trigger + Function**
  - Automatically updates a student's average final grade upon new submission
- **Audit Logging** of score changes via `submission_audit` table

---

##  Files

| File                     | Description                                      |
|--------------------------|--------------------------------------------------|
| `schema_lms_mysql.sql`   | Full MySQL schema with all constraints & logic   |
| `schema_lms_postgres.sql`| PostgreSQL version of the same schema            |
| `sample_data_mysql.sql`  | Sample INSERT queries for testing                |
| `sample_data_postgres.sql`|  Sample INSERT data                             |
| `README.md`              | This file                                        |

---

