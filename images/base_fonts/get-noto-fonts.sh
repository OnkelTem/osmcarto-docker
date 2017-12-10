#!/usr/bin/env bash

destination=${1:-.}

[[ -d ${destination} ]] || mkdir -p ${destination}

# Fetches additional fonts
if output=$(jq --stream 'select(length == 2) | [(.[0][] | select(strings)), .[1]] | join("/")' < /usr/local/etc/noto-fonts.json); then
  while read -r font; do
    font=${font:1:-1}
    curl -L https://github.com/${font}?raw=true -o ${destination}/$(basename ${font})
  done <<< "$output";
fi
