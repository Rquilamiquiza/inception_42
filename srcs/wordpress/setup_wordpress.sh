#!/bin/bash
set -e

# 1. Esperar o banco ficar pronto
echo "[setup] Aguardando o BD em ${WORDPRESS_DB_HOST}"
while ! nc -z "$(echo $WORDPRESS_DB_HOST | cut -d: -f1)" "$(echo $WORDPRESS_DB_HOST | cut -d: -f2)"; do
  sleep 1
done
echo "[setup] Banco disponível!"

# 2. Copiar WordPress caso o volume esteja vazio
if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
  echo "[setup] Copiando WordPress para /var/www/html..."
  cp -a /usr/src/wordpress/* /var/www/html/
fi

# 3. Criar wp-config.php se não existir
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "[setup] Criando wp-config.php..."
  cat > /var/www/html/wp-config.php <<EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
    define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF
fi
echo "[setup] Pronto"

