# docker-haproxy-letsencrypt

The haproxy-letsencrypt docker combines haproxy with the letsencrypt certbot
including automatic renewal of the certificate.  Note that only one certificate
is supported.  Port 80 must be open to the container.

Usage:

1.  Supply your haproxy.cfg as /docker-entrypoint.d/haproxy.cfg.
2.  Set the environment variable CERTFQDN to the FQDN for which you want a certificate (e.g. "example.com").
3.  Supply a volume mount for /etc/letsencrypt.  This is not required, but doing so will preserve your certificate and all of the other certbot goodies across container rebuilds.

Entrypoint parameters:
	haproxy		start haproxy as normal, doing certificate initialization if necessary (the default)
	init		do certificate initialization even if it appears to be done already
	skipinit	do not do certificate initialization even if it appears needed
	newconfig	apply the new configuration specified in /docker-entrypoint.d/haproxy.cfg
	sh			skip normal startup and start a shell
	-*			any options are passed to haproxy (or to sh if that was requested)