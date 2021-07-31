#!/bin/sh

while :; do
	echo "In cert-renew-daemon"
	sleep 86400		# 1 day
	certbot renew
done