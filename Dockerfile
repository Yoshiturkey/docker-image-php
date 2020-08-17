FROM php:7.4-fpm-alpine

WORKDIR /var/www

RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

RUN apk add -U --no-cache \
    bash \
    git \
    curl-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    unzip \
    gmp-dev \
    oniguruma-dev \
    freetype \
    freetype-dev \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    icu-dev autoconf make g++ gcc supervisor

RUN docker-php-source extract
RUN git clone -b 5.3.1 --depth 1 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis

RUN docker-php-ext-install iconv intl mbstring pdo_mysql zip redis gmp tokenizer exif

RUN docker-php-ext-configure gd \
    --with-jpeg=/usr/include \
    --with-freetype=/usr/include/ \
    && docker-php-ext-install gd

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
COPY ./conf/php/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY ./conf/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY ./conf/supervisord.conf /etc/supervisord.conf

RUN mkdir -p /etc/supervisor.d && touch /var/log/supervisord.log

EXPOSE 9000

ENTRYPOINT ["/usr/bin/supervisord", "-n","-c", "/etc/supervisord.conf"]

