#!/bin/bash

DB_USER=$(sed -n '1p' /etc/security/credentials.txt)
DB_PASSWORD=$(sed -n '1p' /etc/security/db_password.txt)
DB_ROOT_PASSWORD=$(sed -n '1p' /etc/security/db_root_password.txt)
WD_USER=$(sed -n '3p' /etc/security/credentials.txt)
WD_EMAIL=$(sed -n '6p' /etc/security/credentials.txt)
WD_PASSWORD=$(sed -n '9p' /etc/security/credentials.txt)
WD_USER_ADMIN=$(sed -n '4p' /etc/security/credentials.txt)
WD_EMAIL_ADMIN=$(sed -n '7p' /etc/security/credentials.txt)
WD_PASSWORD_ADMIN=$(sed -n '10p' /etc/security/credentials.txt)

until nc -z "${DB_HOST}" 3306; do
     echo "Waiting for MariaDB to be ready..."
     sleep 5
done

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not installed. Installing..."
    if ! wp core download --allow-root --locale=pt_BR --path=/var/www/html; then
        echo "Error: Failed to download WordPress."
        exit 1
    fi
    if ! wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create wp-config.php."
        exit 1
    fi
    if ! wp core install --url="${DOMAIN_NAME}" --title="${WD_TITLE}" --admin_user="${WD_USER_ADMIN}" --admin_password="${WD_PASSWORD_ADMIN}" --admin_email="${WD_EMAIL_ADMIN}" --skip-email --allow-root --path=/var/www/html; then
        echo "Error: Failed to install WordPress."
        exit 1
    fi
    if ! wp user create "${WD_USER}" "${WD_EMAIL}" --role=author --user_pass="${WD_PASSWORD}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create WordPress user."
        exit 1
    fi
    echo "WordPress installed successfully."
else
     echo "WordPress already installed."
fi

