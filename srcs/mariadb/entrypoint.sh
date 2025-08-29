#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --user=mysql --skip-networking --datadir=/var/lib/mysql &

while ! mysqladmin ping -h"localhost" --silent; do
    sleep 1
done

mysql -u root <<EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOSQL

/docker-entrypoint-initdb.d/init_db.sh

mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown

# Iniciar como processo principal (PID 1)
exec mysqld --user=mysql --datadir=/var/lib/mysql
