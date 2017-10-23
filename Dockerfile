FROM alpine:latest

MAINTAINER Franck Diomandé "fkdiomande@gmail.com"

ARG APPLICATION_NAME=skyflow
ARG SERVER_NAME=dev.skyflow.io
ARG SERVER_ADMIN=admin@skyflow.io
ARG DIRECTORY_INDEX=index.php
ARG DOCUMENT_ROOT=/var/www/${APPLICATION_NAME}/web
ARG SERVER_TYPE=apache2
ARG PHP_VERSION=7
ARG PHP_MODULES="apache2 json phar tokenizer simplexml xml curl zip openssl mbstring dom xmlwriter"

ENV APPLICATION_NAME ${APPLICATION_NAME}
ENV SERVER_NAME ${SERVER_NAME}
ENV SERVER_ADMIN ${SERVER_ADMIN}
ENV DIRECTORY_INDEX ${DIRECTORY_INDEX}
ENV DOCUMENT_ROOT ${DOCUMENT_ROOT}
ENV SERVER_TYPE ${SERVER_TYPE}
ENV PHP_VERSION ${PHP_VERSION}
ENV PHP_MODULES ${PHP_MODULES}

RUN apk update && apk upgrade

RUN apk add git curl wget ${SERVER_TYPE} php$PHP_VERSION
RUN for module in $PHP_MODULES; do apk add php$PHP_VERSION-"$module" ; done

# Node npm and modules
RUN apk add nodejs nodejs-npm && npm i -g gulp

# Ruby compass
RUN apk add ruby-dev build-base libffi-dev ruby && \
echo "gem: --no-rdoc --no-ri" > /etc/gemrc && \
gem install compass

# Php code sniffer
RUN curl https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -o /usr/local/bin/phpcs && \
chmod +x /usr/local/bin/phpcs && \
curl https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar -o /usr/local/bin/phpcbf && \
chmod +x /usr/local/bin/phpcbf

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
php -r "unlink('composer-setup.php');" && \
echo "memory_limit=-1" > "/etc/php$PHP_VERSION/php.ini"

# Phpunit
RUN wget https://phar.phpunit.de/phpunit.phar && \
chmod +x phpunit.phar && \
mv phpunit.phar /usr/local/bin/phpunit


RUN rm -rf /tmp/* && rm -rf /var/cache/apk/*

RUN mkdir -p /run/$SERVER_TYPE

COPY ./conf/$SERVER_TYPE /etc/$SERVER_TYPE
COPY ./conf/php$PHP_VERSION /etc/php$PHP_VERSION

EXPOSE 80

VOLUME /var/www/${APPLICATION_NAME}

ENTRYPOINT ["httpd"]

CMD ["-D", "FOREGROUND"]
