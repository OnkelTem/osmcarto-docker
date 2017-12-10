FROM base:osmcarto

# Install tools, utilities and osm2pgsql

RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends osm2pgsql && \
    rm -rf /var/lib/apt/lists/*

# Create auxiliary user for running commands

ARG APP_UID=1000
ARG APP_USER="user"
RUN set -x && \
    useradd -u ${APP_UID} -m -s /bin/bash ${APP_USER}

COPY entrypoint.sh /

RUN mkdir -p /openstreetmap-carto
WORKDIR /openstreetmap-carto

USER ${APP_USER}

ENTRYPOINT ["/entrypoint.sh"]
