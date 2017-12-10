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

exec ${@}
