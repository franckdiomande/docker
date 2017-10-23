#!/bin/sh

cp -R /etc/php${PHP_VERSION} /var/www/${APPLICATION_NAME}/docker/conf

chmod 777 -R /var/www/${APPLICATION_NAME}/docker/conf

httpd -D FOREGROUND