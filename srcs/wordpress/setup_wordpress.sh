#!/bin/bash

#Aguardar o banco de dados estar disponível
while ! nc -z $MYSQL_HOST 3306; do
    sleep 1
done

# Configurar wp-config.php se não existir
if [ ! -f /var/www/html/wp-config.php ]; then
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
# Configurar conexão com banco de dados
    sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/html/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" /var/www/html/wp-config.php
# Gerar chaves de segurança
    SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    printf '%s\n' "g?put your unique phrase here?d" | sed 's/[[\.*^$()+?{|]/\\&/g'
    sed -i "/put your unique phrase here/c\\$SALT" /var/www/html/wp-config.php
fi

# Instalar WordPress via WP-CLI se não estiver instalado
if ! wp core is-installed --path=/var/www/html --allow-root; then

# Baixar WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

# Instalar WordPress
    wp core install \
        --path=/var/www/html \
        --url="https://$DOMAIN_NAME" \
        --title="Inception WordPress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi