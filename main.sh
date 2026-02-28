#! /bin/bash

# git clone c репозитория уже был сделан, зашли в скачанную папку.
# Запускаем общий скрипт main.sh, который проверяет имя виртуалки заносит в переменную   
VM_NAME=`hostname`


# проверяет есть ли в скачанных папка с названием текущей виртуалки (напр 01-fe)
# если есть, заходит в папку, запускает внутри папки скрипт настройки
# if [[ ${VM_NAME} && -d "/mnt/diplom/${VM_NAME}" ]]; then 

if [[ ${VM_NAME} && -d "./${VM_NAME}" ]]; then
  echo "Found dir $VM_NAME ... Starting script"
  sleep 1s  
  cd ./$VM_NAME
  # даем права на выполнение
  chmod 755 ./${VM_NAME}.sh
  # запускаем скрипт
  ./${VM_NAME}.sh
  #/mnt/diplom/${VM_NAME}/${VM_NAME}.sh
  #exit $?
else
  echo "directory not found, try to download"
  cd ~
  exit 1 
fi
