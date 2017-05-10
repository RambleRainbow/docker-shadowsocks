#!/bin/sh

CONF_TEMPLATE="/conf.d/template.json"
CONF_SERVER="/conf.d/server.json"
CONF_LOCAL="/conf.d/local.json"

function genPwd()
{
  echo `tr -cd A-Za-z0-9 < /dev/urandom | head -c${1:-16}`
}

function makeConf() 
{
  cp -f $CONF_TEMPLATE $1
  sed -i "s/<%SERVER%>/$2/" $1
  sed -i "s/<%PASSWORD%>/$3/" $1
}

if [ ! -f $CONF_TEMPLATE ]; then
  cp /templates/template.json $CONF_TEMPLATE
fi


if [ ! -f $CONF_SERVER ]; then
  pwd=`genPwd`;
  makeConf  $CONF_SERVER 0.0.0.0 $pwd;

  server=`curl www.query-ip.com -s`;
  makeConf $CONF_LOCAL $server $pwd;
fi

supervisord
supervisorctl start server
/bin/sh

