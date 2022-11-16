FROM php:8.1-fpm
 
# Arguments from docker-compse.yml
ARG user
ARG uid

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
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN chown -R $user:$user /var/www/
RUN mkdir /home/$user
RUN chown -R $user:$user /home/$user
#RUN usermod -u $uid $user

# Set working directory
RUN rm -rf /var/www/*
#RUN rm -rf /var/www/{*,.*}
WORKDIR /var/www

# Load User
USER $user

# Git clone
RUN git clone https://github.com/spuzzelsnest/ww2web.git /var/www

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

# copy to source folder
COPY . src/  
COPY --chown=$user:www-data . /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
