#!/bin/bash

/setup_wordpress.sh

exec php-fpm7.4 --nodaemonize
