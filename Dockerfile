FROM alpine:3.6

MAINTAINER Franck Diomandé "fkdiomande@gmail.com"

ARG APPLICATION_NAME=myapp
ARG SERVER_NAME=localhost
ARG SERVER_ADMIN=admin@myapp.fr
ARG DIRECTORY_INDEX=index.php
ARG DOCUMENT_ROOT=/var/www/${APPLICATION_NAME}
ARG SERVER_TYPE=apache2
ARG PHP_VERSION=7
ARG PHP_MODULES="apache2"

# apache2 curl json gd mcrypt memcached
# intl sqlite3 gmp mbstring redis xml zip
# cli imagick xsl imap pdo pdo_mysql fpm fileinfo
# opcache ctype xdebug soap apcu mysqli

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}
ENV PHP_VERSION ${PHP_VERSION}
ENV PHP_MODULES ${PHP_MODULES}

RUN apk add --no-cache ${SERVER_TYPE} php$PHP_VERSION

RUN for module in $PHP_MODULES; do apk add --no-cache php$PHP_VERSION-"$module" ; done

RUN mkdir -p /run/apache2

RUN rm -rf /var/cache/apk/*

COPY ./conf/apache2 /etc/apache2
COPY ./conf/php$PHP_VERSION /etc/php$PHP_VERSION

EXPOSE 80

VOLUME /var/www/${APPLICATION_NAME}

ENTRYPOINT ["httpd"]

CMD ["-D", "FOREGROUND"]
