FROM base:osmcarto

# Install main services, tools and utilities
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    curl -sL https://deb.nodesource.com/setup_8.x -o /tmp/nodejs-8-setup && \
    bash /tmp/nodejs-8-setup && \
    rm /tmp/nodejs-8-setup && \
    apt-get install -y nodejs && \
    npm install npm@latest -g

ENV MILLSTONE_DEPS="build-essential"
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends ${MILLSTONE_DEPS} && \
    npm install carto -g && \
    npm install --unsafe-perm millstone -g

# Cleanup
RUN set -x && \
    apt-get autoremove --purge -y ${MILLSTONE_DEPS} && \
    rm -rf /var/lib/apt/lists/*

# Create auxiliary user for running commands
ARG APP_UID=1000
ARG APP_USER=user
RUN set -x && \
    useradd -u ${APP_UID} -m -s /bin/bash ${APP_USER}

COPY compile.sh /

USER ${APP_USER}

CMD ["/compile.sh"]
