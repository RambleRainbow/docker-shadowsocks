FROM mritd/shadowsocks:3.0.6


RUN apk upgrade --no-cache &&\
    apk add --no-cache supervisor &&\
    apk add --no-cache curl &&\
    apk add --no-cache dnsmasq &&\
    apk add --no-cache py-pip &&\
    apk add --no-cache nginx &&\
    pip install --no-cache-dir https://github.com/JinnLynn/genpac/archive/master.zip


COPY ./conf.d /conf.d
COPY ./templates /templates
COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisor.d /etc/supervisor.d
COPY ./scripts /scripts
COPY ./crontabs /crontabs


#8000/tcp default server port 
#1080/tcp socks5 proxy
#1082/tcp transparent gateway
#53/udp 
EXPOSE 8000
EXPOSE 1080
EXPOSE 1082
EXPOSE 53

ENTRYPOINT ["/entrypoint.sh"]


