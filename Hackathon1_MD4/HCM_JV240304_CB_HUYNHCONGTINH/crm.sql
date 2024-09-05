create database md04_database_thuchanh_cb;
use md04_database_thuchanh_cb;

create table books(
book_id int primary key auto_increment,
book_title varchar(100) not null,
book_author varchar(100) not null
);

create table readers(
Id int primary key auto_increment,
Name varchar(150) not null,
Phone varchar(11) not null unique,
Email varchar(100),
index(Name)
);

create table borrowingrecords(
Id int primary key auto_increment,
borrow_date date not null,
return_date date,
book_id int,
reader_id int,
constraint fk_book foreign key (book_id) references books(book_id),
constraint fk_reader foreign key (reader_id) references readers(Id)
);

-- Thêm dữ liệu vào bảng books
INSERT INTO books (book_title, book_author) VALUES 
('Số Đỏ', 'Vũ Trọng Phụng'),
('Những Ngày Xưa Thân Ái', 'Nguyễn Huy Thiệp'),
('Lão Hạc', 'Nam Cao'),
('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài'),
('Cánh Đồng Bất Tận', 'Nguyễn Ngọc Tư');

-- Thêm dữ liệu vào bảng readers
INSERT INTO readers (Name, Phone, Email) VALUES 
('Nguyễn Văn An', '0912345678', 'nguyen.an@example.com'),
('Trần Thị Bình', '0923456789', 'tran.binh@example.com'),
('Lê Văn Cường', '0934567890', 'le.cuong@example.com'),
('Phạm Thị Duyên', '0945678901', 'pham.duyen@example.com'),
('Hoàng Văn E', '0956789012', 'hoang.e@example.com'),
('Nguyễn Thị Hoa', '0967890123', 'nguyen.hoa@example.com'),
('Đỗ Minh Hoàng', '0978901234', 'do.minhhoang@example.com'),
('Bùi Thị Hương', '0989012345', 'bui.huong@example.com'),
('Ngô Văn Kiên', '0990123456', 'ngo.kien@example.com'),
('Vũ Thị Lan', '0911234567', 'vu.lan@example.com'),
('Nguyễn Văn Minh', '0922345678', 'nguyen.minh@example.com'),
('Trịnh Thị Nga', '0933456789', 'trinh.nga@example.com'),
('Lê Minh Quân', '0944567890', 'le.minhquan@example.com'),
('Hoàng Thị Thanh', '0955678901', 'hoang.thanh@example.com'),
('Đinh Văn Tuấn', '0966789012', 'dinh.tuan@example.com');

-- Thêm dữ liệu vào bảng borrowingrecords
INSERT INTO borrowingrecords (borrow_date, return_date, book_id, reader_id) VALUES 
('2024-08-01', '2024-08-15', 1, 1),
('2024-08-05', '2024-08-20', 3, 2),
('2024-08-10', NULL, 5, 3);

-- YÊU CẦU 1 (SỬ DỤNG LỆNH SQL ĐỂ TRUY VẤN CƠ BẢN)
-- 1. Viết truy vấn SQL để lấy thông tin tất cả các giao dịch mượn sách, bao gồm tên sách, tên độc giả, ngày mượn, và ngày trả 

SELECT 
    b.book_title AS 'Tên Sách',
    r.Name AS 'Tên Độc Giả',
    br.borrow_date AS 'Ngày Mượn',
    br.return_date AS 'Ngày Trả'
FROM 
    borrowingrecords br
JOIN 
    books b ON br.book_id = b.book_id
JOIN 
    readers r ON br.reader_id = r.Id;

-- 2.Viết truy vấn SQL để tìm tất cả các sách mà độc giả bất kỳ đã mượn (ví dụ độc giả có tên Nguyễn Văn A).

SELECT 
    b.book_title AS 'Tên Sách'
FROM 
    books b
JOIN 
    borrowingrecords br ON b.book_id = br.book_id
JOIN 
    readers r ON br.reader_id = r.Id
WHERE 
    r.Name = 'Nguyễn Văn An';

-- 3.Đếm số lần một cuốn sách đã được mượn

SELECT 
    b.book_title AS 'Tên Sách',
    COUNT(br.book_id) AS 'Số Lần Được Mượn'
FROM 
    books b
LEFT JOIN 
    borrowingrecords br ON b.book_id = br.book_id
WHERE 
    b.book_id = 1
GROUP BY 
    b.book_title;

-- 4.Truy vấn tên của độc giả đã mượn nhiều sách nhất

SELECT 
    r.Name AS 'Tên Độc Giả',
    COUNT(br.book_id) AS 'Số Lượng Sách Mượn'
FROM 
    readers r
JOIN 
    borrowingrecords br ON r.Id = br.reader_id
GROUP BY 
    r.Name
ORDER BY 
    COUNT(br.book_id) DESC
LIMIT 1;

-- YÊU CẦU 2 (SỬ DỤNG LỆNH SQL TẠO VIEW)
-- 1.Tạo một view tên là borrowed_books để hiển thị thông tin của tất cả các sách đã được
-- mượn, bao gồm tên sách, tên độc giả, và ngày mượn. Sử dụng các bảng Books, Readers, và BorrowingRecords.

CREATE VIEW borrowed_books AS
SELECT 
    b.book_title AS 'Tên Sách',
    r.Name AS 'Tên Độc Giả',
    br.borrow_date AS 'Ngày Mượn'
FROM 
    books b
JOIN 
    borrowingrecords br ON b.book_id = br.book_id
JOIN 
    readers r ON br.reader_id = r.Id;
-- hiển thị bảng view vừa tạo
SELECT * FROM borrowed_books;

-- YÊU CẦU 3 (SỬ DỤNG LỆNH SQL TẠO THỦ TỤC STORED PROCEDURE)
-- 1. Viết một thủ tục tên là get_books_borrowed_by_reader nhận một tham số là
-- reader_id . Thủ tục này sẽ trả về danh sách các sách mà độc giả đó đã mượn, bao gồm tên sách và ngày mượn.
DELIMITER //
CREATE PROCEDURE get_books_borrowed_by_reader(IN reader_id INT)
BEGIN
    SELECT 
        b.book_title AS 'Tên Sách',
        br.borrow_date AS 'Ngày Mượn'
    FROM 
        books b
    JOIN 
        borrowingrecords br ON b.book_id = br.book_id
    WHERE 
        br.reader_id = reader_id;
END //
DELIMITER ;

-- gọi thủ tục vừa tạo
CALL get_books_borrowed_by_reader(1);

-- YÊU CẦU 4 (SỬ DỤNG LỆNH SQL TẠO TRIGGER)
-- 1.Tạo một Trigger trong MySQL để tự động cập nhật ngày trả sách trong bảng
-- BorrowingRecords khi cuốn sách được trả. Cụ thể, khi một bản ghi trong bảng
-- BorrowingRecords được cập nhật với giá trị return_date , Trigger sẽ ghi lại ngày hiện tại
-- (ngày trả sách) nếu return_date chưa được điền trước đó.

DELIMITER //
CREATE TRIGGER update_return_date
BEFORE UPDATE ON borrowingrecords
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu return_date chưa được điền và ngày trả sách đã được cập nhật
    IF NEW.return_date IS NULL AND OLD.return_date IS NULL THEN
        SET NEW.return_date = CURDATE();
    END IF;
END //
DELIMITER ;

-- cập nhật thử để kiểm tra xem trigger có hoạt động không?
UPDATE borrowingrecords
SET book_id = 5
WHERE Id = 3;

-- Cảm ơn Thầy đã chấm bài!