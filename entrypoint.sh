#!/bin/sh

CONF_TEMPLATE="/conf.d/template.json"
CONF_SERVER="/conf.d/server.json"
CONF_LOCAL="/conf.d/local.json"
CONF_TUNNEL="/conf.d/tunnel.json"
CONF_REDIR="/conf.d/redir.json"
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
}

function startAsServer
{
  initConf
  supervisorctl start server
}

function startAsClient
{
  if [ -f $CONF_LOCAL ]; then
    supervisorctl start local
  fi

  if [ -f $CONF_TUNNEL ]; then
    supervisorctl start tunnel
  fi

  if [ -f $CONF_REDIR ]; then
    supervisorctl start redir
  fi
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

