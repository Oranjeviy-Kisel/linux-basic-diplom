#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @05-sql-replica, beginning to install'


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


# тестируем доступ и если есть доступ к бд, если есть база mysql, то настраиваем пользователя repl, кому дали права на мастере, и репликацию 
if [[ `mysql -uroot -e "SHOW DATABASES;"  | cat - | grep mysql` -eq "mysql" ]]; 
  then 
    echo "all is good, enabling REPLICA"
    # руту заводить пароль может не надо: mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '123';"
    # на всякий стоп реплику
    mysql -uroot -e "STOP REPLICA;"
    mysql -uroot -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='10.100.10.8', SOURCE_USER='repl', SOURCE_PASSWORD='1234', SOURCE_AUTO_POSITION = 0, GET_SOURCE_PUBLIC_KEY = 1;"    
    mysql -uroot -e "START REPLICA;"
fi


# выше при настройке реплики давало глобальную ошибку, поэтому сначала выставили 0, теперь выставляяем 1 и главное RESET
mysql -uroot -e "STOP REPLICA;"
mysql -uroot -e "RESET REPLICA;"
mysql -uroot -e "CHANGE REPLICATION SOURCE TO SOURCE_AUTO_POSITION = 1;"
mysql -uroot -e "START REPLICA;"


#Рестартуем 
systemctl restart mysql


# Добавляем скрипт бэкапа бд в Cron
touch /var/log/db-backup.log
apt install -y cron
systemctl enable --now cron
echo "Adding database backup script to crontab..."

# Бэкап - каждые 3 минуты запуск скрипта
echo '*/3 * * * * root /linux-basic-diplom/05-sql-replica/db-backup.sh >> /var/log/db-backup.log 2>&1' >> /etc/crontab

