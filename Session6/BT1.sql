-- Tạo cơ sở dữ liệu và sử dụng
CREATE DATABASE Baitap1;
USE Baitap1;

-- Tạo bảng users
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(11) NOT NULL UNIQUE,
    dateOfBirth DATE NOT NULL,
    status BIT
);

-- Tạo bảng products
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DOUBLE,
    stock INT,
    status BIT
);
-- Tạo bảng shopping_cart

CREATE TABLE shopping_cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    quantity INT,
    amount DOUBLE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Thêm dữ liệu vào bảng users
INSERT INTO users (name, address, phone, dateOfBirth, status) VALUES 
('Nguyen Thi Mai', '12 Đường Lộc Phát, Thành phố A', '0912345678', '1987-03-12', 1),
('Le Van Nam', '34 Đường Hà Nội, Thành phố B', '0923456789', '1990-07-22', 1),
('Bui Thi Lan', '56 Đường Phan Chu Trinh, Thành phố C', '0934567890', '1995-11-05', 1);


-- Thêm dữ liệu vào bảng products
INSERT INTO products (name, price, stock, status) VALUES 
('Sản phẩm X', 150.00, 40, 1),
('Sản phẩm Y', 250.00, 25, 1),
('Sản phẩm Z', 350.00, 15, 1);

-- Thêm dữ liệu vào bảng shopping_cart
INSERT INTO shopping_cart (user_id, product_id, quantity, amount) VALUES 
(1, 1, 3, 450.00),
(2, 2, 2, 500.00),
(3, 3, 1, 350.00);

-- Kiểm tra dữ liệu trong các bảng
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM shopping_cart;


-- Tạo Trigger khi thay đổi giá của sản phẩm thì amount (tổng giá) cũng sẽ phải cập nhật lại
DELIMITER //

CREATE TRIGGER update_amount_on_price_change
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    UPDATE shopping_cart
    SET amount = quantity * NEW.price
    WHERE product_id = NEW.id;
END;

//

DELIMITER ;

-- Tạo Trigger khi xóa product thì những dữ liệu ở bảng shopping_cart có chứa product bị xóa thì cũng phải xóa theo
DELIMITER //

CREATE TRIGGER delete_shopping_cart_entries_on_product_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN
    DELETE FROM shopping_cart
    WHERE product_id = OLD.id;
END;

//

DELIMITER ;

-- Khi thêm một sản phẩm vào shopping_cart với số lượng n thì bên product cũng sẽ phải trừ đi số lượng n
DELIMITER //

CREATE TRIGGER update_stock_on_cart_add
AFTER INSERT ON shopping_cart
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;
END;

//

DELIMITER ;
