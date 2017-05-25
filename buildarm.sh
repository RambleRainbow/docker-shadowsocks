#!/bin/bash

echo "1.copy and rebase dockerfile"
cp -f ../../Dockerfile ./Dockerfile_arm
sed -i "" "s/mritd\/shadowsocks:3\.0\.6/warmworm\/shadowsocks_armhf_base:3\.0\.6/" Dockerfile

echo "2.copy docker images files"
rm -rf files
cp -r ../../files .

echo "3.please input images tag:"
read imgTag
docker build -t warmworm/shadowsocks_armhf:${imgTag} -f Dockerfile_arm

echo "4.push image"
docker push warmworm/shadowsocks_armhf:${imgTag}

echo "5. clean"
rm -rf Dockerfile_arm files

echo "6.finshed"

