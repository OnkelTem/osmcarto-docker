FROM base:osmcarto

# Copy fonts installation scripts
COPY noto-fonts.json /usr/local/etc/
COPY get-noto-fonts.sh /usr/local/bin/
ARG FONT_PACKAGES="fonts-dejavu-core fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont fonts-hanazono"
ENV FONT_PACKAGES=${FONT_PACKAGES}

COPY install-fonts.sh /usr/local/bin

CMD ["install-fonts.sh"]
