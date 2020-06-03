FROM alpine
ENV S6_OVERLAY_VERSION=v1.22.1.0
RUN apk add --no-cache curl && \
 curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
 | tar xfz - -C / 
RUN apk add --no-cache amavis clamav-daemon cabextract spamassassin
RUN apk del curl
RUN mkdir /config; mv /etc/amavisd.conf /config;mv /etc/clamav /config;mv /etc/mail /config;ln -s /config/amavisd.conf /etc;ln -s /config/clamav /etc;ln -s /config/mail /etc
VOLUME /config
VOLUME /mail
ADD rootfs /
ENTRYPOINT ["/init"]
CMD ["/usr/bin/amavisd-nanny"]
