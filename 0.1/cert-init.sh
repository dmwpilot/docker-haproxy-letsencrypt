#!/bin/sh
# initialize this container with a brand new certificate

set -ex

if [ -f /var/run/haproxy.pid ]; then
	HAPID=
else
	haproxy -W -db -f /docker-entrypoint.d/haproxy-init.cfg &
	HAPID=$!
	sleep 5
fi

certbot \
	certonly \
	--domain ${CERTFQDN?'Must provide the FQDN of the certificate'} \
	--email ${CERTEMAIL?'Must provide the email address of the certificate owner'} \
	--standalone \
	--http-01-port=54321 \
	--agree-tos

if [ -n "$HAPID" ]; then
	kill -TERM $HAPID
	wait $HAPID
fi

cp /usr/local/bin/cert-install.sh /etc/letsencrypt/renewal-hooks/deploy/cert-install.sh

CERTBOT_DOMAIN=$CERTFQDN cert-install.sh
