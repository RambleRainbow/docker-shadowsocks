FROM mritd/shadowsocks:3.0.6


RUN apk upgrade --no-cache &&\
    apk add --no-cache supervisor &&\
    apk add --no-cache curl

COPY ./conf.d /conf.d
COPY ./templates /templates
COPY ./entrypoint.sh /entrypoint.sh

COPY ./supervisor.d /etc/supervisor.d


EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]


