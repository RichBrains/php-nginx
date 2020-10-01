FROM php:7.2-fpm-alpine

RUN apk add --no-cache --virtual .ext-deps \
        libjpeg-turbo-dev \
        libwebp-dev \
        libpng-dev \
        freetype-dev \
        libmcrypt-dev \
        nodejs-npm \
        nginx \
        git \
        inkscape

# imagick
RUN apk add --update --no-cache autoconf gcc g++ imagemagick-dev libtool nasm make automake pcre-dev libgit2-dev file util-linux \
    && pecl install imagick \
    && docker-php-ext-enable imagick


RUN docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure exif && \
    docker-php-ext-configure gd

RUN docker-php-ext-install pdo_mysql mysqli opcache exif gd zip && \
    docker-php-source delete



RUN ln -s /usr/bin/php7 /usr/bin/php && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    mkdir -p /run/nginx

COPY ./init.sh /
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /init.sh

EXPOSE 80

ENTRYPOINT [ "/init.sh" ]
