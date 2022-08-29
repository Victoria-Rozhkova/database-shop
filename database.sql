
-- Тема курсового проекта: Описать модель хранения данных интернет-магазина Ozon.

/* 1. Составить общее текстовое описание БД и решаемых ею задач; */

/* Суть проекта - упрощенная модель хранения данных интернет-магазина Ozon.
 
 В базе содержится:
 * таблица пользователей;
 * таблица товаров, к ней присоединены таблицы бренда, категории, каталога, типа, фото товаров;
 * таблица заказов;
 * таблица отзывов;
    
Пользователи могут:
* добавлять товары в заказ;
* писать отзывы на товары; 
 

* С помощью скрипта выборки можно отсеять отзывы на конкретный товар;
* С помощью представлений увидеть товары только из России или увидеть категорию товара и каталог, в котором он находится;
* Процедура добавляет новое значение name в таблицу brand;
* Триггер запрещает удалять записи в таблице каталога;
 
*/

-- 2. минимальное количество таблиц - 10;
-- 3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);

DROP DATABASE IF EXISTS ozon;
CREATE DATABASE ozon;
USE ozon;

DROP TABLE IF EXISTS users; -- Пользователи
CREATE TABLE users(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
firstname VARCHAR(100) NOT NULL,
lastname VARCHAR(100) NOT NULL,
email VARCHAR(120) NOT NULL UNIQUE,
password_host VARCHAR(100), 
phone BIGINT(12) UNSIGNED UNIQUE NOT NULL
);

