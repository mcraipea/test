FROM alpine:3.10

RUN apk update && apk add influxdb \
&& apk add --no-cache --upgrade bash

COPY ./start_influxdb.sh /start_influxdb.sh

RUN chmod +x start_influxdb.sh

EXPOSE 8086

CMD ["/start_influxdb.sh"]
