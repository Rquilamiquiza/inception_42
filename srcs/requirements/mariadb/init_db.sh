#!/bin/bash

DB_PASSWORD=sed -n '1p' /etc/security/db_password.txt
DB_ROOT_PASSWORD=sed -n '1p' /etc/security/db_root_password.txt
DB_USER=sed -n 

while ! mysqladmin ping --silent; do
    sleep 1
done

mysql -u root -p"$DB_ROOT_PASSWORD" <<EOSQL
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOSQL
