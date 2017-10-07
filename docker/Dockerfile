FROM alpine:3.6

MAINTAINER Franck Diomandé "fkdiomande@gmail.com"

ARG APPLICATION_NAME=equimetre
ARG SERVER_NAME=dev.equimetre.fr
ARG SERVER_ADMIN=admin@equimetre.fr
ARG DIRECTORY_INDEX=app_dev.php
ARG DOCUMENT_ROOT=/var/www/${APPLICATION_NAME}/web
ARG SERVER_TYPE=apache2
ARG PHP_VERSION=7
ARG PHP_MODULES="apache2 curl json gd mcrypt memcached \
intl sqlite3 gmp mbstring redis xml zip \
cli imagick xsl imap pdo pdo_mysql fpm fileinfo \
opcache ctype xdebug soap apcu mysqli phar"

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}
ENV PHP_VERSION ${PHP_VERSION}
ENV PHP_MODULES ${PHP_MODULES}

RUN apk update

RUN apk add curl git nodejs nodejs-npm ${SERVER_TYPE} php$PHP_VERSION

RUN for module in $PHP_MODULES; do apk add php$PHP_VERSION-"$module" ; done

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN npm i -g gulp && rm -rf /tmp/* && rm -rf /var/cache/apk/*

RUN mkdir -p /run/apache2

COPY ./conf/apache2 /etc/apache2
COPY ./conf/php$PHP_VERSION /etc/php$PHP_VERSION

EXPOSE 80

VOLUME /var/www/${APPLICATION_NAME}

ENTRYPOINT ["httpd"]

CMD ["-D", "FOREGROUND"]
