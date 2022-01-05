FROM alpine:3.12
RUN apk update && \
  apk add --no-cache bash gettext tzdata && \
  apk add --no-cache postfix cyrus-sasl-plain && \
  rm -rf /var/lib/cache/apk/*
COPY conf /tmp/postfix_staging
COPY entrypoint.sh /usr/libexec
EXPOSE 25/tcp 587/tcp
VOLUME ["/etc/postfix", "/var/spool/postfix"]
ENTRYPOINT ["/usr/libexec/entrypoint.sh"]
