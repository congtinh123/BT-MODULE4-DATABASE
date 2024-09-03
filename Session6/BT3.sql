-- Tạo cơ sở dữ liệu và sử dụng
CREATE DATABASE Baitap3;
USE Baitap3;

-- Tạo bảng USERS
CREATE TABLE USERS (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    NAME VARCHAR(100) NOT NULL,
    ADDRESS VARCHAR(255) NOT NULL,
    PHONE VARCHAR(11) NOT NULL UNIQUE,
    DATEOFBIRTH DATE NOT NULL,
    STATUS BIT,
    BALANCE DOUBLE DEFAULT 0.0
);

-- Tạo bảng TRANSFER
CREATE TABLE TRANSFER (
    TRANSFER_ID INT PRIMARY KEY AUTO_INCREMENT,
    SENDER_ID INT,
    RECEIVER_ID INT,
    MONEY DOUBLE,
    TRANSFER_DATE DATE,
    FOREIGN KEY (SENDER_ID) REFERENCES USERS(ID),
    FOREIGN KEY (RECEIVER_ID) REFERENCES USERS(ID)
);

-- Định nghĩa thủ tục lưu trữ TransferMoney
DELIMITER //

CREATE PROCEDURE TransferMoney(IN sender_id INT, IN receiver_id INT, IN amount DOUBLE)
BEGIN
    DECLARE sender_balance DOUBLE;
    
    -- Bắt đầu giao dịch
    START TRANSACTION;

    -- Lấy số dư của người gửi
    SELECT BALANCE INTO sender_balance FROM USERS WHERE ID = sender_id;
    
    -- Kiểm tra số dư có đủ không
    IF sender_balance >= amount THEN
        -- Cập nhật số dư của người gửi và người nhận
        UPDATE USERS SET BALANCE = BALANCE - amount WHERE ID = sender_id;
        UPDATE USERS SET BALANCE = BALANCE + amount WHERE ID = receiver_id;

        -- Ghi lại giao dịch
        INSERT INTO TRANSFER (SENDER_ID, RECEIVER_ID, MONEY, TRANSFER_DATE)
        VALUES (sender_id, receiver_id, amount, CURDATE());

        -- Xác nhận giao dịch
        COMMIT;
    ELSE
        -- Hoàn tác nếu số dư không đủ
        ROLLBACK;
    END IF;
END //

DELIMITER ;
