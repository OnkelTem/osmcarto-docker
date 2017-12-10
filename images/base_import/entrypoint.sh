#!/usr/bin/env bash

abort () {
  printf "$(tput setaf 1)$(tput bold)$1$(tput sgr0)\n"
  exit 1
}

getent hosts "${PGHOST}" > /dev/null || abort "Host ${PGHOST} cannot be resolved"
[[ -n ${OSM2PGSQL_DATAFILE} ]] || abort "Data file name is empty, set OSM2PGSQL_DATAFILE variable"
[[ -f ${OSM2PGSQL_DATAFILE} ]] || abort "Data file is not found: ${OSM2PGSQL_DATAFILE}"

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

dbname="gis"

# Creating default database
psql -c "SELECT 1 FROM pg_database WHERE datname = '${dbname}';" | grep -q 1 || createdb "${dbname}" && \
psql -d "${dbname}" -c 'CREATE EXTENSION IF NOT EXISTS postgis;' && \
psql -d "${dbname}" -c 'CREATE EXTENSION IF NOT EXISTS hstore;'

# Importing data to a database
osm2pgsql \
  --hstore \
  --multi-geometry \
  --database gis \
  --style openstreetmap-carto.style \
  --tag-transform-script openstreetmap-carto.lua \
  ${OSM2PGSQL_CACHE+--cache ${OSM2PGSQL_CACHE}} \
  ${OSM2PGSQL_NUMPROC+--number-processes ${OSM2PGSQL_NUMPROC}} \
  ${OSM2PGSQL_DATAFILE}
