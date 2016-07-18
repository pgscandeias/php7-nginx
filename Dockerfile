FROM phusion/baseimage:0.9.18

# UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Install essentials
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    vim \
    curl \
    wget \
    htop \
    build-essential \
    python-software-properties

# Install nginx
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install php7 + extensions
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --fix-missing \
        php7.0-fpm \
        php7.0-cli \
        php7.0-xml \
        php7.0-gd \
        php7.0-mcrypt \
        php7.0-intl \
        php7.0-mysql \
        php7.0-pgsql \
        php7.0-curl \
        php7.0-dev \
        php7.0-mbstring \
        php7.0-zip \
        php-pear \
        pkg-config \
        libssl-dev

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

# Install mongo support
RUN pecl install mongodb
RUN echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini && \
    ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/fpm/conf.d/20-mongodb.ini && \
    ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/cli/conf.d/20-mongodb.ini

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php
RUN mv composer.phar /usr/local/bin/composer

# Setup runit
RUN mkdir -p        /server/http
ADD files/default   /etc/nginx/sites-available/default
RUN mkdir           /etc/service/nginx
ADD files/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD files/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

# Volume declaration
ADD ./src /server/http
WORKDIR /server/http
VOLUME /server/http

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
