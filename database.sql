-- ============================================
-- Student Exam Portal - Full Database Setup
-- ============================================

CREATE DATABASE IF NOT EXISTS student_portal;
USE student_portal;

-- Students table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    class VARCHAR(20) NOT NULL,
    section VARCHAR(5) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subjects table
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) UNIQUE NOT NULL,
    full_marks INT NOT NULL DEFAULT 100,
    pass_marks INT NOT NULL DEFAULT 33
);

-- Teachers table
CREATE TABLE IF NOT EXISTS teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exam results table
-- UNIQUE key prevents duplicate per student+subject+year
CREATE TABLE IF NOT EXISTS exam_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL,
    subject_code VARCHAR(20) NOT NULL,
    exam_year YEAR NOT NULL,
    marks_obtained INT NOT NULL,
    grade CHAR(2),
    UNIQUE KEY unique_result (student_id, subject_code, exam_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_code) REFERENCES subjects(subject_code)
);

-- ============================================
-- Sample Data
-- ============================================

INSERT IGNORE INTO subjects (subject_name, subject_code, full_marks, pass_marks) VALUES
('Mathematics',      'MATH101', 100, 33),
('English Language', 'ENG101',  100, 33),
('Physics',          'PHY101',  100, 33),
('Chemistry',        'CHEM101', 100, 33),
('Biology',          'BIO101',  100, 33),
('Computer Science', 'CS101',   100, 33),
('History',          'HIST101', 100, 33),
('Geography',        'GEO101',  100, 33);

INSERT IGNORE INTO students (student_id, full_name, class, section, password) VALUES
('STU001', 'Ayesha Rahman',  'Class 10', 'A', 'pass1234'),
('STU002', 'Fahim Hossain',  'Class 10', 'B', 'pass1234'),
('STU003', 'Nadia Islam',    'Class 10', 'A', 'pass1234'),
('STU004', 'Tariq Mahmud',   'Class 10', 'C', 'pass1234');

INSERT IGNORE INTO teachers (teacher_id, full_name, department, password) VALUES
('TCH001', 'Mr. Abdul Karim', 'Science & Math',   'teach1234'),
('TCH002', 'Ms. Fatema Begum','Humanities',        'teach1234'),
('TCH003', 'Mr. Rahim Hasan', 'Computer Science',  'teach1234');

INSERT IGNORE INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU001', 'MATH101', 2024, 88, 'A+'),
('STU001', 'ENG101',  2024, 76, 'A'),
('STU001', 'PHY101',  2024, 91, 'A+'),
('STU001', 'CHEM101', 2024, 83, 'A+'),
('STU001', 'BIO101',  2024, 79, 'A'),
('STU001', 'CS101',   2024, 95, 'A+'),
('STU001', 'HIST101', 2024, 70, 'A'),
('STU001', 'GEO101',  2024, 74, 'A');

INSERT IGNORE INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU002', 'MATH101', 2024, 55, 'B'),
('STU002', 'ENG101',  2024, 62, 'B+'),
('STU002', 'PHY101',  2024, 48, 'C'),
('STU002', 'CHEM101', 2024, 59, 'B'),
('STU002', 'BIO101',  2024, 71, 'A'),
('STU002', 'CS101',   2024, 80, 'A+'),
('STU002', 'HIST101', 2024, 66, 'B+'),
('STU002', 'GEO101',  2024, 53, 'B');

INSERT IGNORE INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU003', 'MATH101', 2024, 30, 'F'),
('STU003', 'ENG101',  2024, 45, 'C'),
('STU003', 'PHY101',  2024, 38, 'D'),
('STU003', 'CHEM101', 2024, 50, 'B'),
('STU003', 'BIO101',  2024, 60, 'B+'),
('STU003', 'CS101',   2024, 55, 'B'),
('STU003', 'HIST101', 2024, 40, 'C'),
('STU003', 'GEO101',  2024, 35, 'D');

