#!/usr/bin/env bash

abort () {
  printf "$(tput setaf 1)$(tput bold)$1$(tput sgr0)\n"
  exit 1
}

getent hosts "${PGHOST}" > /dev/null || abort "Host ${PGHOST} cannot be resolved"

# Testing if database is ready
i=1
MAXCOUNT=60
echo "Waiting for PostgreSQL to be running"
while (( i <= MAXCOUNT )); do
  pg_isready -q && break
  sleep 2
  ((i++))
done
(( i <= MAXCOUNT)) || abort "Timeout while waiting for PostgreSQL to be running."

# Creating default Kosmtik settings file
if [ ! -e ".kosmtik-config.yml" ]; then
  cp /tmp/.kosmtik-config.yml .kosmtik-config.yml
fi
export KOSMTIK_CONFIGPATH=".kosmtik-config.yml"

# Starting Kosmtik
kosmtik serve project.mml --host 0.0.0.0
# It needs Ctrl+C to be interrupted
