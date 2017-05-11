FROM mritd/shadowsocks:3.0.6


RUN apk upgrade --no-cache &&\
    apk add --no-cache supervisor &&\
    apk add --no-cache curl

COPY ./conf.d /conf.d
COPY ./templates /templates
COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisor.d /etc/supervisor.d

#8000 default server port 
#1080 socks5 proxy
#1081 tunnel to 8.8.8.8:53
#1082 transparent gateway
EXPOSE 8000
EXPOSE 1080
EXPOSE 1081
EXPOSE 1082

ENTRYPOINT ["/entrypoint.sh"]


