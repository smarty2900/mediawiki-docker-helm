# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04
ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive
# Set environment variables for database connection
ENV MEDIAWIKI_DB_TYPE=mysql
ENV MEDIAWIKI_DB_HOST=db
ENV MEDIAWIKI_DB_NAME=mediawiki
ENV MEDIAWIKI_DB_USER=wikiuser
ENV MEDIAWIKI_DB_PASSWORD=secret

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    mariadb-client \
    php \
    php-mysql \
    libapache2-mod-php \
    php-xml \
    php-mbstring \
    php-apcu \
    php-intl \
    imagemagick \
    inkscape \
    php-gd \
    php-cli \
    php-curl \
    php-bcmath \
    git \
    wget \
    && apt-get clean

# Enable Apache mods
RUN a2enmod rewrite

# Download and extract MediaWiki
RUN cd /tmp && \
    wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz && \
    tar -xvzf mediawiki-1.41.1.tar.gz && \
    mv mediawiki-1.41.1 /var/www/html/mediawiki && \
    rm mediawiki-1.41.1.tar.gz

# Set up MediaWiki directory permissions
RUN chown -R www-data:www-data /var/www/html/mediawiki


# Copy php.ini file to the container
COPY php.ini /etc/php/7.4/apache2/php.ini

# Copy any custom LocalSettings.php if needed
# COPY LocalSettings.php /var/www/html/mediawiki/LocalSettings.php

# Expose port 80
EXPOSE 80

# Start Apache server in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
