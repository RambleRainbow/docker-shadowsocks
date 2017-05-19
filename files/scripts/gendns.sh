genpac --format=dnsmasq --dnsmasq-dns="127.0.0.1#1081" --dnsmasq-ipset="gfw" -o /conf.d/dnsmasq/gfw.conf
genpac --format=pac --pac-proxy="SOCKS5 ${1}" -o /conf.d/nginx/www/autoproxy.pac
