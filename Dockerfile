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
COPY ./nginx /etc/nginx

#8000     for server: server port 

#1080/tcp for local : socks5 proxy
#53/udp   for local : dns server with ipset and gfwlist
#80/tcp for local : auto proxy pac file
EXPOSE 8000/tcp
EXPOSE 8000/udp
EXPOSE 1080/tcp
EXPOSE 53/udp
EXPOSE 80/tcp

ENTRYPOINT ["/entrypoint.sh"]


