FROM alpine:3.10

RUN apk --no-cache add vsftpd

COPY start_ftps.sh .
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN chmod +x start_ftps.sh

EXPOSE 21 21000

CMD ./start_ftps.sh