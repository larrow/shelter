# Shelter简介 [![travis任务状态](https://travis-ci.org/larrow/shelter.svg?branch=master)](https://travis-ci.org/larrow/shelter)

shelter 是基于 Ruby on Rails 搭建的 docker 私有镜像管理平台，和 [Harbor](https://github.com/vmware/harbor) 这样的企业级平台不同，shelter 的设计目标是`非企业级`应用。本项目希望摒弃复杂冗长的研发方式，以及繁琐但用处不大的功能，让中小型创业团队甚至个人也能拥有一个简单好用的 docker 私有仓库。

[![用户指南](https://github.com/larrow/shelter/wiki/shelter_integration_test.gif)](https://youtu.be/RkhEYJ_7n_o)

# 准备条件

`shelter`本身使用`docker`相关技术进行交付，因此您需要确保`docker daemon`和`docker compose`可用。

* 确认docker daemon版本不低于 1.12（之前版本没有进行测试）

```
# docker info | grep "Server Version"
Server Version: 1.12.x
```

* 确认 docker compose 版本不低于 1.8

```
# docker-compose -v
docker-compose version 1.8.1, build 878cff1
```

# 启用

您可以用这个脚本获得一个完整的shelter系统(假定shelter对外服务的ip为192.168.0.10)——

```
SHELTER_HOST=192.168.0.10 curl -sSL https://raw.githubusercontent.com/larrow/shelter/master/deploy/init.sh | sh
```

这个脚本将完成以下工作：

* 在当前目录下生成配置文件
* shelter所服务的主机名用SHELTER\_HOST环境变量指定
* 执行 docker-compose up -d 启动 shelter 相关服务

# 清除

init脚本仅在当前目录下生成配置文件，因此删除shelter也很简单（在启用init脚本的那个目录下执行）

```
# docker-compose down
# rm -rf config docker-compose.yml
```

详细的使用指南请参考 [Wiki](https://github.com/larrow/shelter/wiki)
