# language: zh-CN
功能: 搜索
  场景: 普通用户镜像搜索
    假定创建用户u
    并且用户u登录
    并且在u中添加镜像searchtest1，版本为v1，成功
    并且在u中添加镜像searchtest2，版本为v1，成功
    并且在u中添加镜像othertest，版本为v1，成功
    当以search为关键字执行搜索
    那么搜索结果包括镜像searchtest1,searchtest2
    那么搜索结果不包括镜像othertest
  场景: 管理员综合搜索
    假定创建用户userx1,userx2
    并且用户u1创建用户组groupx
    假定管理员登录
    并且管理员在library中添加镜像x，版本为v1，成功
    当以x为关键字执行搜索
    那么搜索结果包括镜像x
    那么搜索结果包括用户组userx1,userx2,groupx


