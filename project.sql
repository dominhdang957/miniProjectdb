-- ============================================================
-- HỆ THỐNG HỌC TRỰC TUYẾN
-- ============================================================

-- ==================== PHẦN I: DDL ==========================

CREATE DATABASE IF NOT EXISTS OnlineLearning
DEFAULT CHARACTER SET utf8mb4;
USE OnlineLearning;

CREATE TABLE Student (
    StudentID   INT PRIMARY KEY AUTO_INCREMENT,
    FullName    VARCHAR(100) NOT NULL,
    DateOfBirth DATE         NOT NULL,
    Email       VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    FullName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Course (
    CourseID    INT PRIMARY KEY AUTO_INCREMENT,
    CourseName  VARCHAR(150) NOT NULL,
    Description VARCHAR(255),
    TotalSessions INT NOT NULL CHECK (TotalSessions > 0),
    InstructorID  INT NOT NULL,
    CONSTRAINT fk_course_instructor FOREIGN KEY (InstructorID)
        REFERENCES Instructor(InstructorID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID    INT  NOT NULL,
    CourseID     INT  NOT NULL,
    EnrolledDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID),
    CONSTRAINT fk_enrollment_course FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID),
    CONSTRAINT uq_enrollment UNIQUE (StudentID, CourseID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Result (
    ResultID    INT PRIMARY KEY AUTO_INCREMENT,
    StudentID   INT           NOT NULL,
    CourseID    INT           NOT NULL,
    MidtermScore DECIMAL(4,2) NOT NULL CHECK (MidtermScore BETWEEN 0 AND 10),
    FinalScore   DECIMAL(4,2) NOT NULL CHECK (FinalScore   BETWEEN 0 AND 10),
    CONSTRAINT fk_result_student FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID),
    CONSTRAINT fk_result_course FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID),
    CONSTRAINT uq_result UNIQUE (StudentID, CourseID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==================== PHẦN II: DML - INSERT ================

INSERT INTO Student (FullName, DateOfBirth, Email) VALUES
('Nguyễn Văn An',   '2002-03-15', 'an.nv@student.edu.vn'),
('Trần Thị Bình',   '2003-07-22', 'binh.tt@student.edu.vn'),
('Lê Minh Châu',    '2002-11-05', 'chau.lm@student.edu.vn'),
('Phạm Quốc Dũng',  '2001-09-18', 'dung.pq@student.edu.vn'),
('Hoàng Thị Em',    '2003-01-30', 'em.ht@student.edu.vn');

INSERT INTO Instructor (FullName, Email) VALUES
('TS. Nguyễn Hoàng Anh',  'anh.nh@university.edu.vn'),
('ThS. Trần Văn Bảo',     'bao.tv@university.edu.vn'),
('TS. Lê Thị Cẩm',        'cam.lt@university.edu.vn'),
('PGS. Phạm Đức Duy',     'duy.pd@university.edu.vn'),
('ThS. Hoàng Minh Ems',   'ems.hm@university.edu.vn');

INSERT INTO Course (CourseName, Description, TotalSessions, InstructorID) VALUES
('Lập trình Python cơ bản',     'Nhập môn lập trình với Python',         30, 1),
('Cơ sở dữ liệu',               'SQL và thiết kế CSDL quan hệ',          25, 2),
('Lập trình Web Frontend',      'HTML, CSS, JavaScript cơ bản',          30, 3),
('Trí tuệ nhân tạo nhập môn',   'Các khái niệm cơ bản về AI/ML',         20, 4),
('Cấu trúc dữ liệu & Giải thuật','Thuật toán và độ phức tạp',            25, 5);

INSERT INTO Enrollment (StudentID, CourseID, EnrolledDate) VALUES
(1, 1, '2024-01-10'),
(1, 2, '2024-01-10'),
(2, 1, '2024-01-11'),
(2, 3, '2024-01-11'),
(3, 2, '2024-01-12'),
(3, 4, '2024-01-12'),
(4, 3, '2024-01-13'),
(4, 5, '2024-01-13'),
(5, 1, '2024-01-14'),
(5, 4, '2024-01-14');

INSERT INTO Result (StudentID, CourseID, MidtermScore, FinalScore) VALUES
(1, 1, 7.5, 8.0),
(1, 2, 6.0, 7.0),
(2, 1, 8.0, 8.5),
(2, 3, 7.0, 7.5),
(3, 2, 9.0, 9.5),
(3, 4, 6.5, 7.0),
(4, 3, 5.5, 6.0),
(4, 5, 8.5, 9.0),
(5, 1, 7.0, 7.5),
(5, 4, 8.0, 8.5);


-- ==================== PHẦN III: UPDATE ====================

-- Cập nhật email sinh viên
UPDATE Student
SET Email = 'an.updated@student.edu.vn'
WHERE StudentID = 1;

-- Cập nhật mô tả khóa học
UPDATE Course
SET Description = 'SQL nâng cao, thiết kế và tối ưu CSDL quan hệ'
WHERE CourseID = 2;

-- Cập nhật điểm cuối kỳ sinh viên
UPDATE Result
SET FinalScore = 9.0
WHERE StudentID = 3 AND CourseID = 2;


-- ==================== PHẦN IV: DELETE ====================

-- Xóa kết quả trước (tránh lỗi FK)
DELETE FROM Result
WHERE StudentID = 5 AND CourseID = 4;

-- Xóa lượt đăng ký không hợp lệ
DELETE FROM Enrollment
WHERE StudentID = 5 AND CourseID = 4;


-- ==================== PHẦN V: SELECT ====================

-- Danh sách sinh viên
SELECT * FROM Student;

-- Danh sách giảng viên
SELECT * FROM Instructor;

-- Danh sách khóa học
SELECT * FROM Course;

-- Thông tin đăng ký học
SELECT 
    e.EnrollmentID,
    s.FullName   AS SinhVien,
    c.CourseName AS KhoaHoc,
    e.EnrolledDate
FROM Enrollment e
JOIN Student  s ON e.StudentID = s.StudentID
JOIN Course   c ON e.CourseID  = c.CourseID;

-- Kết quả học tập
SELECT
    s.FullName    AS SinhVien,
    c.CourseName  AS KhoaHoc,
    r.MidtermScore AS DiemGiuaKy,
    r.FinalScore   AS DiemCuoiKy
FROM Result r
JOIN Student s ON r.StudentID = s.StudentID
JOIN Course  c ON r.CourseID  = c.CourseID;