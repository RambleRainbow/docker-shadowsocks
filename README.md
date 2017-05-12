### docker-shadowsocks
基于mritd/shadowsocks镜像的Dockerfile
提供shadowsocks常用功能的整体解决方案
包括，服务端ss-server功能
以及客户端的socks5代理(ss-local)、dns污染处理(dnsmasq-pac)、自动代理(gfw autoproxy)


### 安装
请先确认已经安装docker

```shell
$ docker pull warmworm/shadowsocks
```
### 使用方法

#### 服务端

注：服务端是指能访问到你想访问到的网络的宿主机，一般来说都是国外的VPS主机

##### 启动服务端
```shell

#创建配置目录
~$ sudo mkdir /etc/ss.d

#启动docker容器
~$ docker run -id --name=shadowsocks -p 8000:8000/tcp -p 8000:8000/udp -v /etc/ss.d:/conf.d warmworm/shadowsocks
```

#### 客户端

注：客户端是指提供代理服务，给你的浏览器等软件通过代理，并转接到上述服务端，进行网络访问的主机

##### 准备工作
请先把服务端中/etc/ss.d中的所有文件，复制到本机的/etc/ss.d中
```shell
~$ sudo mkdir /etc/ss.d
~$ sudo cp /your/server/ss.d/path /etc/ss.d
```
##### 指定你本机的IP地址（可选步骤）
注：如果你的自动代理服务要向除本机外的其它电脑使用，才需要执行这个步骤
```shell
~$ sudo /etc/ss.d/init-client.sh
```

##### 启动客户端
```shell

~$ sudo docker run -id --name=shadowsocks -p 1080:1080/tcp -p 53:53/udp -p 80:80/tcp -v /etc/ss.d:/conf.d warmworm/shadowsocks
```
