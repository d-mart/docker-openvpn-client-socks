# OpenVPN client + SOCKS proxy
# Usage:
# See `start` in same repo for how to run


FROM alpine:edge

ADD sockd.sh /usr/local/bin/

RUN true \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update-cache dante-server openvpn \
    && rm -rf /var/cache/apk/* \
    && chmod a+x /usr/local/bin/sockd.sh \
    && true

ADD sockd.conf /etc/

ENTRYPOINT [ \
    "openvpn", \
    "--up", "/usr/local/bin/sockd.sh", \
    "--script-security", "2", \
    "--config", "/ovpn.conf"]
