#!/bin/bash

cp -f ../../Dockerfile ./Dockerfile
sed -i "" "s/mritd\/shadowsocks:3\.0\.6/warmworm\/shadowsocks_armhf_base:3\.0\.6/" Dockerfile