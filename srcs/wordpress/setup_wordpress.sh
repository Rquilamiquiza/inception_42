#!/bin/bash

#apt-get update && apt-get install -y mariadb-client
while ! mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}"; do
     echo "Waiting for MariaDB to be ready..."
     sleep 5
done
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not installed. Installing..."
    if ! wp core download --allow-root --locale=pt_BR --path=/var/www/html; then
        echo "Error: Failed to download WordPress."
        exit 1
    fi    if ! wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create wp-config.php."
        exit 1
    fi    if ! wp core install --url="${DOMAIN_NAME}" --title="${WD_TITLE}" --admin_user="${WD_USER_ADMIN}" --admin_password="${WD_PASSWORD_ADMIN}" --admin_email="${WD_EMAIL_ADMIN}" --skip-email --allow-root --path=/var/www/html; then
        echo "Error: Failed to install WordPress."
        exit 1
    fi    if ! wp user create "${WD_USER}" "${WD_EMAIL}" --role=author --user_pass="${WD_PASSWORD}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create WordPress user."
        exit 1
    fi
    echo "WordPress installed successfully."
else
     echo "WordPress already installed."
fi

