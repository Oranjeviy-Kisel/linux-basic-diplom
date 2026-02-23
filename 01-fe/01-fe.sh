#! /bin/bash

# Необходимо, чтобы была настроена корректная статика ip в конфиге netplan и у VM выход в интернет

echo 'Hello from host @01-fe, beginning to install'

# проверяем актуальность apt update
apt update

echo $?

