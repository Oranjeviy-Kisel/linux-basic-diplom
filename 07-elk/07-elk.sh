#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @07-elk, beginning to install'


# проверяем актуальность apt update
apt update


# проверить exit-code предыдущей команды и установить jdk
if [[ "$?" -eq 0 ]]; 
  then
    apt install default-jdk -y
fi


# проверка exit-code предыдущей команды и установить из локального пакета elasticsearch
if [[ "$?" -eq 0 ]]; 
  then
    dpkg -i ./elasticsearch_8.17.1_amd64.deb 
fi


# Устанавливаем ограничения потребление памяти java для elastic-a 
touch /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xms1g" > /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xmx1g" >> /etc/elasticsearch/jvm.options.d/jvm.options


rm -rf /etc/elasticsearch/elasticsearch.yml
cp ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
chmod 755 /etc/elasticsearch/elasticsearch.yml

systemctl daemon-reload
systemctl enable --now elasticsearch.service


# Проверяем, что запустился Elastic
curl http://localhost:9200 2> /dev/null 1> /tmp/localhost
if [[ $(grep -m 1 cluster_name /tmp/localhost | cut -d ":" -f 2 | cut -b 3-15) -eq "Elasticsearch" ]]; then echo "Elasticsearch server is running - ok"; fi


# установить из локального пакета kibana
dpkg -i ./kibana_8.17.1_amd64.deb
systemctl daemon-reload
systemctl enable --now kibana.service


# скачать конфиги
rm -rf /etc/kibana/kibana.yml
cp ./kibana.yml /etc/kibana/kibana.yml
chmod 755 /etc/kibana/kibana.yml
systemctl restart kibana


# установить из локального пакета logstash
dpkg -i ./logstash_8.17.1_amd64.deb
systemctl enable --now logstash.service


# скачать конфиги
rm -rf /etc/logstash/logstash.yml
cp ./logstash.yml /etc/logstash/logstash.yml
chmod 755 /etc/logstash/logstash.yml

cp ./logstash-nginx-es.conf /etc/logstash/conf.d/logstash-nginx-es.conf
chmod 755 /etc/logstash/conf.d/logstash-nginx-es.conf
systemctl restart logstash.service


#exit
