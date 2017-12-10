FROM base:osmcarto

# Install main services, tools and utilities
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends git supervisor apache2 python-mapnik && \
    curl -sL https://deb.nodesource.com/setup_8.x -o /tmp/nodejs-8-setup && \
    bash /tmp/nodejs-8-setup && \
    rm /tmp/nodejs-8-setup && \
    apt-get install -y nodejs && \
    npm install npm@latest -g

# Instal mod_tile
RUN set -x && \
    MOD_TILE_DEPS_BUILD="autoconf build-essential libtool apache2-dev libpq-dev libmapnik-dev" && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends ${MOD_TILE_DEPS_BUILD} && \
    cd /tmp && \
    git clone --depth 1 https://github.com/openstreetmap/mod_tile.git && \
    cd mod_tile && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    make install-mod_tile && \
    ldconfig && \
    cd - && \
    rm -rf mod_tile && \
    apt-get autoremove -y --purge ${MOD_TILE_DEPS_BUILD}

# Cleanup
RUN set -x && \
    rm -rf /var/lib/apt/lists/*

# Configure and enable mod_tile
COPY mod_tile.load /etc/apache2/mods-available/
COPY mod_tile.conf /etc/apache2/mods-available/
RUN set -x && \
    a2enmod mod_tile && \
    install --owner=www-data --group=www-data -d /var/lib/mod_tile

#RUN chown -R www-data:www-data /usr/local/src/

# Configure renderd
COPY renderd.conf /usr/local/etc/renderd.conf
RUN set -x && \
    install --owner=www-data --group=www-data -d /var/run/renderd

# Copy webclient
COPY webclient /var/www/html

# Configure supervisord
COPY supervisor /etc/supervisor/conf.d

# Create auxiliary user for running commands
ARG APP_UID=1000
ARG APP_USER=user
RUN set -x && \
    useradd -u ${APP_UID} -m -s /bin/bash ${APP_USER}
ENV APP_USER=${APP_USER}

ENV TERM=xterm-color

RUN mkdir -p /openstreetmap-carto
WORKDIR /openstreetmap-carto

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh", "/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
#ENTRYPOINT ["/entrypoint.sh"]
#CMD ["bash"]
