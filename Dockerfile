FROM php:5.6-fpm

MAINTAINER Andreas Åkre Solberg <andreas@solweb.no>

# install the PHP extensions we need
RUN export PKGPHPMEM="libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev"
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev pwgen python-setuptools curl git unzip wget git subversion nginx memcached $PKGPHPMEM nano && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini


# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout

ADD ./supervisord.conf /etc/supervisord.conf
ADD ./php-fpm.conf /usr/local/etc/php-fpm.conf



#RUN mkdir -p /wordpress
COPY app /app/

# VOLUME ["/app"]
WORKDIR "/app"

# RUN curl -sS https://getcomposer.org/installer | php
RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /usr/local/bin/composer"
RUN chmod a+x /usr/local/bin/composer
RUN cd /app && /usr/local/bin/composer install
RUN chmod -R a+rX /app/wordpress


RUN mkdir /app/wordpress/wp-content/uploads
RUN chmod 777 /app/wordpress/wp-content/uploads

RUN mkdir /app/wordpress/wp-content/cache
RUN chmod 777 /app/wordpress/wp-content/cache

RUN mkdir /app/wordpress/wp-content/w3tc-config
RUN chmod 777 /app/wordpress/wp-content/w3tc-config

ADD ./w3tc-config /app/wordpress/wp-content/w3tc-config
ADD ./nginx-site.conf /etc/nginx/sites-available/default


# Wordpress Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh


EXPOSE 80

CMD ["/bin/bash", "/start.sh"]