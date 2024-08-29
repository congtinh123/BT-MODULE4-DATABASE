-- THỰC HÀNH 1 (Chỉ mục trong MySql)
USE classicmodels;
SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 
-- kiểm tra tốc độ truy vấn khi không có chỉ mục.
explain SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 
-- thêm chỉ mục cho bản
ALTER TABLE customers ADD INDEX idx_customerName(customerName);
-- chạy lại lệnh explanin để kiểm tra tốc độ khi thêm chỉ mục vào
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 
-- câu lệnh xóa chỉ mục
ALTER TABLE customers DROP INDEX idx_customerName;

-- THỰC HÀNH 2 (Store Procedure)
-- Tạo Mysql Stored Procedure
DELIMITER //

CREATE PROCEDURE findAllCustomers()

BEGIN

  SELECT * FROM customers;

END //

DELIMITER ;

-- Lệnh Drop để xóa đi Procedure
DROP PROCEDURE IF EXISTS `findAllCustomers`
-- xóa và tạo lại
DELIMITER //
DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()

BEGIN

SELECT * FROM customers where customerNumber = 175;

END //

-- THỰC HÀNH 3 (Truyền tham số vào Store Procedure)
-- Tham số loại IN
DELIMITER //

CREATE PROCEDURE getCusById

(IN cusNum INT(11))

BEGIN

  SELECT * FROM customers WHERE customerNumber = cusNum;

END //

DELIMITER ;

-- Gọi store procedure
call getCusById(175);

-- Tham số loại OUT
DELIMITER //

CREATE PROCEDURE GetCustomersCountByCity(

    IN  in_city VARCHAR(50),

    OUT total INT

)

BEGIN

    SELECT SUM(customerNumber)

    INTO total

    FROM customers

    WHERE city = in_city;

END//

DELIMITER ;
-- Gọi store procedure
CALL GetCustomersCountByCity('Berlin',@total);

SELECT @total;

-- Tham số loại INOUT
DELIMITER //

CREATE PROCEDURE SetCounter(

    INOUT counter INT,

    IN inc INT

)

BEGIN

    SET counter = counter + inc;

END//

DELIMITER ;
-- Gọi store procedure

SET @counter = 1;

CALL SetCounter(@counter,1); -- 2

CALL SetCounter(@counter,1); -- 3

CALL SetCounter(@counter,5); -- 8

SELECT @counter; -- 8

-- THỰC HÀNH View trong MySql
-- Tạo View có tên customer_views truy vấn dữ liệu từ bảng customers 
-- để lấy các dữ liệu: customerNumber, customerName, phone bằng câu lệnh SELECT:
CREATE VIEW customer_views AS

SELECT customerNumber, customerName, phone

FROM  customers;
-- Kết quả, ta sẽ có 1 bảng ảo customer_views, 
-- và sau đó chúng ta hoàn toàn có thể lấy dữ liệu từ bảng ảo này bằng lệnh:
select * from customer_views;

-- Cập nhật view khi thỏa mãn điều kiện trong bài thực hành 4.
CREATE OR REPLACE VIEW customer_views AS

SELECT customerNumber, customerName, contactFirstName, contactLastName, phone

FROM customers

WHERE city = 'Nantes';
-- Xóa view
DROP VIEW customer_views;