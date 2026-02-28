#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @01-fe, beginning to install'


# проверяем актуальность apt update
apt update


# проверка exit-code предыдущей выполнившейся команды
# в случае успеха устанавливается веб-сервер NginX
if [[ "$?" -eq 0 ]]; 
  then
    apt install -y nginx
fi


# проверка exit-code предыдущей выполнившейся команды
# в случае успеха устанавливаем экспортер мониторинга
if [[ "$?" -eq 0 ]]; 
  then
    apt install -y prometheus-node-exporter 
fi
 

# Заменяем конфиги Nginx
rm -rf /etc/nginx/sites-available/default
cp ./default /etc/nginx/sites-available/default
chmod 755 /etc/nginx/sites-available/default
chmod 755 /etc/nginx/sites-enabled/default


# рестартуем Nginx
service nginx restart

# установка экспортера логов filebeat
dpkg -i ./filebeat_8.17.1_amd64.deb

rm -rf /etc/filebeat/filebeat.yml
cp ./filebeat.yml /etc/filebeat/filebeat.yml
chmod 755 /etc/filebeat/filebeat.yml
systemctl restart filebeat


#проверяем, что все работает на запущенной машине
curl http://localhost 2> /dev/null 1> /tmp/localhost
if [[ $(grep -i Server /tmp/localhost | cut -d ":" -f 2 | cut -b 2-6) -eq "nginx" ]]; then echo "Nginx server is running - You done it"; exit; fi

