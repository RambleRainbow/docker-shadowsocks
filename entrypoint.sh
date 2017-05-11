#!/bin/sh

CONF_TEMPLATE="/conf.d/template.json"
CONF_SERVER="/conf.d/server.json"
CONF_LOCAL="/conf.d/local.json"

function makeConf() 
{
  cp -f $CONF_TEMPLATE $1
  sed -i "s/<%SERVER%>/$2/" $1
  sed -i "s/<%PASSWORD%>/$3/" $1
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
    makeConf $CONF_LOCAL $server $pwd
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

supervisord

case $1 in
  -m)
    startAs $2
  ;;
  *)
    startAs "server"
  ;;
esac

/bin/sh

