FROM alpine:3.5

RUN apk add --update python && \
    apk add py-pip &&\
    pip install shadowsocks==2.8.2

ADD ./conf.d /conf.d
ADD ./templates /templates
ADD ./entrypoint.sh /entrypoint.sh

EXPOSE 8000

CMD ["/entrypoint.sh"]


