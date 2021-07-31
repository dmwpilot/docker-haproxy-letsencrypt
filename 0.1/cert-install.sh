#!/bin/sh
# RENEWED_LINEAGE should point to the config live subdirectory
# e.g. /etc/letsencrypt/live/example.com
# See https://github.com/certbot/certbot/blob/01772280c07bbbf90c70298ce31d93f02b2ac577/certbot/docs/cli-help.txt

set -e

cd ${RENEWED_LINEAGE?}
mkdir -p /usr/local/etc/haproxy/certs
cat fullchain.pem privkey.pem >/usr/local/etc/haproxy/certs/$(basename $RENEWED_LINEAGE).pem
if [ -f /var/run/haproxy-monitor.pid ]; then
	kill -s USR1 $(cat /var/run/haproxy-monitor.pid)
fi
