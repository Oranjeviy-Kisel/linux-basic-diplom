#! /bin/bash

# Даем привилегии на чтение одной новой базы для юзера repl

mysql -uroot -p123 -e "GRANT SELECT, SHOW VIEW ON my_new_db.* TO 'repl'@'%';"
# mysql -uroot -p123 -e "GRANT SELECT ON *.* TO 'repl'@'%';"


# Перезагружаем привилегии
mysql -uroot -p123 -e "FLUSH PRIVILEGES;"

#перезапустить сервер
service mysql restart

#Создаем базу данных:

mysql -uroot -p123 -e "CREATE DATABASE my_new_db\G"

#USE my_new_db;
mysql -uroot -p123 -e "CREATE TABLE my_new_db.Products (Id INT AUTO_INCREMENT PRIMARY KEY, ProductName VARCHAR(30) NOT NULL, Manufacturer VARCHAR(20) NOT NULL);"
mysql -uroot -p123 -e "INSERT my_new_db.Products(ProductName, Manufacturer) VALUES ('iPhone X', 'Apple');"
mysql -uroot -p123 -e "INSERT my_new_db.Products(ProductName, Manufacturer) VALUES ('Galaxy S300', 'Samsung');"