-- Insert remaining students (STU005 to STU020)
INSERT INTO students (student_id, full_name, class, section, password) VALUES
('STU005', 'Sadia Chowdhury', 'Class 10', 'B', 'pass1234'),
('STU006', 'Kamal Hasan',     'Class 10', 'C', 'pass1234'),
('STU007', 'Rina Akter',      'Class 10', 'A', 'pass1234'),
('STU008', 'Imran Khan',      'Class 10', 'B', 'pass1234'),
('STU009', 'Mehjabin Nusrat', 'Class 10', 'C', 'pass1234'),
('STU010', 'Arif Hossain',    'Class 10', 'A', 'pass1234'),
('STU011', 'Tania Sultana',   'Class 10', 'B', 'pass1234'),
('STU012', 'Rakib Uddin',     'Class 10', 'C', 'pass1234'),
('STU013', 'Sumaiya Yasmin',  'Class 10', 'A', 'pass1234'),
('STU014', 'Jalal Miah',      'Class 10', 'B', 'pass1234'),
('STU015', 'Farhana Begum',   'Class 10', 'C', 'pass1234'),
('STU016', 'Shafiqul Alam',   'Class 10', 'A', 'pass1234'),
('STU017', 'Nusrat Jahan',    'Class 10', 'B', 'pass1234'),
('STU018', 'Hasan Tariq',     'Class 10', 'C', 'pass1234'),
('STU019', 'Mithila Faruq',   'Class 10', 'A', 'pass1234'),
('STU020', 'Zahidul Islam',   'Class 10', 'B', 'pass1234');

-- Insert exam results for STU004 (Average Performer)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU004', 'MATH101', 2024, 65, 'B+'),
('STU004', 'ENG101',  2024, 72, 'A'),
('STU004', 'PHY101',  2024, 68, 'B+'),
('STU004', 'CHEM101', 2024, 60, 'B'),
('STU004', 'BIO101',  2024, 75, 'A'),
('STU004', 'CS101',   2024, 82, 'A+'),
('STU004', 'HIST101', 2024, 55, 'B'),
('STU004', 'GEO101',  2024, 58, 'B');

-- Insert exam results for STU005 (Top Performer)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU005', 'MATH101', 2024, 92, 'A+'),
('STU005', 'ENG101',  2024, 88, 'A+'),
('STU005', 'PHY101',  2024, 95, 'A+'),
('STU005', 'CHEM101', 2024, 89, 'A+'),
('STU005', 'BIO101',  2024, 90, 'A+'),
('STU005', 'CS101',   2024, 98, 'A+'),
('STU005', 'HIST101', 2024, 85, 'A+'),
('STU005', 'GEO101',  2024, 87, 'A+');

-- Insert exam results for STU006 (Struggling/Mixed Fails)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU006', 'MATH101', 2024, 25, 'F'),
('STU006', 'ENG101',  2024, 40, 'C'),
('STU006', 'PHY101',  2024, 32, 'F'),
('STU006', 'CHEM101', 2024, 45, 'C'),
('STU006', 'BIO101',  2024, 50, 'B'),
('STU006', 'CS101',   2024, 55, 'B'),
('STU006', 'HIST101', 2024, 38, 'D'),
('STU006', 'GEO101',  2024, 42, 'C');

-- Insert exam results for STU007 (Strong in Arts, Weak in Sciences)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU007', 'MATH101', 2024, 45, 'C'),
('STU007', 'ENG101',  2024, 85, 'A+'),
('STU007', 'PHY101',  2024, 48, 'C'),
('STU007', 'CHEM101', 2024, 52, 'B'),
('STU007', 'BIO101',  2024, 60, 'B+'),
('STU007', 'CS101',   2024, 65, 'B+'),
('STU007', 'HIST101', 2024, 88, 'A+'),
('STU007', 'GEO101',  2024, 90, 'A+');

