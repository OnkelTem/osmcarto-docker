#!/usr/bin/env bash

remove () {
  printf "$(tput setaf 3)$(tput bold)Removing broken (partially downloaded) file: $(tput sgr0)${1}\n"
  rm "${1}"
}

# Remove any previously downloaded files as partially downloaded files break the python script
echo "Checking integrity of any previously downloaded files..."
shopt -s nullglob
for f in data/*.tgz data/*.zip; do
  if [[ -f "${f}" ]]; then
    case "${f}" in
      *.tgz)
        tar -tzf "${f}" >/dev/null 2>&1 || remove "${f}"
        ;;
      *.zip)
        unzip -t "${f}" >/dev/null 2>&1 || remove "${f}"
        ;;
    esac
  fi
done

# Get shapefiles
python scripts/get-shapefiles.py -n
