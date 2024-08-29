create database Baitap1;
use Baitap1;

create table customer(
    cid int primary key auto_increment,
    cName varchar(255),
    cAge int
);

create table orders(
    oid int primary key auto_increment,
    cid int,
    oDate date,
    oTotalPrice double,
    foreign key (cid) references customer(cid)
);

create table products(
    pid int primary key auto_increment,
    pName varchar(255),
    pPrice double
);

create table orderDetail(
    oid int,
    pid int,
    odQuantity int,
    foreign key (oid) references orders(oid),
    foreign key (pid) references products(pid)
);

insert into customer(cName, cAge) values 
("Minh Quan", 10),
("Ngoc Oanh", 20),
("Hong Ha", 30);

insert into orders(cid, oDate, oTotalPrice) values
(1, str_to_date('21/03/2006', '%d/%m/%Y'), 150000),
(2, str_to_date('23/03/2006', '%d/%m/%Y'), 200000),
(1, str_to_date('16/03/2006', '%d/%m/%Y'), 170000);

insert into products(pName, pPrice) values
("May giat", 300),
("Tu lanh", 500),
("Dieu hoa", 700),
("Quat", 100),
("Bep dien", 200),
("May hut bui", 500);

insert into orderDetail(oid, pid, odQuantity) values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 8),
(2, 3, 3);



CREATE VIEW view_all_customers AS
SELECT * FROM customer WHERE cAge >= 0;


CREATE VIEW view_orders_above_150000 AS
SELECT * FROM orders
WHERE oTotalPrice > 150000
ORDER BY oTotalPrice DESC;


CREATE FULLTEXT INDEX idx_customer_name_fulltext ON customer(cName);


CREATE FULLTEXT INDEX idx_product_name_fulltext ON products(pName);

DELIMITER //

CREATE PROCEDURE get_min_total_order()
BEGIN
    SELECT o.* 
    FROM orders o
    JOIN (
        SELECT MIN(oTotalPrice) AS min_price FROM orders
    ) AS subquery ON o.oTotalPrice = subquery.min_price;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE get_customers_min_quantity_for_product()
BEGIN
    SELECT c.cid, c.cName
    FROM customer c
    JOIN orders o ON c.cid = o.cid
    JOIN orderDetail od ON o.oid = od.oid
    JOIN products p ON od.pid = p.pid
    WHERE p.pName = 'May giat'
    GROUP BY c.cid, c.cName
    HAVING SUM(od.odQuantity) = (
        SELECT MIN(total_quantity)
        FROM (
            SELECT c.cid, SUM(od.odQuantity) AS total_quantity
            FROM customer c
            JOIN orders o ON c.cid = o.cid
            JOIN orderDetail od ON o.oid = od.oid
            JOIN products p ON od.pid = p.pid
            WHERE p.pName = 'May giat'
            GROUP BY c.cid
        ) AS subquery
    );
END //

DELIMITER ;
