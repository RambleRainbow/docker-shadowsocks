#!/bin/bash

echo "1.copy and rebase dockerfile"
cp -f Dockerfile Dockerfile_arm
sed -i "" "s/mritd\/shadowsocks:3\.0\.6/warmworm\/shadowsocks_armhf_base:3\.0\.6/" Dockerfile_arm

echo "2.input images tag:"
read -p "please input tag(like 0.0.x):  " imgTag 
docker build -t warmworm/shadowsocks_armhf:${imgTag} . -f Dockerfile_arm

echo "3.push image"
docker push warmworm/shadowsocks_armhf:${imgTag}

echo "4. clean"
rm -rf Dockerfile_arm

echo "5.finshed"

