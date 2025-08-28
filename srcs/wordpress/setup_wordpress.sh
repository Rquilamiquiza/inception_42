#!/bin/sh

while ! mariadb -h"${MARIADB_HOST}" -u"${MARIADB_USER}" -p"$MARIADB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 5
done
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not installed. Installing..."    if ! wp core download --allow-root --locale=pt_BR --path=/var/www/html; then
        echo "Error: Failed to download WordPress."
        exit 1
    fi    if ! wp config create --dbname="${MARIADB_DATABASE}" --dbuser="${MARIADB_USER}" --dbpass="${MARIADB_PASSWORD}" --dbhost="${MARIADB_HOST}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create wp-config.php."
        exit 1
    fi    if ! wp core install --url="${DOMAIN_NAME}" --title="${WORDPRESS_DB_TITLE}" --admin_user="${WORDPRESS_DB_USER_ADMIN}" --admin_password="${WORDPRESS_DB_PASSWORD_ADMIN}" --admin_email="${WORDPRESS_DB_EMAIL_ADMIN}" --skip-email --allow-root --path=/var/www/html; then
        echo "Error: Failed to install WordPress."
        exit 1
    fi    if ! wp user create "${WORDPRESS_DB_USER}" "${WORDPRESS_DB_EMAIL}" --role=author --user_pass="${WORDPRESS_DB_PASSWORD}" --allow-root --path=/var/www/html; then
        echo "Error: Failed to create WordPress user."
        exit 1
    fi
    echo "WordPress installed successfully."
else
    echo "WordPress already installed."
fi

