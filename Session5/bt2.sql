CREATE DATABASE Baitap2;
USE Baitap2;


CREATE TABLE account (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    status BIT
);

CREATE TABLE bill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bill_type BIT,
    account_id INT,
    created DATETIME,
    auth_date DATETIME,
    FOREIGN KEY (account_id) REFERENCES account(id)
);

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created DATE,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status BIT
);

CREATE TABLE bill_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bill(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

INSERT INTO account(username, password, address, status) VALUES
('Hùng', 123456, 'Nghệ An', TRUE),
('Cường', 654321, 'Hà Nội', TRUE),
('Bách', 135790, 'Đà Nẵng', TRUE);

INSERT INTO bill(bill_type, account_id, created, auth_date) VALUES
(0, 1, STR_TO_DATE('11/02/2022', '%d/%m/%Y'), STR_TO_DATE('12/03/2022', '%d/%m/%Y')),
(0, 1, STR_TO_DATE('05/10/2023', '%d/%m/%Y'), STR_TO_DATE('10/10/2023', '%d/%m/%Y')),
(1, 2, STR_TO_DATE('15/05/2024', '%d/%m/%Y'), STR_TO_DATE('20/05/2024', '%d/%m/%Y')),
(1, 3, STR_TO_DATE('01/02/2022', '%d/%m/%Y'), STR_TO_DATE('10/02/2022', '%d/%m/%Y'));

INSERT INTO product(name, created, price, stock, status) VALUES
("Quần dài", STR_TO_DATE('12/03/2022', '%d/%m/%Y'), 1200, 5, TRUE),
("Áo dài", STR_TO_DATE('15/03/2023', '%d/%m/%Y'), 1500, 8, TRUE),
("Mũ cối", STR_TO_DATE('08/03/1999', '%d/%m/%Y'), 1600, 10, TRUE);

INSERT INTO bill_details(bill_id, product_id, quantity, price) VALUES
(1, 1, 3, 1200),
(2, 2, 4, 1500),
(3, 1, 1, 1200),
(4, 2, 4, 1500),
(4, 3, 7, 1600);

DELIMITER //

CREATE PROCEDURE get_accounts_with_5_or_more_bills()
BEGIN
    SELECT a.id, a.username, a.address, a.status
    FROM account a
    WHERE (SELECT COUNT(*) FROM bill b WHERE b.account_id = a.id) >= 5;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_unsold_products()
BEGIN
    SELECT p.id, p.name, p.price, p.stock
    FROM product p
    LEFT JOIN bill_details bd ON p.id = bd.product_id
    WHERE bd.id IS NULL;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_top_2_best_selling_products()
BEGIN
    SELECT p.id, p.name, COALESCE(SUM(bd.quantity), 0) AS total_sold
    FROM product p
    LEFT JOIN bill_details bd ON p.id = bd.product_id
    GROUP BY p.id, p.name
    ORDER BY total_sold DESC
    LIMIT 2;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE add_account(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_address VARCHAR(255),
    IN p_status BIT
)
BEGIN
    INSERT INTO account (username, password, address, status)
    VALUES (p_username, p_password, p_address, p_status);
    SELECT * FROM account WHERE username = p_username;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_bill_details(IN p_bill_id INT)
BEGIN
    SELECT bd.id, bd.product_id, bd.quantity, bd.price
    FROM bill_details bd
    WHERE bd.bill_id = p_bill_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE add_bill(
    IN p_bill_type BIT,
    IN p_account_id INT,
    IN p_created DATETIME,
    IN p_auth_date DATETIME
)
BEGIN
    INSERT INTO bill (bill_type, account_id, created, auth_date)
    VALUES (p_bill_type, p_account_id, p_created, p_auth_date);
    SELECT id AS new_bill_id FROM bill ORDER BY id DESC LIMIT 1;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_products_sold_more_than_5()
BEGIN
    SELECT p.id, p.name, COALESCE(SUM(bd.quantity), 0) AS total_sold
    FROM product p
    LEFT JOIN bill_details bd ON p.id = bd.product_id
    GROUP BY p.id, p.name
    HAVING total_sold > 5;
END //

DELIMITER ;
