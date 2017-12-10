FROM base:osmcarto

# Install main services, tools and utilities
ARG BUILD_DEPS="build-essential libmapnik-dev"
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y ${BUILD_DEPS} && \
    curl -sL https://deb.nodesource.com/setup_8.x -o /tmp/nodejs-8-setup && \
    bash /tmp/nodejs-8-setup && \
    rm /tmp/nodejs-8-setup && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g npm@latest

# Install Kosmtik and plugins
RUN set -x && \
    npm install --unsafe-perm -g kosmtik && \
    cd /usr/lib/node_modules/kosmtik/ && \
    kosmtik plugins --install kosmtik-overpass-layer \
                    --install kosmtik-fetch-remote \
                    --install kosmtik-overlay \
                    --install kosmtik-open-in-josm \
                    --install kosmtik-map-compare \
                    --install kosmtik-osm-data-overlay \
                    --install kosmtik-mapnik-reference \
                    --install kosmtik-geojson-overlay \
                    && \
    cp /root/.config/kosmtik.yml /tmp/.kosmtik-config.yml

# Clean up the system
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get autoremove --purge -y ${BUILD_DEPS} && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

RUN mkdir -p /openstreetmap-carto
WORKDIR /openstreetmap-carto

# Create auxiliary user for running commands

ARG APP_UID=1000
ARG APP_USER=user
RUN set -x && \
    useradd -u ${APP_UID} -m -s /bin/bash ${APP_USER}
ENV APP_USER=${APP_USER}

USER ${APP_USER}

ENTRYPOINT ["/entrypoint.sh"]
