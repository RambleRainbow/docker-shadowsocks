docker-shadowsocks
===
基于[mritd/shadowsocks](https://hub.docker.com/r/mritd/shadowsocks)镜像的Dockerfile提供shadowsocks常用功能的整体解决方案
>服务端
>>ss-server功能
>客户端
>>`socks5代理`(ss-local)<br>
`dns污染处理`(dnsmasq-pac)<br>
`自动代理`(gfw autoproxy)


一、安装
===
请先确认已经安装docker,然后执行下面命令
>1.1 提取DOCKER镜像
>>```shell
>>$ docker pull warmworm/shadowsocks
>>```
二、使用方法
===
>2.1服务端<br>
注：服务端是指能访问到你想访问到的网络的宿主机，一般来说都是国外的VPS主机
>>step 1. 启动服务端
>>> ```shell
>>> #创建配置目录
>>> ~$ sudo mkdir /etc/ss.d
>>> #启动docker容器
>>> ~$ docker run -id --name=ss-server\ 
>>>               -p 8000:8000/tcp\
>>>               -p 8000:8000/udp\
>>>               -v /etc/ss.d:/conf.d\
>>>               warmworm/shadowsocks
>>> ```
>2.2客户端<br>
>注：客户端是指提供代理服务，给你的浏览器等软件通过代理，并转接到上述服务端，进行网络访问的主机
>>step 1. 准备工作
>>>请先把服务端中/etc/ss.d中的所有文件，复制到本机的/etc/ss.d中
>>>```shell
>>>~$ sudo mkdir /etc/ss.d
>>>~$ sudo cp /your/server/ss.d/path /etc/ss.d
>>>```
>>step 2. 指定你本机的IP地址（可选步骤）
注：如果你的自动代理服务要向除本机外的其它电脑使用，才需要执行这个步骤
>>>```shell
>>>请直接修改编译 /etc/ss.d/main.conf文件中的pachost字段
>>>~$ cat /etc/ss.d/main.conf
>>>pachost 127.0.0.1:1080
>>>~$
>>>```
>>step 3. 启动客户端
>>>```shell
>>>~$ sudo docker run -id --name=shadowsocks \
>>>                   -p 1080:1080/tcp \
>>>                   -p 53:53/udp \
>>>                   -p 80:80/tcp \
>>>                   -v /etc/ss.d:/conf.d \
>>>                   warmworm/shadowsocks -m client
>>>```
