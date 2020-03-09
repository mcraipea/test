FROM alpine:3.10

RUN apk upgrade && \
    printf '%s\n' \
      '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
      >> /etc/apk/repositories && \
    apk update && \
    apk add pure-ftpd@testing="1.0.49-r0" && \
    rm -rf /var/cache/apk/*

COPY pure-ftpd.pem /etc/ssl/private/
COPY start_ftps.sh .

RUN chmod +x start_ftps.sh

EXPOSE 21

CMD ./start_ftps.sh