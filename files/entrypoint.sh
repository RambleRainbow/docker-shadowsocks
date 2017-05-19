#!/bin/sh

CONF_TEMPLATE="/conf.d/ss.d/template.json"
CONF_SERVER="/conf.d/ss.d/server.json"
CONF_LOCAL="/conf.d/ss.d/local.json"
CONF_TUNNEL="/conf.d/ss.d/tunnel.json"
CONF_REDIR="/conf.d/ss.d/redir.json"
CONF_MAINCONF="/conf.d/main.conf"

CONF_DNS="/conf.d/dnsmasq/gfw.conf"
CONF_PAC="/conf.d/nginx/www/autoproxy.pac"

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

function initConf()
{
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
    cat /conf.d/main.conf | grep "pachost" | awk '{print $2}' | xargs sh /scripts/gendns.sh
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

/bin/sh 
