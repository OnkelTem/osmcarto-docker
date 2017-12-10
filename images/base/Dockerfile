FROM debian:stretch

# Install base tools and run-time libraries
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates gnupg curl mapnik-utils python unzip jq postgresql-client && \
    rm -rf /var/lib/apt/lists/*
