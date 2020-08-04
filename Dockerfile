FROM alpine:3.12

# A better place to retrieve the PHP extensions from
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN apk --update add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.3" >> /etc/apk/repositories

# Environment variables for the PHP-FPM Pool config (WWW)
ENV EMERGENCY_RESTART_INTERVAL=1m \
    EMERGENCY_RESTART_THRESHOLD="10" \
    ERROR_LOG=/dev/stderr \
    LISTEN=127.0.0.1:9000 \
    PM_MAX_CHILDREN="100" \
    PM_MAX_REQUESTS="1000" \
    PM_MAX_SPARE_SERVERS="15" \
    PM_MIN_SPARE_SERVERS="5" \
    PM_START_SERVERS="10" \
    PROCESS_CONTROL_TIMEOUT=5m \
    USER=nobody

# Environment variables for the PHP.ini config
ENV DISPLAY_ERRORS="On" \
    ERROR_REPORTING="E_ALL & ~E_DEPRECATED" \
    MAX_EXECUTION_TIME="5" \
    MAX_FILE_UPLOADS="20" \
    MEMORY_LIMIT="-1" \
    POST_MAX_SIZE=50M \
    SHORT_OPEN_TAG="Off" \
    UPLOAD_MAX_FILESIZE=50M

# Update the APK packages and install some basic essentials and NGINX and PHP-FPM and all it's extensions
RUN apk update && \
    apk upgrade && \
    apk --no-cache add \
        curl \
        git \
        mysql-client \
        nginx \
        openrc \
        openssh \
        php-bcmath \
        php-bz2 \
        php-calendar \
        php-ctype \
        php-curl \
        php-dom \
        php-exif \
        php-fpm \
        php-ftp \
        php-gd \
        php-iconv \
        php-intl \
        php-json \
        php-ldap \
        php-mbstring \
        php-memcached \
        php-mysqli \
        php-mysqlnd \
        php-opcache \
        php-openssl \
        php-pcntl \
        php-pdo \
        php-pdo_mysql \
        php-pdo_pgsql \
        php-pdo_sqlite \
        php7-pecl-ssh2 \
        php-phar \
        php-pgsql \
        php-posix \
        php-redis \
        php-session \
        php-soap \
        php-sockets \
        php-sodium \
        php-sqlite3 \
        php-xml \
        php-xmlreader \
        php-xmlrpc \
        php-xsl \
        php-zip \
        supervisor \
        vim \
        zip && \
    rm -rf /etc/nginx/conf.d/default.conf

# Copy all required config files across
COPY build/config/extra /etc/nginx/extra
COPY build/config/nginx.conf /etc/nginx/nginx.conf
COPY build/config/mime.types /etc/nginx/mime.types
COPY build/config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY build/config/php.ini /etc/php7/php.ini
COPY build/config/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# Create the document root and a place for PHP logs
RUN mkdir -p /var/www/code && \
    mkdir -p /etc/php7/log

# Make sure files/folders needed by the processes are accessable when they run under the 'nobody' user
RUN chown -R nobody: /var/www/code && \
    chown -R nobody: /run && \
    chown -R nobody: /var/lib/nginx && \
    chown -R nobody: /var/log/nginx

# Switch to use a non-root user from here on - only use if you don't want to use 'root'
# USER nobody

# Set the working directory
#WORKDIR /var/www/code

# Export the open port - change to ':80' if needed
EXPOSE 80

# Start NGINX and PHP-FPM via Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]