-- Insert exam results for STU008 (Borderline Passes)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU008', 'MATH101', 2024, 40, 'C'),
('STU008', 'ENG101',  2024, 45, 'C'),
('STU008', 'PHY101',  2024, 35, 'D'),
('STU008', 'CHEM101', 2024, 42, 'C'),
('STU008', 'BIO101',  2024, 55, 'B'),
('STU008', 'CS101',   2024, 60, 'B+'),
('STU008', 'HIST101', 2024, 38, 'D'),
('STU008', 'GEO101',  2024, 47, 'C');

-- Insert exam results for STU009 (Consistent Performer)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU009', 'MATH101', 2024, 81, 'A+'),
('STU009', 'ENG101',  2024, 80, 'A+'),
('STU009', 'PHY101',  2024, 85, 'A+'),
('STU009', 'CHEM101', 2024, 82, 'A+'),
('STU009', 'BIO101',  2024, 88, 'A+'),
('STU009', 'CS101',   2024, 91, 'A+'),
('STU009', 'HIST101', 2024, 84, 'A+'),
('STU009', 'GEO101',  2024, 86, 'A+');

-- Insert exam results for STU010 (Failed Sciences)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU010', 'MATH101', 2024, 55, 'B'),
('STU010', 'ENG101',  2024, 60, 'B+'),
('STU010', 'PHY101',  2024, 28, 'F'),
('STU010', 'CHEM101', 2024, 30, 'F'),
('STU010', 'BIO101',  2024, 25, 'F'),
('STU010', 'CS101',   2024, 65, 'B+'),
('STU010', 'HIST101', 2024, 55, 'B'),
('STU010', 'GEO101',  2024, 60, 'B+');

-- Insert exam results for STU011 (Good Performer)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU011', 'MATH101', 2024, 68, 'B+'),
('STU011', 'ENG101',  2024, 75, 'A'),
('STU011', 'PHY101',  2024, 70, 'A'),
('STU011', 'CHEM101', 2024, 72, 'A'),
('STU011', 'BIO101',  2024, 65, 'B+'),
('STU011', 'CS101',   2024, 78, 'A'),
('STU011', 'HIST101', 2024, 80, 'A+'),
('STU011', 'GEO101',  2024, 82, 'A+');

-- Insert exam results for STU012 (Below Average)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU012', 'MATH101', 2024, 35, 'D'),
('STU012', 'ENG101',  2024, 42, 'C'),
('STU012', 'PHY101',  2024, 38, 'D'),
('STU012', 'CHEM101', 2024, 40, 'C'),
('STU012', 'BIO101',  2024, 45, 'C'),
('STU012', 'CS101',   2024, 50, 'B'),
('STU012', 'HIST101', 2024, 33, 'D'),
('STU012', 'GEO101',  2024, 36, 'D');

-- Insert exam results for STU013 (High Achiever)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU013', 'MATH101', 2024, 88, 'A+'),
('STU013', 'ENG101',  2024, 90, 'A+'),
('STU013', 'PHY101',  2024, 85, 'A+'),
('STU013', 'CHEM101', 2024, 92, 'A+'),
('STU013', 'BIO101',  2024, 87, 'A+'),
('STU013', 'CS101',   2024, 95, 'A+'),
('STU013', 'HIST101', 2024, 80, 'A+'),
('STU013', 'GEO101',  2024, 84, 'A+');

-- Insert exam results for STU014 (Mostly Fails)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU014', 'MATH101', 2024, 15, 'F'),
('STU014', 'ENG101',  2024, 22, 'F'),
('STU014', 'PHY101',  2024, 18, 'F'),
('STU014', 'CHEM101', 2024, 25, 'F'),
('STU014', 'BIO101',  2024, 30, 'F'),
('STU014', 'CS101',   2024, 35, 'D'),
('STU014', 'HIST101', 2024, 20, 'F'),
('STU014', 'GEO101',  2024, 28, 'F');

