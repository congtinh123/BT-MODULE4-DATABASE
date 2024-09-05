-- Bài 1: Tạo CSDL theo đặc tả dữ liệu cho các bảng
create database md04_database_thuchanh_ad;
use md04_database_thuchanh_ad;

create table category(
Id int primary key auto_increment,
Name varchar(100) not null unique,
Status tinyint default 1 check (Status in (0, 1))
);

create table room (
    Id int primary key auto_increment,
    Name varchar(150) not null,
    Status tinyint default 1 check (Status in (0,1)),
    Price float not null check (Price >= 100000),
    Saleprice float default 0 ,
    Createddate datetime default current_timestamp,
    CategoryId int not null,
    constraint fk_category foreign key (CategoryId) references category(Id),
    index (name),
    index (Price),
    index (Createddate)
);

create table customer(
Id int primary key auto_increment,
Name varchar(150) not null,
Email varchar(150) not null unique check (Email regexp'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
Phone varchar(50) not null unique,
Address varchar(255),
CreatedDate datetime default current_timestamp(),
Gender tinyint not null check (Gender in (0,1,2)),
BirthDay date not null
);

create table booking(
Id int primary key auto_increment,
CustomerId int not null,
Status tinyint default 1 check (Status in (0,1,2,3)),
BookingDate datetime default current_timestamp,
constraint fk_customer foreign key (CustomerId) references customer(Id)
);

create table bookingdetail(
BookingId int not null,
RoomId int not null,
Price float not null,
StartDate datetime not null,
EndDate datetime not null,
constraint fk_booking foreign key (BookingId) references booking(Id),
constraint fk_room foreign key (RoomId) references room(Id),
primary key (BookingId, RoomId)
);

-- BÀI 2: THÊM DỮ LIỆU VÀO CSDL
INSERT INTO category (Name, Status) VALUES
('Hotel', 1),
('Motel', 1),
('Apartment', 1),
('Resort', 1),
('Hostel', 1);

INSERT INTO room (Name, Status, Price, Saleprice, Createddate, CategoryId) VALUES
('Room 101', 1, 150000, 120000, NOW(), 1),
('Room 102', 1, 200000, 180000, NOW(), 1),
('Room 103', 1, 250000, 220000, NOW(), 2),
('Room 104', 1, 300000, 270000, NOW(), 2),
('Room 105', 1, 350000, 320000, NOW(), 3),
('Room 106', 1, 400000, 370000, NOW(), 3),
('Room 107', 1, 450000, 420000, NOW(), 4),
('Room 108', 1, 500000, 470000, NOW(), 4),
('Room 109', 1, 550000, 520000, NOW(), 5),
('Room 110', 1, 600000, 570000, NOW(), 5),
('Room 111', 1, 650000, 620000, NOW(), 1),
('Room 112', 1, 700000, 670000, NOW(), 1),
('Room 113', 1, 750000, 720000, NOW(), 2),
('Room 114', 1, 800000, 770000, NOW(), 2),
('Room 115', 1, 850000, 820000, NOW(), 3);

INSERT INTO customer (Name, Email, Phone, Address, CreatedDate, Gender, BirthDay) VALUES
('Nguyen Van A', 'a.nguyen@example.com', '0123456789', '123 Street, City', NOW(), 1, '1990-01-01'),
('Tran Thi B', 'b.tran@example.com', '0987654321', '456 Avenue, City', NOW(), 0, '1985-05-15'),
('Le Thi C', 'c.le@example.com', '0123987654', '789 Road, City', NOW(), 0, '1992-07-20'),
('Pham Van D', 'd.pham@example.com', '0987123456', '101 Blvd, City', NOW(), 1, '1988-12-30'),
('Hoang Thi E', 'e.hoang@example.com', '0234567890', '202 Lane, City', NOW(), 0, '1995-03-25');

INSERT INTO booking (CustomerId, Status, BookingDate) VALUES
(1, 1, NOW()),
(2, 0, NOW()),
(3, 1, NOW()),
(4, 2, NOW()),
(5, 3, NOW());

INSERT INTO bookingdetail (BookingId, RoomId, Price, StartDate, EndDate) VALUES
(1, 1, 150000, '2024-09-01 14:00:00', '2024-09-05 11:00:00'),
(2, 3, 250000, '2024-09-10 14:00:00', '2024-09-15 11:00:00'),
(3, 5, 350000, '2024-09-20 14:00:00', '2024-09-25 11:00:00'),
(4, 7, 450000, '2024-09-25 14:00:00', '2024-09-30 11:00:00'),
(5, 9, 550000, '2024-10-01 14:00:00', '2024-10-05 11:00:00');

-- Bài 3: Truy vấn dữ liệu
-- Yêu cầu 1 ( Sử dụng lệnh SQL để truy vấn cơ bản )
-- 1.Lấy ra danh sách phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price,
-- SalePrice, Status, CategoryName, CreatedDate

SELECT
    r.Id,
    r.Name,
    r.Price,
    r.Saleprice,
    r.Status,
    c.Name AS CategoryName,
    r.Createddate
FROM
    room r
JOIN
    category c ON r.CategoryId = c.Id
ORDER BY
    r.Price DESC;

-- 2. Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )

