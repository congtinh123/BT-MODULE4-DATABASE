-- Tạo cơ sở dữ liệu và sử dụng
CREATE DATABASE Baitap2;
USE Baitap2;

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

-- Transaction để thêm sản phẩm vào giỏ hàng với kiểm tra số lượng tồn kho
START TRANSACTION;

-- Cài đặt giá trị biến
SET @user_id = 1;
SET @product_id = 1;
SET @quantity = 3;

-- Kiểm tra số lượng tồn kho và cập nhật nếu đủ
IF (SELECT stock FROM products WHERE id = @product_id) >= @quantity THEN
    -- Cập nhật số lượng tồn kho
    UPDATE products
    SET stock = stock - @quantity
    WHERE id = @product_id;

    -- Thêm sản phẩm vào giỏ hàng
    INSERT INTO shopping_cart (user_id, product_id, quantity, amount)
    VALUES (@user_id, @product_id, @quantity, (SELECT price FROM products WHERE id = @product_id) * @quantity);

    COMMIT;
ELSE
    -- Nếu số lượng không đủ, rollback
    ROLLBACK;
END IF;

-- Transaction để xóa sản phẩm khỏi giỏ hàng và trả lại số lượng cho products
START TRANSACTION;

-- Cài đặt giá trị biến
SET @cart_item_id = 1;

-- Lấy thông tin sản phẩm từ giỏ hàng
SELECT product_id, quantity INTO @product_id, @quantity FROM shopping_cart WHERE id = @cart_item_id;

-- Xóa sản phẩm khỏi giỏ hàng
DELETE FROM shopping_cart WHERE id = @cart_item_id;

-- Cập nhật số lượng tồn kho
UPDATE products
SET stock = stock + @quantity
WHERE id = @product_id;

COMMIT;
