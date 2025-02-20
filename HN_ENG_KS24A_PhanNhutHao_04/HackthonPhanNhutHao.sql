

DROP TABLE IF EXISTS tbl_enrollments;
DROP TABLE IF EXISTS tbl_schedules;
DROP TABLE IF EXISTS tbl_courses;


CREATE TABLE IF NOT EXISTS tbl_students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(10),
    dob DATE
);


CREATE TABLE IF NOT EXISTS tbl_teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    department VARCHAR(255)
);


DROP TABLE IF EXISTS tbl_courses;

CREATE TABLE tbl_courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(255) NOT NULL,
    teacher_id INT,
    tuition_fee DECIMAL(10,2),
    FOREIGN KEY (teacher_id) REFERENCES tbl_teachers(teacher_id) ON DELETE SET NULL
);


CREATE TABLE tbl_enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES tbl_students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES tbl_courses(course_id) ON DELETE CASCADE
);


CREATE TABLE tbl_schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    teacher_id INT,
    class_time TIME NOT NULL,
    class_day VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES tbl_courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES tbl_teachers(teacher_id) ON DELETE CASCADE
);

-- Câu 2: --

-- 1. Thêm cột discount (DECIMAL(10,2), mức giảm giá học phí) vào bảng tbl_enrollments -- 
ALTER TABLE tbl_enrollments ADD COLUMN discount DECIMAL(10,2) DEFAULT 0.00;

-- 2. Sửa kiểu dữ liệu cột phone trong bảng tbl_students thành VARCHAR(15) --
ALTER TABLE tbl_students MODIFY COLUMN phone VARCHAR(15);

-- 3.Xóa cột tuition_fee khỏi bảng tbl_courses --
ALTER TABLE tbl_courses DROP COLUMN tuition_fee;



-- Câu 3: --Viết lệnh INSERT INTO để thêm ít nhất 5 bản ghi phù hợp vào mỗi bảng --
-- tbl_students (bao gồm ít nhất 1 học viên đăng ký 2 khóa học khác nhau) --
-- tbl_teachers, tbl_courses, tbl_enrollments, tbl_schedules --

INSERT INTO tbl_students (name, email, phone, dob) VALUES
('Phan Nhựt Hào', 'ohayo123@gmail.com', '0862536828', '2005-01-01'),
('Nguyễn Thanh Hạ', 'ham12@gmail.com', '008091823', '2005-4-20'),
('Nguyễn Ngọc Diệp', 'diep123@gmail.com', '01291242', '2005-10-08'),
('Nguyễn Hoàng Yến Nhi', 'nhi123@gmail.com', '980324312', '2005-06-08'),
('Nguyễn Ngọc Quỳnh Hương', 'huong123@gmail.com', '1287124', '2005-02-25');

INSERT INTO tbl_teachers (name, email, phone, department) VALUES
('Thầy Phước', 'phuoc1ư@gmail.com', '148028145', 'IT'),
('Cô Lan', 'lan12@example.com', '0922222222', 'Toán'),
('Thầy Hùng', 'hung12@example.com', '0933333333', 'Fonttend'),
('Cô Mai', 'mai12@example.com', '0944444444', 'Hóa'),
('Thầy Sơn', 'son12@example.com', '0955555555', 'Tiếng Anh');

INSERT INTO tbl_courses (course_name, teacher_id) VALUES
('Lập trình C', 1),
('Lập trình hướng đối tượng',2),
('Vật lý ứng dụng', 3),
('Hóa phân tích', 4),
('Tiếng Anh', 5);

INSERT INTO tbl_enrollments (student_id, course_id, enrollment_date, discount) VALUES
(1, 1, '2024-02-01', 10.00),
(1, 2, '2024-02-05', 5.00), 
(2, 3, '2024-02-10', 15.00),
(3, 4, '2024-02-15', 20.00),
(4, 5, '2024-02-20', 10.00);