DROP TABLE IF EXISTS `catalog`; -- Каталог
CREATE TABLE `catalog`(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS category; -- Категория товара
CREATE TABLE category(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name VARCHAR(100) NOT NULL,
discount TINYINT UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS type_product; -- Тип товара
CREATE TABLE type_product(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS photo_product; -- Медиа
CREATE TABLE photo_product(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
filename VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS img_product; -- Фото товара
CREATE TABLE img_product(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
photo_product BIGINT(20) UNSIGNED NOT NULL,
product_id BIGINT(20) UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS product; -- Товар 
CREATE TABLE product(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name VARCHAR(100) NOT NULL,
country VARCHAR(100) NOT NULL,
price BIGINT(20) UNSIGNED NOT NULL,
catalog_id BIGINT(20) UNSIGNED NOT NULL,
category_id BIGINT(20) UNSIGNED NOT NULL,
type_product_id BIGINT(20) UNSIGNED NOT NULL,
quantity BIGINT(20) UNSIGNED NOT NULL,
brand_id BIGINT(20) UNSIGNED NOT NULL,
photo_product BIGINT(20) UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS brand; -- Бренд
CREATE TABLE brand(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS reviews; -- Отзывы
CREATE TABLE reviews(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
product_id BIGINT(20) UNSIGNED NOT NULL,
users_id BIGINT(20) UNSIGNED NOT NULL,
body TEXT,
created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS order_products; -- Заказ
CREATE TABLE order_products(
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
users_id BIGINT(20) UNSIGNED NOT NULL,
quantity BIGINT(20) UNSIGNED NOT NULL,
created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS `order`; -- Товар в заказе
CREATE TABLE `order`(
product_id BIGINT(20) UNSIGNED NOT NULL,
order_products BIGINT(20) UNSIGNED NOT NULL,
PRIMARY KEY (product_id, order_products)
);

ALTER TABLE ozon.product ADD CONSTRAINT product_FK FOREIGN KEY (catalog_id) REFERENCES ozon.`catalog`(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.product ADD CONSTRAINT product_FK_1 FOREIGN KEY (category_id) REFERENCES ozon.category(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.product ADD CONSTRAINT product_FK_2 FOREIGN KEY (brand_id) REFERENCES ozon.brand(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.product ADD CONSTRAINT product_FK_3 FOREIGN KEY (type_product_id) REFERENCES ozon.type_product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.product ADD CONSTRAINT product_FK_4 FOREIGN KEY (photo_product) REFERENCES ozon.photo_product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.reviews ADD CONSTRAINT reviews_FK FOREIGN KEY (product_id) REFERENCES ozon.product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.reviews ADD CONSTRAINT reviews_FK_1 FOREIGN KEY (users_id) REFERENCES ozon.users(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.img_product ADD CONSTRAINT img_product_FK FOREIGN KEY (product_id) REFERENCES ozon.product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.img_product ADD CONSTRAINT img_product_FK_1 FOREIGN KEY (photo_product) REFERENCES ozon.photo_product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.order_products ADD CONSTRAINT order_products_FK FOREIGN KEY (users_id) REFERENCES ozon.users(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.`order` ADD CONSTRAINT order_FK FOREIGN KEY (product_id) REFERENCES ozon.product(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ozon.`order` ADD CONSTRAINT order_FK_1 FOREIGN KEY (order_products) REFERENCES ozon.order_products(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- 4. создать ERDiagram для БД; (в файле)
-- 5. скрипты наполнения БД данными;

INSERT users (firstname, lastname, email, phone) 
VALUES
('Isabel', 'Sheldon', 'mail1@example.org', '+79027887766'),
('Maks', 'Piton', 'mail2@example.org', '+79027887767'),
('Lilit', 'Jackson', 'mail3@example.org', '+79027887768'),
('Sam', 'Unckle', 'mail4@example.org', '+79027887769'),
('Jessica', 'Swon', 'mail5@example.org', '+79027887770'),
('Veronika', 'Daison', 'mail6@example.org', '+79027887771'),
('Kevin', 'Marlo', 'mail7@example.org', '+79027887772'),
('Bob', 'Klaus', 'mail8@example.org', '+79027887773'),
('Alex', 'Stone', 'mail9@example.org', '+79027887774'),
('Inna', 'Kuper', 'mail10@example.org', '+79027887775');

INSERT `catalog` (name) 
VALUES
('Электроника'),
('Одежда'),
('Обувь'),
('Дом и сад'),
('Детские товары'),
('Красота и здоровье'),
('Бытовая техника'),
('Спорт и отдых'),
('Строительство и ремонт'),
('Товары для животных');

INSERT category (name, discount) 
VALUES
('Телефоны и смарт-часы', '5'),
('Компьютеры и комлектующие', '0'),
('Телевизоры и видеотехника', '0'),
('Мужчинам', '0'),
('Женщинам', '0'),
('Детям', '15'),
('Мужчинам', '0'),
('Женщинам', '0'),
('Детям', '25'),
('Посуда', '5'),
('Текстиль', '0'),
('Цветы и растения', '0'),
('Игрушки и игры', '0'),
('Детское питание', '10'),
('Коляски и автокресла', '0'),
('Макияж', '10'),
('Уход за волосами', '0'),
('Парфюмерия', '5'),
('Крупная бытовая техника', '25'),
('Встраиваемая бытовая техника', '0'),
('Климатическая техника', '15'),
('Тренажеры и фитнес', '0'),
('Самокаты, гироскутеры и моноколеса', '0'),
('Велосипеды, экипировка и запчасти', '10'),
('Инструменты', '0'),
('Отделочные материалы', '0'),
('Крепеж и фурнитура', '0'),
('Для кошек', '0'),
('Для собак', '0'),
('Ветаптека', '5');

INSERT type_product (name) 
VALUES
('Смартфоны'),
('SIM карты'),
('Смарт-часы и фитнес-браслеты'),
('Системные блоки'),
('Моноблоки'),
('Комплектующие'),
('Телевизоры'),
('Кронштейны'),
('Медиароигрыватели'),
('Джинсы'),
('Брюки'),
('Спортивная одежда'),
('Блузы и рубашки'),
('Верхняя одежда'),
('Домашняя одежда'),
('Девочкам'),
('Мальчикам'),
('Новорожденным'),
('Кеды, кроссовки и слипоны'),
('Ботинки и полуботинки'),
('Домашняя обувь'),
('Балетки'),
('Босоножки'),
('Ботильоны'),
('Девочкам'),
('Мальчикам'),
('Школа'),
('Столовая посуда'),
('Детская посуда'),
('Одноразовая посуда'),
('Шторы и карнизы'),
('Постельное белье'),
('Полотенца'),
('Цветы'),
('Семена и саженцы'),
('Горшки и кашпо'),
('Конструкторы'),
('Куклы и аксессуары'),
('Мягкие игрушки'),
('Каши'),
('Пюре'),
('Напитки'),
('Коляски'),
('Автокресла'),
('Удерживающие устройства'),
('Глаза'),
('Брови'),
('Губы'),
('Шампуни и кондиционеры'),
('Маски и сыворотки'),
('Средства для укладки'),
('Парфюмерная вода'),
('Туалетная вода'),
('Одеколоны'),
('Холодильники'),
('Плиты'),
('Стиральные машины'),
('Посудомойки'),
('Духовые шкафы'),
('Варочные панели'),
('Кондиционеры и сплит-системы'),
('Вентиляторы'),
('Водонагреватели'),
('Кардиотренажеры'),
('Йога и пилатес'),
('Бодибилдинг'),
('Электросамокаты'),
('Гироскутеры'),
('Моноколеса и сигвеи'),
('Велосипеды'),
('Экипировка'),
('Запчасти'),
('Электроинструменты'),
('Ручной инструмент'),
('Силовая техника и оборудование'),
('Гибкий камень'),
('Обои и покрытия'),
('Напольные покрытия'),
('Фурнитура для мебели'),
('Крепежные изделия, метизы'),
('Неодимовые магниты'),
('Корма и лакомства'),
('Туалеты и наполнители'),
('Когтеточки и игровые комплексы'),
('Груминг'),
('Матрасы и лежаки'),
('Игрушки'),
('Витамины'),
('Лечебные ошейники'),
('Воротники');

INSERT photo_product (filename) 
VALUES
('98766.img'),
('234667.img'),
('764432.img'),
('098776.img'),
('31234.img'),
('8767877.img'),
('644347.img'),
('436900.img'),
('120978.img'),
('86764.img'),
('43680.img'),
('18640.img'),
('789007.img'),
('34689.img'),
('2319767.img'),
('764433.img'),
('90764.img'),
('634908.img'),
('06438.img'),
('324468.img'),
('89743.img'),
('32470.img'),
('49956.img'),
('32126.img'),
('98763.img'),
('21421.img'),
('9764343.img'),
('6764342.img'),
('331087.img'),
('6996400.img'),
('43689.img'),
('766460.img'),
('11470.img'),
('9655343.img'),
('554329.img'),
('87559.img'),
('176708.img'),
('235578.img'),
('097342.img'),
('6755987.img'),
('434899.img'),
('64231.img'),
('78904.img'),
('3112879.img'),
('466754.img'),
('670215.img'),
('189534.img'),
('64234.img'),
('324889.img'),
('411955.img'),
('568983.img'),
('22876.img'),
('57243.img'),
('987213.img'),
('31297.img'),
('16763.img'),
('437812.img'),
('16795.img'),
('673231.img'),
('57609.img'),
('31476.img'),
('47883.img'),
('458821.img'),
('34808.img'),
('21678.img'),
('89432.img'),
('45320.img'),
('29046.img'),
('50932.img'),
('72947.img'),
('185033.img'),
('476541.img'),
('006432.img'),
('74309.img'),
('31874.img'),
('83045.img'),
('21686.img'),
('845025.img'),
('873049.img'),
('2965530.img'),
('487205.img'),
('690471.img'),
('318055.img'),
('834016.img'),
('10945.img'),
('75198.img'),
('52085.img'),
('329051.img'),
('162901.img'),
('480215.img');


INSERT brand (name) 
VALUES
('Samsung'),
('Xiaomi'),
('Poco X3 Pro'),
('Ростелеком'),
('Мегафон'),
('Tele2'),
('Robotcomp'),
('Oldi Computers'),
('Aio'),
('Acer'),
('ALFA'),
('STEEL'), -- 12 
('Toshiba'),
('Kingston'),
('Blackton'),
('LG');

INSERT product (name, country, price, catalog_id, category_id, type_product_id, quantity, brand_id, photo_product) 
VALUES
('Смартфон Samsung Galaxy A32 4/64GB, черный', 'Вьетнам', '19980', '1', '1', '1', '65', '1', '1'),
('Смартфон Xiaomi Redmi 9 4/64GB, серый', 'Китай', '13980', '1', '1', '1', '93', '2', '2'),
('Смартфон Poco X3 Pro 8/256GB, черный', 'Китай', '26980', '1', '1', '1', '115', '3', '3'),
('SIM-карта Ростелеком', 'Россия', '600', '1', '1', '2', '34', '4', '4'),
('SIM-карта Мегафон', 'Россия', '1190', '1', '1', '2', '86', '5', '5'),
('SIM-карта Tele2', 'Россия', '300', '1', '1', '2', '79', '6', '6'),
('Фитнес-браслет Xiaomi Mi Band 6, черный', 'Китай', '3990', '1', '1', '3', '87', '2', '7'),
('Фитнес-браслет Smart X Band M5', 'Китай', '2490', '1', '1', '3', '65', '2', '8'),
('Фитнес-браслет Xiaomi Smart Band 4 NFC, черный', 'Китай', '3290', '1', '1', '3', '54', '2', '9'),
('Системный блок Robotcomp Старт, черный', 'Россия', '45328', '1', '2', '4', '38', '7', '10'),
('Системный блок Oldi Computers ПЭВМ OLDI OFFICE 0759869, черный', 'Россия', '15990', '1', '2', '4', '60', '8', '11'),
('Системный блок Robotcomp Аллигатор V2, черный', 'Россия', '69613', '1', '2', '4', '49', '7', '12'),
('24" Моноблок Aio DG24 24"/Core i5/8GB/SSD 256GB (14-21)', 'Южная Корея', '49000', '1', '2', '5', '109', '9', '13'),
('21.5" Моноблок Acer Z4640G_DOS (DQ.VPGER.070)', 'Китай', '44900', '1', '2', '5', '42', '10', '14'),
('24" Моноблок ALFA I5-520M, SSD 480Gb', 'Россия', '57500', '1', '2', '5', '87', '11', '15'),
('Термопаста STEEL Frost Zink STP-1', 'Россия', '799', '1', '2', '6', '62', '12', '16'),
('1 ТБ Внешний жесткий диск Toshiba Canvio basics, черный', 'Китай', '3900', '1', '2', '6', '98', '13', '17'),
('240 ГБ Внутренний SSD диск Kingston A400', 'Китай', '2790', '1', '2', '6', '76', '14', '18'),
('Full HD Телевизор Blackton BT 42S02B 42', 'Россия', '20990', '1', '3', '7', '110', '15', '19'),
('HD Телевизор Xiaomi Mi TV 4A 32', 'Россия', '18990', '1', '3', '7', '79', '2', '20'),
('Телевизор LG 50NANO806PA 50', 'Россия', '59990', '1', '3', '7', '56', '16', '21');

INSERT img_product (photo_product, product_id) 
VALUES
('1', '1'),
('2', '1'),
('3', '1'),
('4', '2'),
('5', '2'),
('6', '2'),
('7', '3'),
('8', '3'),
('9', '3'),
('10', '4'),
('11', '4'),
('12', '4'),
('13', '5'),
('14', '5'),
('15', '5'),
('16', '6'),
('17', '6'),
('18', '6'),
('19', '7'),
('20', '7'),
('21', '7'),
('22', '8'),
('23', '8'),
('24', '8'),
('25', '9'),
('26', '9'),
('27', '9'),
('28', '10'),
('29', '10'),
('30', '10'),
('31', '11'),
('32', '11'),
('33', '11'),
('34', '12'),
('35', '12'),
('36', '12'),
('37', '13'),
('38', '13'),
('39', '13'),
('40', '14'),
('41', '14'),
('42', '14'),
('43', '15'),
('44', '15'),
('45', '15'),
('46', '16'),
('47', '16'),
('48', '16'),
('49', '17'),
('50', '17'),
('51', '17'),
('52', '18'),
('53', '18'),
('54', '18'),
('55', '19'),
('56', '19'),
('57', '19'),
('58', '20'),
('59', '20'),
('60', '20'),
('61', '21'),
('62', '21'),
('63', '21');

INSERT order_products (users_id, quantity) 
VALUES
('1', '1'),
('1', '1'),
('2', '1'),
('3', '2'),
('4', '1'),
('4', '1'),
('4', '1'),
('5', '1'),
('6', '1'),
('7', '1'),
('2', '1'),
('10', '2'),
('8', '1'),
('3', '1'),
('9', '2');

INSERT `order` (product_id, order_products) 
VALUES
('1', '1'),
('6', '2'),
('7', '3'),
('16', '4'),
('17', '5'),
('10', '6'),
('16', '7'),
('8', '8'),
('2', '9'),
('9', '10'),
('2', '11'),
('3', '12'),
('14', '13'),
('18', '14'),
('5', '15');

INSERT reviews (product_id, users_id, body) 
VALUES
('1', '1', 'Понравился телефон, обьем большой. До этого брала honor 8x(64гб), вечно не хватало памяти для фоток, видео, приложений и документов. А сейчас одно удовольствие пользоваться.  '),
('2', '6', 'Выбира между двумя моделями Xiaomi. Выбор в пользу этой модели. Сдесь больше циферблат задействован. Он более яркий и зрячий. Функционал расширен.'),
('9', '7', 'Понятное подключение. В инструкции описания всего занимает несколько листков. Никаких проблем ни на каком этапе не возникло. Карта тинькофф законектилась сразу. В магазине оплата прошла без сюрпризов.'),
('18', '3', 'Работоспособность ПК увеличил в двое. Отличный диск.'),
('10', '4', 'Видеокарта без охлаждения, оперативной памяти маловато'),
('8', '5', 'Пользуюсь уже неделю, достаточно хорошо работает. Часы отличные'),
('14', '8', 'Здровенный дисплей, как у небольшого телека, очень шустрый процессор для этой цены.'),
('2', '2', 'Классный телефон. Функциональный, качество изображения отличное, лёгкий, тонкий.'),
('16', '3', 'Хорошая проводимость и достаточное количество'),
('16', '4', 'Однозначно рекомендую');
