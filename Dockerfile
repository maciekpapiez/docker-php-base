FROM ubuntu:14.04

MAINTAINER Maciej Papież

RUN apt-get update --fix-missing && \
    apt-get -yq install \
        curl \
        git \
        vim \
        apache2 \
        php-pear \
        php-apc \
        php5-mysql \
        php5-gd \
        php5-curl \
        php5-xdebug \
        php5-intl \
        libapache2-mod-php5 \
        libxml2-utils \ 
        acl && \
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD virtual-host.conf /etc/apache2/sites-enabled/000-default.conf

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && a2enmod rewrite

# Configure /app folder with sample app
RUN mkdir -p /app && touch /app/index.html && rm -fr /var/www/html && \
    echo 'xdebug.remote_enable = 1' >> /etc/php5/apache2/conf.d/20-xdebug.ini && \
    echo 'xdebug.remote_connect_back = 1' >> /etc/php5/apache2/conf.d/20-xdebug.ini && \
    sed -i 's/memory_limit =.*/memory_limit = 512M/' /etc/php5/apache2/php.ini

EXPOSE 80

WORKDIR /app

