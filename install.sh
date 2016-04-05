#!/bin/bash -e

sudo apt-get clean
sudo mv /var/lib/apt/lists /tmp
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean

sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANG=C.UTF-8

# Install dependencies
echo "=========== Installing dependencies ============"
apt-get update
apt-get install -y git wget cmake libmcrypt-dev libreadline-dev libzmq-dev

# Install libmemcached
echo "========== Installing libmemcached =========="
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar xzf libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18
./configure --enable-sasl
make && make install
cd .. && rm -fr libmemcached-1.0.18*

# Install librabbitmq
echo "============ Installing librabbitmq ============"
cd /tmp && wget https://github.com/alanxz/rabbitmq-c/releases/download/v0.7.1/rabbitmq-c-0.7.1.tar.gz
tar xzf rabbitmq-c-0.7.1.tar.gz
mkdir build && cd build
cmake /tmp/rabbitmq-c-0.7.1
cmake -DCMAKE_INSTALL_PREFIX=/usr/local /tmp/rabbitmq-c-0.7.1
cmake --build . --target install
cd /tmp/rabbitmq-c-0.7.1
autoreconf -i
./configure
make
make install
cd /

echo "========== Add PPA and install php7 =========="
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install php7.0
sudo apt-get install -y php7.0-dev git pkg-config build-essential libmemcached-dev
sudo apt-get install -y tmux curl wget \
    php7.0-fpm \
    php7.0-cli php7.0-curl php7.0-gd \
    php7.0-intl php7.0-mysql

echo "============ Installing Composer ============"
curl -s http://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar usr/bin/composer

echo "============ Installing phpunit ============"
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit

echo "================= Install Extensions ==================="
sudo apt-get install php-memcache
sudo apt-get install php-memcached
sudo apt-get install php-mongodb
sudo apt-get install php-amqp
sudo apt-get install php-redis
sudo apt-get install php-zmq

# Cleaning package lists
echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
