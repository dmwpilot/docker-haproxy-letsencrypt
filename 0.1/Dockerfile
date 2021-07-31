FROM haproxy:2.1
LABEL AUTHOR="<dmwpilot@yahoo.com>"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y certbot procps \
    && apt-get clean \
	&& mkdir -p /docker-entrypoint.d \
	&& mv /etc/letsencrypt /etc/letsencrypt-init
	
#TODO get rid of procps later

COPY haproxy-init.cfg /docker-entrypoint.d/
COPY cert-install.sh /usr/local/bin
COPY cert-renew-daemon.sh /usr/local/bin
COPY cert-init.sh /usr/local/bin
COPY haproxy-monitor.sh /usr/local/bin

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
