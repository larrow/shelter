# Shelter简介

shelter 是基于 RoR 搭建的 docker
私有仓库管理平台，和`harbor`这样的`企业级`平台不同，shelter
的设计目标是`非企业级`应用，我们期望，通过摒弃复杂的、冗长的研发方式和繁琐但用处不大的功能，让中小型创业团队甚至个人也能拥有一个简单好用的
docker 私有仓库。

# 启用

您可以用这个脚本获得一个完整的shelter系统——

```
curl -sSL https://raw.githubusercontent.com/larrow/shelter/master/deploy/init.sh | sh
```

这个脚本将完成以下工作：

* 如果有必要，安装 docker 和 compose
* 在当前目录下生成配置文件，shelter所服务的host由用户指定
* 执行 docker-compose up -d 启动 shelter 相关服务

# 清除

init脚本仅在当前目录下生成配置文件，因此删除shelter也很简单（在启用init脚本的那个目录下执行）

```
# docker-compose down
# rm -rf config
```

详细说明请参考 [Wiki](https://github.com/larrow/shelter/wiki)
