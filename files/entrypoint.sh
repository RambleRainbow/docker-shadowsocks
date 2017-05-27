#!/bin/sh

PATH_CONF="/conf.d"
PATH_SSCONF=$PATH_CONF"/ss.d"
PATH_DNSCONF=$PATH_CONF"/dnsmasq"
PATH_NGINXCONF=$PATH_CONF"/nginx/www"

CONF_TEMPLATE=$PATH_SSCONF"/template.json"
CONF_SERVER=$PATH_SSCONF"/server.json"
CONF_LOCAL=$PATH_SSCONF"/local.json"
CONF_TUNNEL=$PATH_SSCONF"/tunnel.json"
CONF_REDIR=$PATH_SSCONF"/redir.json"

CONF_MAINCONF=$PATH_CONF"/main.conf"

CONF_DNS=$PATH_DNSCONF"/gfw.conf"
CONF_PAC=$PATH_NGINXCONF"/autoproxy.pac"

PORT_LOCAL=1080
PORT_TUNNEL=1081
PORT_REDIR=1082


function makeConf() 
{
  cp -f $CONF_TEMPLATE $1
  sed -i "s/<%SERVER%>/$2/" $1
  sed -i "s/<%PASSWORD%>/$3/" $1
  sed -i "s/<%LOCALPORT%>/$4/" $1
}

function initPath()
{
    mkdir -p PATH_CONF
    mkdir -p PATH_SSCONF
    mkdir -p PATH_DNSCONF
    mkdir -p PATH_NGINXCONF
}

function initConf()
{
  initPath;
  
  if [ ! -f $CONF_TEMPLATE ]; then
    cp /templates/template.json $CONF_TEMPLATE
  fi
  
  if [ ! -f $CONF_SERVER ]; then
    pwd=`tr -cd A-Za-z0-9 < /dev/urandom | head -c${1:-16}`;
    makeConf  $CONF_SERVER 0.0.0.0 $pwd;
  
    server=`curl www.query-ip.com -s`
    makeConf $CONF_LOCAL $server $pwd $PORT_LOCAL
    makeConf $CONF_TUNNEL $server $pwd $PORT_TUNNEL
    makeConf $CONF_REDIR $server $pwd $PORT_REDIR
  fi


  if [ ! -f $CONF_MAINCONF ]; then
    cp /templates/main.conf $CONF_MAINCONF > /dev/null 2>&1
  fi
}

function startAsServer
{
  initConf
  supervisorctl start server
}

function startAsClient
{
  supervisorctl start local
  supervisorctl start tunnel
  supervisorctl start redir

  if [ ! -f $CONF_PAC ]; then
    cat ${PATH_CONF}/main.conf | grep "pachost" | awk '{print $2}' | xargs sh /scripts/gendns.sh
  fi
  supervisorctl start dnsmasq 
  supervisorctl start nginx

  crond -c /crontabs 
}

function startAs()
{
  case $1 in 
    server)
      startAsServer
    ;;
    client)
      startAsClient
    ;;
    *)
      startAsServer
    ;;
  esac
}

supervisord -c /etc/supervisord.conf

case $1 in
  -m)
    startAs $2
  ;;
  *)
    startAs "server"
  ;;
esac

tail -f /var/log/supervisord.log
