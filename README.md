# Database shop

Тема курсового проекта: Описать модель хранения данных интернет-магазина Ozon.
 
 ### В проекте содержится: ###
 * таблица пользователей;
 * таблица товаров, к ней присоединены таблицы бренда, категории, каталога, типа, фото товаров;
 * таблица заказов;
 * таблица отзывов;
 * минимальное количество таблиц - 10;
 * скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами)
 * ERDiagram для БД;
    
### Пользователи могут: ###
* добавлять товары в заказ;
* писать отзывы на товары; 
* С помощью скрипта выборки можно отсеять отзывы на конкретный товар;
* С помощью представлений увидеть товары только из России или увидеть категорию товара и каталог, в котором он находится;
* Процедура добавляет новое значение name в таблицу brand;
* Триггер запрещает удалять записи в таблице каталога;
 

![preview](https://github.com/Victoria-Rozhkova/database-shop/blob/preview/preview.JPG)