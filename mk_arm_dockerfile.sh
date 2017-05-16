#!/bin/bash

cp -f Dockerfile ARM-Dockerfile
sed -i "" "s/mritd\/shadowsocks/warmworm\/shadowsocks_armhf_base/g" ARM-Dockerfile
