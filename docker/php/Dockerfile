FROM php:7.4.12-fpm-buster

LABEL maintainer="Rohit Jagtiani <dev.rjagtiani@gmail.com>"

RUN apt-get update && apt-get install -y git wget zlib1g-dev libzip-dev libonig-dev zip unzip libpng-dev libicu-dev \
    libfreetype6-dev libjpeg62-turbo-dev libmemcached-dev exiftool && \
    pecl install xdebug-2.9.7 memcached apcu onigurama && \
    docker-php-ext-install -j$(nproc) mbstring pdo pdo_mysql intl sockets bcmath mysqli zip opcache exif && \
    docker-php-ext-enable xdebug memcached exif bcmath apcu && \
    docker-php-ext-configure zip && \
    pecl clear-cache

ADD docker/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

CMD ["php-fpm"]
