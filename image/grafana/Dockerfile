FROM alpine:3.10

RUN apk update && apk add --no-cache --upgrade bash \
&& apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat

RUN wget https://dl.grafana.com/oss/release/grafana-6.6.0.linux-amd64.tar.gz \
&& tar -zxvf grafana-6.6.0.linux-amd64.tar.gz \
&& rm /grafana-6.6.0/conf/defaults.ini \
&& rm -rf /var/cache/apk/* 	

COPY ./grafana.ini ./grafana-6.6.0/conf/
COPY ./grafana.db ./grafana-6.6.0/data/
COPY start_grafana.sh .

RUN chmod +x start_grafana.sh

EXPOSE 3000

CMD ./start_grafana.sh
