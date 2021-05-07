FROM devilbox/php-fpm-5.3:latest

MAINTAINER João Leno <joaoleno@gmail.com>

ENV LD_LIBRARY_PATH /usr/local/instantclient_11_2

RUN apt-get update && apt-get install -y unzip libaio1

# RUN mkdir /usr/local
COPY oracle/instantclient-basic-linux.x64-11.2.0.4.0.zip /usr/local
COPY oracle/instantclient-sdk-linux.x64-11.2.0.4.0.zip /usr/local
COPY oracle/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip /usr/local

# Install Oracle Instantclient
RUN unzip /usr/local/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /usr/local \
    && unzip /usr/local/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /usr/local \
    && unzip /usr/local/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip -d /usr/local \
    && ln -s /usr/local/instantclient_11_2/libclntsh.so.11.2 /usr/local/instantclient_11_2/libclntsh.so \
    && ln -s /usr/local/instantclient_11_2/libclntshcore.so.11.2 /usr/local/instantclient_11_2/libclntshcore.so \
    && ln -s /usr/local/instantclient_11_2/libocci.so.11.2 /usr/local/instantclient_11_2/libocci.so \
    && ln -s /usr/local/instantclient_11_2/sqlplus /usr/bin/sqlplus \
    && rm -rf /usr/local/*.zip

# Install Oracle extensions
#RUN echo 'instantclient,/usr/local/instantclient_11_2' | pecl install oci8-1.4.3 \
#    && docker-php-ext-enable oci8 \
#    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient_11_2,11.2 \
#    && docker-php-ext-install pdo_oci

# alt
RUN echo 'instantclient,/usr/local/instantclient_11_2' | pecl install oci8-1.4.3
RUN echo "extension=oci8.so" > /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini
#RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient_11_2,11.2
#RUN docker-php-ext-install pdo_oci
#RUN docker-php-ext-enable oci8