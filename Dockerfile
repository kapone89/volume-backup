FROM alpine

RUN apk add --update \
    lz4 \
  && rm -rf /var/cache/apk/*

COPY volume-backup.sh /

ENTRYPOINT [ "/bin/sh", "/volume-backup.sh" ]
