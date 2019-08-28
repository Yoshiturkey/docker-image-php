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
    libpng-dev \
    libjpeg-turbo-dev \
    zip \
    libzip-dev \
    unzip \
    gmp-dev \
    libmemcached \
    libmemcached-libs \
    libmemcached-dev \
    icu-dev autoconf make g++ gcc supervisor
RUN pecl install memcached
RUN docker-php-source extract
RUN git clone -b 4.1.1 --depth 1 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis
RUN docker-php-ext-install gd iconv intl mbstring pdo_mysql zip redis
RUN docker-php-ext-enable memcached

COPY supervisord.conf /etc/supervisord.conf
RUN mkdir -p /etc/supervisor.d

RUN touch /var/log/supervisord.log

ENTRYPOINT ["/usr/bin/supervisord", "-n","-c", "/etc/supervisord.conf"]