-- Insert exam results for STU015 (Solid A/B+ Student)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU015', 'MATH101', 2024, 70, 'A'),
('STU015', 'ENG101',  2024, 65, 'B+'),
('STU015', 'PHY101',  2024, 72, 'A'),
('STU015', 'CHEM101', 2024, 68, 'B+'),
('STU015', 'BIO101',  2024, 75, 'A'),
('STU015', 'CS101',   2024, 80, 'A+'),
('STU015', 'HIST101', 2024, 74, 'A'),
('STU015', 'GEO101',  2024, 69, 'B+');

-- Insert exam results for STU016 (Average)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU016', 'MATH101', 2024, 50, 'B'),
('STU016', 'ENG101',  2024, 45, 'C'),
('STU016', 'PHY101',  2024, 55, 'B'),
('STU016', 'CHEM101', 2024, 52, 'B'),
('STU016', 'BIO101',  2024, 48, 'C'),
('STU016', 'CS101',   2024, 60, 'B+'),
('STU016', 'HIST101', 2024, 58, 'B'),
('STU016', 'GEO101',  2024, 50, 'B');

-- Insert exam results for STU017 (Highest Marks)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU017', 'MATH101', 2024, 98, 'A+'),
('STU017', 'ENG101',  2024, 92, 'A+'),
('STU017', 'PHY101',  2024, 96, 'A+'),
('STU017', 'CHEM101', 2024, 94, 'A+'),
('STU017', 'BIO101',  2024, 95, 'A+'),
('STU017', 'CS101',   2024, 99, 'A+'),
('STU017', 'HIST101', 2024, 91, 'A+'),
('STU017', 'GEO101',  2024, 93, 'A+');

-- Insert exam results for STU018 (Struggling/Pass)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU018', 'MATH101', 2024, 42, 'C'),
('STU018', 'ENG101',  2024, 38, 'D'),
('STU018', 'PHY101',  2024, 40, 'C'),
('STU018', 'CHEM101', 2024, 35, 'D'),
('STU018', 'BIO101',  2024, 45, 'C'),
('STU018', 'CS101',   2024, 50, 'B'),
('STU018', 'HIST101', 2024, 36, 'D'),
('STU018', 'GEO101',  2024, 40, 'C');

-- Insert exam results for STU019 (Good Performer)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU019', 'MATH101', 2024, 82, 'A+'),
('STU019', 'ENG101',  2024, 78, 'A'),
('STU019', 'PHY101',  2024, 80, 'A+'),
('STU019', 'CHEM101', 2024, 85, 'A+'),
('STU019', 'BIO101',  2024, 75, 'A'),
('STU019', 'CS101',   2024, 88, 'A+'),
('STU019', 'HIST101', 2024, 82, 'A+'),
('STU019', 'GEO101',  2024, 79, 'A');

-- Insert exam results for STU020 (Average/Consistent)
INSERT INTO exam_results (student_id, subject_code, exam_year, marks_obtained, grade) VALUES
('STU020', 'MATH101', 2024, 60, 'B+'),
('STU020', 'ENG101',  2024, 55, 'B'),
('STU020', 'PHY101',  2024, 62, 'B+'),
('STU020', 'CHEM101', 2024, 58, 'B'),
('STU020', 'BIO101',  2024, 65, 'B+'),
('STU020', 'CS101',   2024, 70, 'A'),
('STU020', 'HIST101', 2024, 60, 'B+'),
('STU020', 'GEO101',  2024, 55, 'B');




-- 1. Create the Teachers table
CREATE TABLE IF NOT EXISTS teachers (
    teacher_id VARCHAR(50) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- 2. Insert demo teacher credentials
INSERT INTO teachers (teacher_id, full_name, password) 
VALUES ('TEA001', 'Prof. John Doe', 'pass1234'),
('TEA002', 'Dr.Syed Arif', 'pass1234'),
('TEA003', 'Mrs.Sabira', 'pass1234'),
('TEA004', 'Mr.Antor', 'pass1234'),
('TEA005', 'Mr.Minhaz', 'pass1234');