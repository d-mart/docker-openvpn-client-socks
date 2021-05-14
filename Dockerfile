# OpenVPN client + SOCKS proxy
# Usage:
# See `start` in same repo for how to run

FROM ubuntu:latest

ADD sockd.sh /usr/local/bin/

RUN apt update \
    && apt install -y \
       dante-server openvpn openssh-server \
       pgcli tmux \
    && rm -rf /var/lib/apt/lists/* \
    && chmod a+x /usr/local/bin/sockd.sh

RUN mkdir -p /root/.ssh
COPY pubkeys/* /root/.ssh
RUN cd /root/.ssh && \
    cat *.pub > authorized_keys && \
    chmod 600 authorized_keys && \
    mkdir -p /run/sshd

ADD sockd.conf /etc/

COPY ubuntu-startup.sh /ubuntu-startup.sh
RUN chmod +x /ubuntu-startup.sh
ENTRYPOINT ["/ubuntu-startup.sh"]

####### To run / test manually
# /usr/sbin/sshd
# openvpn --script-security 2 --config /ovpn.conf
#     "--up", "/usr/local/bin/sockd.sh", \

### This version relies on sockd script calling an openvpn up script which ubuntu doesn't have
# ENTRYPOINT [ \
#     "openvpn", \
#     "--up", "/usr/local/bin/sockd.sh", \
#     "--script-security", "2", \
#     "--config", "/ovpn.conf"]
