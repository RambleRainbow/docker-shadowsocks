#!/bin/sh

CONF_TEMPLATE="/templates/ss.json"
CONF_DEFAULT="/conf.d/ss.json"


function genPwd()
{
  echo `tr -cd A-Za-z0-9 < /dev/urandom | head -c${1:-10}`
}

function makeDefaultConf() 
{
  cp -f $CONF_TEMPLATE $CONF_DEFAULT 
  pwd=`genPwd`;
  sed -i "s/<%PASSWORD%>/${pwd}/" $CONF_DEFAULT;
}

if [ ! -f $CONF_DEFAULT ]; then
  makeDefaultConf;
fi

supervisord
supervisorctl start server
/bin/sh

