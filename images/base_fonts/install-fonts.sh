#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends ${FONT_PACKAGES} && \
  get-noto-fonts.sh /usr/share/fonts/truetype/noto
