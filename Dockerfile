FROM alpine:latest

MAINTAINER Franck Diomandé "fkdiomande@gmail.com"

ARG APPLICATION_NAME=skyflow
ARG SERVER_NAME=dev.skyflow.io
ARG SERVER_ADMIN=admin@skyflow.io
ARG DIRECTORY_INDEX=index.php
ARG DOCUMENT_ROOT=/var/www/${APPLICATION_NAME}/web
ARG SERVER_TYPE=apache2
ARG PHP_VERSION=7
ARG PHP_MODULES="apache2 json"

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}
ENV PHP_VERSION ${PHP_VERSION}
ENV PHP_MODULES ${PHP_MODULES}

RUN apk add --no-cache ${SERVER_TYPE} php$PHP_VERSION nodejs nodejs-npm && npm i -g gulp

RUN for module in $PHP_MODULES; do apk add --no-cache php$PHP_VERSION-"$module" ; done

RUN rm -rf /tmp/* && rm -rf /var/cache/apk/*

RUN mkdir -p /run/apache2

COPY ./conf/apache2 /etc/apache2
COPY ./conf/php$PHP_VERSION /etc/php$PHP_VERSION

EXPOSE 80

VOLUME /var/www/${APPLICATION_NAME}

ENTRYPOINT ["httpd"]

CMD ["-D", "FOREGROUND"]
