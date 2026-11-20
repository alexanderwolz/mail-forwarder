# Base image is pinned to an exact version for reproducible builds.
FROM alpine:3.24.4
LABEL maintainer="mail@alexanderwolz.de"

# Required - no defaults (container will fail fast if missing)
# DOMAIN                    -> e.g. "mail.example.com"
# ALLOWED_NETWORKS          -> e.g. "localhost"
# ALIASES                   -> e.g. "postmaster: john@doe.com"

# Optional - with defaults
# SMTP_HOSTNAME             -> e.g. "host.example.com", defaults to DOMAIN
# SMTP_TLS_SECURITY_LEVEL   -> e.g "may" or "encrypt", defaults to "encrypt"
# VIRTUAL_DOMAINS           -> e.g. "otherdomain.com", defaults to ""
# VIRTUAL_ALIASES           -> e.g. "root@otherdomain.com root", defaults to ""

ENV DOMAIN_TLS_PARENT="/etc/ssl"
ENV DOMAIN_TLS_CERT="cert.pem"
ENV DOMAIN_TLS_KEY="key.pem"

RUN apk upgrade --no-cache \
    && apk add --no-cache bash postfix postfix-pcre \
    && addgroup -S -g 1000 mailserver \
    && adduser -S -u 1000 mailserver -G mailserver \
    && chown mailserver:mailserver /home/mailserver \
    && mkdir -p /etc/ssl

WORKDIR /home/mailserver

COPY --chown=root:root master.cf /etc/postfix/master.cf
COPY --chown=mailserver:mailserver entrypoint.sh entrypoint.sh
COPY --chown=mailserver:mailserver test.sh test.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD postfix status || exit 1

ENTRYPOINT ["bash", "entrypoint.sh"]
