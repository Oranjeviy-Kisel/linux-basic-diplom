#! /bin/bash

# Считаем, что у VM настроена корректная статика ip в конфиге netplan и выход в интернет
# выводим успешное начало работы скрипта
echo 'Hello from host @06-monitor, beginning to install'


# проверяем актуальность apt update
apt update


# Устанавливается Prometheus
if [[ $? -eq 0 ]]; then
  echo "Installing Prometheus"
  apt install prometheus -y
fi


# импортируем конфиги из скачанной с гита папки 06-monitor в Prometheus, предварительно удалив старые
rm -rf /etc/prometheus/prometheus.yml 
cp ./prometheus.yml /etc/prometheus/prometheus.yml
chmod 777 /etc/prometheus/prometheus.yml


# Сначала устанавиливаем Package musl , на который будет ругаться Grafana
apt install musl -y


# Устанавливаем Grafana из локального пакета из скачанной с гита папки
dpkg -i ./grafana_11.2.2_amd64-224190-b9e9cd.deb


# Копируем конфиг датасорса с именем из папки с гита
cp ./main.yml /etc/grafana/provisioning/datasources/main.yml
chmod 777 /etc/grafana/provisioning/datasources/main.yml


# рестартуем 
systemctl daemon-reload

systemctl start prometheus
# systemctl status prometheus

systemctl enable prometheus

systemctl start grafana-server
# systemctl status grafana-server
 

exit



# тут prometheus-node-exporter на web-сервере
# curl http://10.100.10.5:9100/metrics

# тут Prometheus
# curl http://localhost:9090/metrics

# тут Grafana
# curl http://localhost:3000/login

#_____________________________________________
# Настройка Grafana

# Confuguration - Data sources - уже импортирована конфигом ранее, только выбрать
# Add data source - Prometheus
# URL http://localhost:9090
# Save & test

# выбрать дашборд - с локальной папки с гита import файл node-exporter-full.json

#exit
