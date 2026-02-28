#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @02-be, beginning to install'

# проверяем актуальность apt update
apt update


# Устанавливается веб-сервер Apache
if [[ $? -eq 0 ]]; then
  echo "Installing apache2..."
  apt install apache2 -y
fi


# Устанавливаются модули для работы php, mysql
apt install -y php libapache2-mod-php
apt install -y php-mysql


# импортируем конфиги из скачанной с гита папки 02-be в в Apache, предварительно удалив старые
rm -rf /etc/apache2/ports.conf
cp ./ports.conf /etc/apache2/ports.conf
chmod 755 /etc/apache2/ports.conf

rm -rf /etc/apache2/apache2.conf
cp ./apache2.conf /etc/apache2/apache2.conf
chmod 755 /etc/apache2/apache2.conf


# импортируем папку html из скачанной с гита папки 02-be в папку /var/www
rm -rf /var/www/html
cp ./html /var/www/html

# даем права на чтение
chmod 755 /var/www/html
chmod 755 /var/www/html/*


# рестартуем Apache
service apache2 restart


# проверяем, что все работает на запущенной машине curl'om
curl http://localhost:8080 2> /dev/null 1> /tmp/localhost

if [[ $(grep -i Apache /tmp/localhost | cut -d ":" -f 2 | cut -b 2-7) -eq "Apache" ]]; then echo "Apache server is running on port 8080 - You done it"; exit; fi
