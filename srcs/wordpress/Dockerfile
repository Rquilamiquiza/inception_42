FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-intl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://wordpess.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/wwwhtml/ && \
    rm - rf /tmp/wordpess /tmp/latest.tar.gz

RUN chown -R www-data:www-data /var/ww/html && \
    chmod -R 755 /var/www/html

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/ww.conf

RUN mkdir -p /run/php

COPY setup_worpress.sh /setup_wordpress.sh
RUN chmod +x /setup_wordpress.sh

EXPOSE 9000

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]