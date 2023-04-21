FROM alpine:3.17.2

ENV DOMAIN "example.com"
ENV ALIASES "root: /dev/null"

ENV VIRTUAL_DOMAINS = "otherdomain.com"
ENV VIRTUAL_ALIASES "root@otherdomain.com root"

ENV ALLOWED_NETWORKS "localhost"
ENV DOMAIN_TLS_PARENT "/etc/ssl"
ENV DOMAIN_TLS_CERT "cert.pem"
ENV DOMAIN_TLS_KEY "key.pem"

RUN apk add --no-cache bash postfix postfix-pcre \
    && adduser -S -u 1000 mailserver \
    && addgroup -S -g 1000 mailserver \
    && adduser mailserver mailserver \
    && chown mailserver:mailserver /home/mailserver \
    && mkdir -p /etc/ssl

WORKDIR /home/mailserver

COPY --chown=root:root master.cf /etc/postfix/master.cf
COPY --chown=mailserver:mailserver entrypoint.sh entrypoint.sh
COPY --chown=mailserver:mailserver test.sh test.sh

ENTRYPOINT ["bash", "entrypoint.sh"]