SELECT
    c.Id,
    c.Name,
    COUNT(r.Id) AS TotalRoom,
    CASE
        WHEN c.Status = 1 THEN 'Hiển thị'
        WHEN c.Status = 0 THEN 'Ẩn'
        ELSE 'Không xác định'
    END AS Status
FROM
    category c
LEFT JOIN
    room r ON c.Id = r.CategoryId
GROUP BY
    c.Id, c.Name, c.Status;

-- 3. Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender,
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )

SELECT
    Id,
    Name,
    Email,
    Phone,
    Address,
    CreatedDate,
    CASE
        WHEN Gender = 0 THEN 'Nam'
        WHEN Gender = 1 THEN 'Nữ'
        WHEN Gender = 2 THEN 'Khác'
        ELSE 'Không xác định'
    END AS Gender,
    BirthDay,
    TIMESTAMPDIFF(YEAR, BirthDay, CURDATE()) AS Age
FROM
    customer;

-- Yêu cầu 2 ( Sử dụng lệnh SQL tạo View )
-- 1. View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất

CREATE VIEW v_getRoomInfo AS
SELECT
    Id,
    Name,
    Price,
    Saleprice,
    Status,
    Createddate,
    CategoryId
FROM
    room
ORDER BY
    Price DESC
LIMIT 10;

-- 2. View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: Id, BookingDate, Status,
-- CusName,Email, Phone,TotalAmount ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1 Đã duyệt,= 2 Đã thanh toán, = 3 Đã hủy ) 

CREATE VIEW v_getBookingList AS
SELECT
    b.Id AS BookingId,
    b.BookingDate,
    CASE
        WHEN b.Status = 0 THEN 'Chưa duyệt'
        WHEN b.Status = 1 THEN 'Đã duyệt'
        WHEN b.Status = 2 THEN 'Đã thanh toán'
        WHEN b.Status = 3 THEN 'Đã hủy'
        ELSE 'Không xác định'
    END AS Status,
    c.Name AS CusName,
    c.Email,
    c.Phone,
    COALESCE(SUM(bd.Price), 0) AS TotalAmount
FROM
    booking b
JOIN
    customer c ON b.CustomerId = c.Id
LEFT JOIN
    bookingdetail bd ON b.Id = bd.BookingId
GROUP BY
    b.Id, b.BookingDate, b.Status, c.Name, c.Email, c.Phone;

-- Yêu cầu 3 ( Sử dụng lệnh SQL tạo thủ tục Stored Procedure )
-- 1. Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị
-- của bảng Room ( Trừ cột tự động tăng )

DELIMITER //

CREATE PROCEDURE addRoomInfo(
    IN p_Name VARCHAR(150),
    IN p_Status TINYINT,
    IN p_Price FLOAT,
    IN p_Saleprice FLOAT,
    IN p_Createddate DATETIME,
    IN p_CategoryId INT
)
BEGIN
    INSERT INTO room (Name, Status, Price, Saleprice, Createddate, CategoryId)
    VALUES (p_Name, p_Status, p_Price, p_Saleprice, p_Createddate, p_CategoryId);
END //

DELIMITER ;

-- thử thủ tục vừa tạo.
CALL addRoomInfo('Room 201', 1, 180000, 150000, NOW(), 2);

-- 2.Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng
-- theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0
-- Chưa duyệt, = 1 Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id của khách hàng

DELIMITER //

CREATE PROCEDURE getBookingByCustomerId(
    IN p_CustomerId INT
)
BEGIN
    SELECT
        b.Id AS BookingId,
        b.BookingDate,
        CASE
            WHEN b.Status = 0 THEN 'Chưa duyệt'
            WHEN b.Status = 1 THEN 'Đã duyệt'
            WHEN b.Status = 2 THEN 'Đã thanh toán'
            WHEN b.Status = 3 THEN 'Đã hủy'
            ELSE 'Không xác định'
        END AS Status,
        COALESCE(SUM(bd.Price), 0) AS TotalAmount
    FROM
        booking b
    LEFT JOIN
        bookingdetail bd ON b.Id = bd.BookingId
    WHERE
        b.CustomerId = p_CustomerId
    GROUP BY
        b.Id, b.BookingDate, b.Status;
END //

DELIMITER ;

-- thử thủ tục vừa tạo
CALL getBookingByCustomerId(1);

-- 3. Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price,
-- SalePrice, Khi gọi thủ tuc truyền vào limit và page
-- Chưa làm được.

-- Yêu cầu 4 ( Sử dụng lệnh SQL tạo Trigger ) (15đ)
-- Chưa làm được
