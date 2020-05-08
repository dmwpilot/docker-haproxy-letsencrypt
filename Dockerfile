FROM haproxy:2.1
MAINTAINER Dave Williamson <dmwpilot@yahoo.com>

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install -y certbot \
    && apt-get clean
