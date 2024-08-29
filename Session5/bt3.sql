CREATE DATABASE Baitap3;
USE Baitap3;

-- Tạo bảng class
CREATE TABLE class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(100),
    start_date DATETIME,
    status BIT
);

-- Tạo bảng students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(11),
    class_id INT,
    status BIT,
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);

-- Tạo bảng subject
CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100),
    credit INT,
    status BIT
);

-- Tạo bảng mark
CREATE TABLE mark (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT,
    student_id INT,
    point DOUBLE,
    exam_time DATETIME,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Thêm dữ liệu vào bảng class
INSERT INTO class (class_name, start_date, status) VALUES 
('HN-JV231103', str_to_date('03/11/2023', '%d/%m/%Y'), true),
('HN-JV231229', str_to_date('29/12/2023', '%d/%m/%Y'), true),
('HN-JV230615', str_to_date('15/06/2023', '%d/%m/%Y'), true);

-- Thêm dữ liệu vào bảng students
INSERT INTO students (student_name, address, phone, class_id, status) VALUES 
('Hồ Gia Hùng', 'Hà Nội', '0987654321', 1, true),
('Phan Văn Giang', 'Đà Nẵng', '0967811255', 1, true),
('Dương Mỹ Huyền', 'Hà Nội', '0385546611', 2, true),
('Hoàng Minh Hiếu', 'Nghệ An', '0964425633', 2, true),
('Nguyễn Vịnh', 'Hà Nội', '0964425633', 3, true),
('Nam Cao', 'Hà Tĩnh', '0919191919', 1, true),
('Nguyễn Du', 'Nghệ An', '0353535353', 3, true);


-- Thêm dữ liệu vào bảng subject
INSERT INTO subject (subject_name, credit, status) VALUES 
('Toán', 3, true),
('Văn', 3, true),
('Anh', 2, true);

-- Thêm dữ liệu vào bảng mark
INSERT INTO mark (subject_id, student_id, point, exam_time) VALUES 
(1, 1, 7, str_to_date('12/05/2024', '%d/%m/%Y')),
(1, 1, 7, str_to_date('15/03/2024', '%d/%m/%Y')),
(2, 2, 8, str_to_date('15/05/2024', '%d/%m/%Y')),
(2, 3, 9, str_to_date('08/03/2024', '%d/%m/%Y')),
(3, 3, 10, str_to_date('11/02/2023', '%d/%m/%Y'));

DELIMITER //

CREATE PROCEDURE get_classes_with_more_than_5_students()
BEGIN
    SELECT c.class_id, c.class_name, COUNT(s.student_id) AS student_count
    FROM class c
    LEFT JOIN students s ON c.class_id = s.class_id
    GROUP BY c.class_id, c.class_name
    HAVING student_count > 5;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_subjects_with_score_10()
BEGIN
    SELECT s.subject_id, s.subject_name
    FROM subject s
    INNER JOIN mark m ON s.subject_id = m.subject_id
    WHERE m.point = 10
    GROUP BY s.subject_id, s.subject_name;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_classes_with_students_scoring_10()
BEGIN
    SELECT c.class_id, c.class_name
    FROM class c
    WHERE c.class_id IN (
        SELECT s.class_id
        FROM students s
        JOIN mark m ON s.student_id = m.student_id
        WHERE m.point = 10
    );
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE add_student(
    IN p_student_name VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_phone VARCHAR(11),
    IN p_class_id INT,
    IN p_status BIT,
    OUT p_student_id INT
)
BEGIN
    INSERT INTO students (student_name, address, phone, class_id, status)
    VALUES (p_student_name, p_address, p_phone, p_class_id, p_status);

    SELECT LAST_INSERT_ID() INTO p_student_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_subjects_not_taken()
BEGIN
    SELECT s.subject_id, s.subject_name
    FROM subject s
    WHERE s.subject_id NOT IN (
        SELECT m.subject_id
        FROM mark m
    );
END //

DELIMITER ;
