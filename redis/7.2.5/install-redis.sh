#!/bin/bash
set -e

# version check: https://redis.io/
REDIS_VERSION=7.2.5
REDIS_HASH="5981179706f8391f03be91d951acafaeda91af7fac56beffb2701963103e423d"

cd /tmp
# Prepare Redis source.
wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
sha256sum redis-$REDIS_VERSION.tar.gz
echo "$REDIS_HASH redis-$REDIS_VERSION.tar.gz" | sha256sum -c

tar zxf redis-$REDIS_VERSION.tar.gz
cd redis-$REDIS_VERSION

# Building and installing binaries.
make && make install PREFIX=/usr

# Add `redis` user and group.
adduser --system --home /var/lib/redis --quiet --group redis || true

# Configure Redis.
mkdir -p /etc/redis
mkdir -p /var/lib/redis
mkdir -p /var/log/redis
cp /tmp/redis-$REDIS_VERSION/redis.conf /etc/redis

chown -R redis:redis /var/lib/redis
chmod 750 /var/lib/redis

chown -R redis:redis /var/log/redis
chmod 750 /var/log/redis

# Clean up.
cd / && rm -rf /tmp/redis*
