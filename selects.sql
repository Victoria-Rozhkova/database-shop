
/* 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы); */

-- Выборка отзывов на товар

-- Вложенный запрос
SELECT (SELECT CONCAT(u.firstname, ' ', u.lastname) FROM users u WHERE id=r.users_id) AS `user`, 
(SELECT p.name FROM product p WHERE id=r.product_id ) AS product, 
r.body AS review
FROM reviews r WHERE product_id = 1
GROUP BY `user`; -- отзывы на Смартфон Samsung Galaxy A32 4/64GB, черный


-- JOIN
SELECT CONCAT(u.firstname, ' ', u.lastname) AS `user`, p.name AS product, r.body AS review
FROM reviews r
JOIN users u ON r.users_id = u.id
JOIN product p ON r.product_id = p.id
WHERE product_id = 2
GROUP BY `user`;  -- отзывы на Смартфон Xiaomi Redmi 9 4/64GB, серый



/* 7. представления (минимум 2); */

-- 1  Показывает только Российские товары из категории "комьютеры и комплектующие"

DROP VIEW IF EXISTS russian_products;
CREATE OR REPLACE VIEW russian_products AS
SELECT id, name AS product_name, country, price, category_id
FROM product
WHERE country = 'Россия' AND category_id = 2;

SELECT * FROM russian_products;

-- 2  Выводит категорию товара и название каталога, в котором он находится

DROP VIEW IF EXISTS category_product;
CREATE VIEW category_product AS 
SELECT product.name AS product_name, category.name AS category_name, `catalog`.name AS catalog_name FROM product
JOIN category ON product.category_id = category.id
JOIN `catalog` ON product.catalog_id = `catalog`.id;

SELECT * FROM category_product;



/* 8. хранимые процедуры / триггеры; */

-- 1  Добавляет новое значение name в таблицу brand

DROP PROCEDURE IF EXISTS `Add`; 
delimiter //
CREATE PROCEDURE `Add`(IN name VARCHAR(255))
BEGIN
  INSERT INTO brand (name) VALUES (name);
END //
delimiter ;

CALL `Add`('Blackton');

-- 2  Запрещает удалять записи в таблице каталога (их 10)

DROP TRIGGER IF EXISTS check_last_catalog; 
DELIMITER //
CREATE TRIGGER check_last_catalog BEFORE DELETE ON `catalog`
FOR EACH ROW 
BEGIN
DECLARE total INT;
SELECT COUNT(*) INTO total FROM `catalog`;
  IF total = 10 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  END IF;
END//
DELIMITER ;

DELETE FROM `catalog` WHERE id=10; -- [45000]: DELETE canceled


