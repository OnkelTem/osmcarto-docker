FROM base:osmcarto

# Create auxiliary user for running commands
ARG APP_UID=1000
ARG APP_USER=user
RUN set -x && \
    useradd -u ${APP_UID} -m -s /bin/bash ${APP_USER}

COPY get-shapefiles.sh /

USER user

WORKDIR /openstreetmap-carto

CMD ["/get-shapefiles.sh"]
