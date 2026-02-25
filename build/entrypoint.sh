#!/bin/bash

postconf -e "inet_protocols = ipv4"
postconf -e "maillog_file = /dev/stdout"
postconf -e "home_mailbox = maildir/"

#Local domain config
postconf -e "mydomain = $DOMAIN"
postconf -e "myorigin = \$mydomain"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, \$mydomain"
postconf -e "mynetworks = $ALLOWED_NETWORKS" #allow only these networks

#Security
postconf -e "mynetworks_style = host"
postconf -e "smtpd_sender_restrictions = reject_unknown_sender_domain" #only allow valid sender domains (MX records)
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination" #only allow my destinations
postconf -e "smtpd_helo_restrictions = permit_mynetworks, reject_unknown_helo_hostname"
postconf -e "smtpd_data_restrictions = reject_unauth_pipelining"

#SSL
postconf -e "smtpd_tls_security_level = may" #offers optional TLS
postconf -e "smtp_tls_note_starttls_offer = yes"
postconf -e "smtpd_tls_cert_file = $DOMAIN_TLS_PARENT/$DOMAIN_TLS_CERT"
postconf -e "smtpd_tls_key_file = $DOMAIN_TLS_PARENT/$DOMAIN_TLS_KEY"
postconf -e "smtpd_tls_loglevel = 1"
postconf -e "smtpd_tls_received_header = yes"
postconf -e "smtpd_tls_session_cache_timeout = 3600s"
postconf -e "tls_random_source = dev:/dev/urandom"
postconf -e "tls_random_prng_update_period = 3600s"
postconf -e "smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3"
postconf -e "smtpd_tls_mandatory_ciphers = high"
postconf -e "smtpd_tls_exclude_ciphers = ECDHE-RSA-RC4-SHA"
postconf -e "smtpd_tls_mandatory_exclude_ciphers = ECDHE-RSA-RC4-SHA"

#postconf -e "smtpd_tls_security_level = encrypt" #force TLS
#According to RFC 2487 this (encrypt) MUST NOT be applied in case of a publicly-referenced Postfix SMTP server

echo "$ALIASES" > /etc/postfix/aliases
newaliases

#virtual domain config
postconf -e "virtual_alias_domains = $VIRTUAL_DOMAINS"
postconf -e "virtual_alias_maps = lmdb:/etc/postfix/virtual"
echo "$VIRTUAL_ALIASES" > /etc/postfix/virtual
postmap /etc/postfix/virtual

postfix start-fg
