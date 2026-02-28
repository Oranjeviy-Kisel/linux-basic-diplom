#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @04-sql-source, beginning to install'


# проверяем актуальность apt update
apt update


# Устанавливается сервер базы данных MySQL
if [[ $? -eq 0 ]]; then
  echo "Installing mysql-server-8.0..."
  apt install -y mysql-server-8.0
fi


# убиваем старый конфиг и копируем новый с папки с репозитория
rm -rf /etc/mysql/mysql.conf.d/mysqld.cnf
cp ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
chmod 755 /etc/mysql/mysql.conf.d/mysqld.cnf


#Рестартуем 
systemctl restart mysql


# тестируем доступ и если есть доступ к бд, если есть база mysql, то 
# устанавливаем пароль на рута базы данных, создаем юзера repl, даем права
if [[ `mysql -uroot -e "SHOW DATABASES;"  | cat - | grep mysql` -eq "mysql" ]]; 
  then 
    echo "all good, creating users root, repl"
    mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '123';"
fi


# создаем юзера repl с любого хоста,  
mysql -uroot -p123 -e "CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '1234';"


# Перезагружаем привилегии
mysql -uroot -p123 -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%';"
mysql -uroot -p123 -e "FLUSH TABLES WITH READ LOCK;"


# Рестартуем
service mysql restart
