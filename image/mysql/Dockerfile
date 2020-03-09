FROM alpine:3.10

RUN apk update \
&& apk add mariadb mariadb-client && apk add --no-cache --upgrade bash \
&& rm -rf /var/cache/apk/*

COPY ./start_mysql.sh .
COPY ./init_mysql.sh .
COPY ./my.cnf /etc/mysql/my.cnf
COPY wp.sql .

RUN chmod 777 start_mysql.sh
RUN chmod 777 init_mysql.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

CMD ./start_mysql.sh