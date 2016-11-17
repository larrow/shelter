# 简介

shelter 是基于 RoR 搭建的 docker 私有仓库管理平台，和`harbor`这样的`企业级`平台不同，shelter 的设计目标是`非企业级`应用，我们期望，通过摒弃复杂的、冗长的研发方式，让中小型创业团队甚至个人也能拥有一个简单好用的 docker 私有仓库。

# 准备条件

`shelter`本身使用`docker`相关技术进行交付，因此您需要确保`docker daemon`和`docker compose`可用。
可以使用下列命令确定环境是否正常

* 确认docker daemon版本不低于 1.12（之前版本没有进行测试）

```
# docker info | grep "Server Version"
...
Server Version: 1.12.x
...
```

* 确认 docker compose 版本不低于 1.8

```
# docker-compose -v
docker-compose version 1.8.1, build 878cff1
```

# 使用说明

shelter 本身使用 docker 相关技术进行交付，因此您可以直接使用我们按照版本交付的 docker 镜像，最简单的做法是使用 deploy 目录下的脚本构建 docker 容器并提供服务。

以下脚本假设我们要在 192.168.0.10 这台宿主机上搭建私有仓库管理系统

* 准备

```
# wget https://github.com/larrow/shelter/blob/feature/deployable/deploy/init.sh
# chmod +x init.sh
# sh init.sh 192.168.0.10
```
* 启动

```
# docker-compose up -d
```

* 访问

shelter的compose文件缺省使用nginx进行服务代理，因此访问端口是nginx的服务端口 80 

> 由于这个例子是个最简方案，没有支持https，因此需要让访问私有仓库的 docker daemon 设定好 insecure-registry 参数，以 ubuntu 为例：
> 
> ```
# vi /etc/default/docker
...
DOCKER_OPTS="--insecure-registry 192.168.0.10" # 确保有这一句
...
# service docker restart # docker daemon 需要重启以使用上面的参数
```

下面是验证私有仓库是否可用的例子

```
# docker login 192.168.0.10
username: # 这里输入admin
password: # 这里输入缺省密码shelter12345

Login Success
```

