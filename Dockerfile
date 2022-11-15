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

# Set working directory
WORKDIR /var/www/html/

# Create User from ENV file
RUN echo $user
RUN useradd -G www-data,root -u $uid -d /home/$user $user

# Create extra directories 
RUN mkdir -p -v .core/bootstrap/cache
RUN mkdir -p -v .core/storage/framework/sessions/
RUN mkdir -p -v .core/storage/logs
RUN touch .core/storage/logs/laravel.log

RUN chmod -R 777 .core/storage/
RUN chmod -R 777 .core/bootstrap/cache


USER $user
