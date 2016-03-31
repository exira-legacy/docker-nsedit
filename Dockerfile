FROM exira/base:latest

MAINTAINER exira.com <info@exira.com>

ENV NSEDIT_VERSION=794fcb680c35546b24d12511997da5db79688784

RUN \
    # Install build and runtime packages
    build_pkgs="git perl" && \
    apk update && \
    apk upgrade && \
    apk --update --no-cache add ${build_pkgs} && \

    # get nsedit
    mkdir -p /var/www/public_html/ && \
    cd /var/www/public_html/ && \
    git clone --recursive https://github.com/tuxis-ie/nsedit.git . -v && \
    git reset ${NSEDIT_VERSION} --hard && \
    git submodule update --init && \

    # add www-data user
    mkdir -p /home/www-data && \
    addgroup -g 433 -S www-data && \
    adduser -u 431 -S -D -G www-data -h /home/www-data -s /sbin/nologin www-data && \
    chown -R www-data:www-data /home/www-data && \

    # remove dev dependencies
    apk del ${build_pkgs} && \

    # other clean up
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

ADD config.inc.php /var/www/public_html/includes/config.inc.php

RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/

VOLUME /var/www/
