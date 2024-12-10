FROM php:8.2-fpm
WORKDIR /var/www
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl gd xml zip

COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy Laravel project files (useful for existing projects)
COPY . .

# Ensure the storage and cache directories are writable
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache && \
    chown -R www-data:www-data /var/www

# Expose port 9000 for PHP-FPM
EXPOSE 8000

# Start PHP-FPM server
CMD ["php-fpm"]
