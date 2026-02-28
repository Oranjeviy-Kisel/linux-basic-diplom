#! /bin/bash

echo 'Hello from host @05-sql-replica, beginning backup'

# проверяем актуальность apt update
#apt update

echo $(pwd)
echo $(date)
dt=$(date '+%d-%m-%Y-%H_%M_%S');
echo "$dt"

mkdir /home/backup-$dt


if [[ `mysql -uroot --skip-column-names -e "SHOW DATABASES;" | cat - | grep mysql` -eq "mysql" ]]; 
  then 
    echo "Database with name mysql found, creating backup"
    db="mysql"
    for t in `mysql -uroot -e "SHOW TABLES from $db" | cat -`;
      do
        mysqldump -uroot $db $t --add-drop-table --events --routines --master-data=2 > /home/backup-$dt/$t.sql
      done
    rm -rf /home/backup-$dt/Tables_in_*  
fi    


    


#for d in `mysql -uroot --skip-column-names -e "SHOW DATABASES;" | cat -`; 
  #do
    #echo $d 
    #mkdir /home/backup/$d
    #for t in `mysql -uroot -e "SHOW TABLES from $d" | cat -`;
      #do
        #mysqldump -uroot -pmy_Pass8$ $d $t --add-drop-table --events --routines --master-data=2 > /home/backup/$d/$t.sql
      #done

  #done
  
  
