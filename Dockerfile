FROM php:7.3-fpm-alpine

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
    libpng-dev \
    libjpeg-turbo-dev \
    icu-dev autoconf make g++ gcc supervisor

RUN docker-php-source extract
RUN git clone -b 5.2.1 --depth 1 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis
RUN docker-php-ext-configure gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include
RUN docker-php-ext-install iconv intl mbstring pdo_mysql zip redis gd gmp tokenizer

COPY ./conf/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /etc/supervisor.d && touch /var/log/supervisord.log


EXPOSE 9000

ENTRYPOINT ["/usr/bin/supervisord", "-n","-c", "/etc/supervisord.conf"]

