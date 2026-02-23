#! /bin/bash

# Необходимо, чтобы была настроена корректная статика ip в конфиге netplan и у VM выход в интернет

echo 'Hello from host @01-fe, beginning to install'

# проверяем актуальность apt update
apt update

#echo $?

# Устанавливается веб-сервер NginX

apt install -y nginx

# проверить предыдущий exit-code предыдущей выполнившейся команды
# в случае успеха устанавливаем модуль мониторинга

if [[ "$?" -eq 0 ]]; 
  then
    apt install prometheus-node-exporter -y
fi


#устанавливается prometheus-node-exporter
# apt install prometheus-node-exporter

# ------------------------------------------------------ 

rm -rf /etc/nginx/sites-available/default
cp ./default /etc/nginx/sites-available/default
chmod 755 /etc/nginx/sites-available/default
chmod 755 /etc/nginx/sites-enabled/default

#/etc/nginx/nginx.conf


# рестартуем nginx
service nginx restart


#проверяем, что все работает на запущенной машине пингом
