#! /bin/bash

#git clone уже был сделан или делаем?

# Заходим в скачанную папку проекта с git'a, запускаем общий скрипт main.sh, который проверяет имя виртуалки,   

VM_NAME=`hostname`

if [[ ${VM_NAME} && -d "./${VM_NAME}" ]]; then
  echo "Found dir $VM_NAME ... Starting script"
  sleep 1s  
  cd /mnt/diplom/$VM_NAME
  ./${VM_NAME}.sh
  #/mnt/diplom/${VM_NAME}/${VM_NAME}.sh
  #exit $?
# проверяет есть ли в скачанных папка с названием текущей виртуалки (напр 01-fe)
# запускает внутри папки скрипт настройки
else
  echo "directory not found, try to download"
  cd ~
  exit 1 
fi




#DIR=`cd \`dirname $0\`; pwd`

#IMAGE=ag43_st_kc3_4G_softmdz_1
#FLASH=platform_flash.sh
#${DIR}/${FLASH} ${IMAGE}
#exit $?





#fe_ip=192.168.1.77
#fe_root="root@192.168.1.77"

#echo "ps -afx | grep -i angie" | ssh root@$fe_ip

# Source - https://stackoverflow.com/a/29035642
# Posted by Petr Skocik
# Retrieved 2026-01-31, License - CC BY-SA 3.0

#ssh -o ConnectTimeout=10 $1 'echo hello world' 

#ssh -o ConnectTimeout=10 $fe_root 'ps -afx | grep -i angie'
 