INSERT INTO tbl_schedules (course_id, teacher_id, class_time, class_day) VALUES
(1, 1, '08:00:00', 'Thứ Hai'),
(2, 2, '10:00:00', 'Thứ Ba'),
(3, 3, '13:30:00', 'Thứ Tư'),
(4, 4, '15:00:00', 'Thứ Năm'),
(5, 5, '17:00:00', 'Thứ Sáu');


-- Câu 4 --

-- 4a Lấy danh sách tất cả các khóa học, bao gồm: Mã khóa học , tên giảng viên, tên khóa học, ngày bắt đầu , ngày kết thúc --
SELECT 
    c.course_id AS 'Mã khóa học',
    c.course_name AS 'Tên khóa học',
    t.name AS 'Giảng viên phụ trách',
    s.class_day AS 'Ngày bắt đầu',
    DATE_ADD(s.class_day, INTERVAL 3 MONTH) AS 'Ngày kết thúc'
FROM tbl_courses c
LEFT JOIN tbl_teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN tbl_schedules s ON c.course_id = s.course_id;

-- 4b Lấy danh sách tất cả học viên đã đăng ký khóa học (không trùng lặp). --
SELECT DISTINCT s.student_id, s.name AS 'Tên học viên'
FROM tbl_enrollments e
JOIN tbl_students s ON e.student_id = s.student_id;

-- 5a Lấy danh sách tất cả giảng viên và số lượng khóa học họ phụ trách. -- 
SELECT 
    t.name AS 'Tên giảng viên',
    COUNT(c.course_id) AS 'Số lượng khóa học'
FROM tbl_teachers t
LEFT JOIN tbl_courses c ON t.teacher_id = c.teacher_id
GROUP BY t.name;

-- 5b Lấy danh sách tất cả khóa học và số lượng học viên đăng ký. --
SELECT 
    c.course_name AS 'Tên khóa học',
    COUNT(e.student_id) AS 'Số lượng học viên'
FROM tbl_courses c
LEFT JOIN tbl_enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 6a ấy số lượng khóa học mà mỗi học viên đã đăng ký. --
SELECT 
    s.name AS 'Tên học viên',
    COUNT(e.course_id) AS 'Số lượng khóa học đã đăng ký'
FROM tbl_students s
JOIN tbl_enrollments e ON s.student_id = e.student_id
GROUP BY s.name;

-- 6b Lấy danh sách học viên đã đăng ký từ 2 khóa học trở lên. --
SELECT 
    s.name AS 'Tên học viên',
    COUNT(e.course_id) AS 'Số lượng khóa học đã đăng ký'
FROM tbl_students s
JOIN tbl_enrollments e ON s.student_id = e.student_id
GROUP BY s.name
HAVING COUNT(e.course_id) >= 2;

-- 7 Lấy danh sách 5 khóa học có số lượng học viên đăng ký nhiều nhất. --
SELECT 
    c.course_name AS 'Tên khóa học',
    COUNT(e.student_id) AS 'Số lượng học viên'
FROM tbl_courses c
LEFT JOIN tbl_enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 5;

-- 8 Lấy danh sách tất cả học viên và tổng số tiền đã chi trả sau giảm giá. -- 
SELECT 
    s.name AS 'Tên học viên',
    SUM(e.discount) AS 'Tổng số tiền đã giảm giá'
FROM tbl_students s
JOIN tbl_enrollments e ON s.student_id = e.student_id
GROUP BY s.name;


-- 9a Lấy học viên đăng ký nhiều khóa học nhất. -- 
SELECT 
    s.name AS 'Tên học viên',
    COUNT(e.course_id) AS 'Số lượng khóa học đã đăng ký'
FROM tbl_students s
JOIN tbl_enrollments e ON s.student_id = e.student_id
GROUP BY s.name
ORDER BY COUNT(e.course_id) DESC
LIMIT 1;

-- 9b Lấy danh sách các khóa học chưa có học viên nào đăng ký. --
SELECT 
    c.course_name AS 'Tên khóa học'
FROM tbl_courses c
LEFT JOIN tbl_enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;


