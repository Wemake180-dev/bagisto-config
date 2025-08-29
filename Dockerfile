FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar todo lo necesario
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update && apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-xml \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-zip \
    php8.2-gd \
    php8.2-bcmath \
    php8.2-intl \
    php8.2-soap \
    php8.2-redis \
    php8.2-opcache \
    apache2 \
    libapache2-mod-php8.2 \
    git \
    curl \
    unzip \
    nano \
    vim \
    openssh-server \
    supervisor \
    nodejs \
    npm \
    mysql-client

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar PHP
RUN echo "memory_limit = 512M" >> /etc/php/8.2/apache2/php.ini && \
    echo "max_execution_time = 360" >> /etc/php/8.2/apache2/php.ini

# Configurar Apache
RUN a2enmod rewrite
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo 'root:bagisto' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Script simple de inicio
RUN echo '#!/bin/bash\n\
service ssh start\n\
service apache2 start\n\
tail -f /var/log/apache2/error.log' > /start.sh && \
    chmod +x /start.sh

WORKDIR /var/www/html

EXPOSE 80 22

CMD ["/start.sh"]