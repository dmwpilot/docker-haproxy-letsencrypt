#!/bin/sh
# docker entrypoint for haproxy-letsencrypt

set -ex

if [ "${1:-}" != "init" ]; then
	if [ ! -f /etc/letsencrypt/live/$CERTFQDN/cert.pem -a "${1:-}" != "skipinit" ]; then
		set -- init "$@"
	fi
fi

if [ "${1:-}" = "skipinit" ]; then
	shift	# "skipinit"
elif [ "${1:-}" = "init" ]; then
	shift	# "init"
	# need to initialize first
	mkdir -p /etc/letsencrypt
	mv /etc/letsencrypt-init/* /etc/letsencrypt
	cert-init.sh
fi
rm -rf /etc/letsencrypt-init

if [ "${1#-}" != "$1" ]; then
	# argument is an option, so treat it as an haproxy option
	set -- haproxy "$@"
fi

if [ "$#" -eq 0 ]; then
	# there are no arguments left, so assume haproxy
    set -- haproxy
fi

if [ "$1" = 'haproxy' ]; then
	shift	# "haproxy"
	cp /docker-entrypoint.d/haproxy.cfg /usr/local/etc/haproxy
	CERTBOT_DOMAIN=$CERTFQDN cert-install.sh
	set -- haproxy-monitor.sh -f /usr/local/etc/haproxy/haproxy.cfg "$@"
	cert-renew-daemon.sh &
fi

exec "$@"
