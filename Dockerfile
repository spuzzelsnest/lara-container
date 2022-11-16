FROM php:8.1-fpm
 
# Arguments from docker-compse.yml
ARG user
ARG uid

# Set working directory
WORKDIR /var/www

# Install dependencies for the operating system software
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    nano \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions for php
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Create User from ENV file
RUN chown -R $user:$user /var/www/

#RUN useradd -G www-data,root -u $uid -d /home/$user $user

# Git clone
RUN git clone https://github.com/spuzzelsnest/ww2web.git /var/www/html

# Create extra directories
RUN mkdir -p /var/www/.core/bootstrap/cache
RUN mkdir -p /var/www/.core/storage/framework/sessions
RUN mkdir -p /var/www/.core/storage/framework/views
RUN mkdir -p /var/www/.core/storage/framework/cache/data
RUN mkdir -p /var/www/.core/storage/logs
RUN touch /var/www/.core/storage/logs/laravel.log

RUN chmod 777 /var/www/.core/storage/logs
RUN chmod 777 /var/www/.core/storage/framework/sessions
RUN chmod 777 /var/www/.core/storage/framework/views
RUN chmod 777 /var/www/.core/bootstrap/cache

RUN usermod -u $uid $user

# copy to source folder
COPY .  /var/www/
COPY --chown=www-data:www-data . /var/www

# Load User
USER $user

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
