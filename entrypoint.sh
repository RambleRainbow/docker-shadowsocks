#!/bin/sh

CONF_TEMPLATE="/templates/ss.json"
CONF_DEFAULT="/conf.d/ss.json"


rm -f $CONF_DEFAULT;

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

/usr/bin/ssserver -c $CONF_DEFAULT
