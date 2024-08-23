-- Create Database quanlythanhmonsang;
-- tạo và xóa Database
Create Database if not exists quanlibanhang;
DROP DATABASE quanlibanhang;
-- tạo và xóa bảng
-- USE quanlythanhmonsang(trỏ vào database tạo bảng)
CREATE TABLE sangMom (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
 DROP TABLE sangMom;