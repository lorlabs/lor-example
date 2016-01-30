# Lor Example

这是[lor](https://github.com/sumory/lor)框架的一个示例项目，用于展示如何使用lor框架搭建一个项目。


## 快速开始

### 配置更改

下载代码

```
git clone https://github.com/lorlabs/lor-example
```

特别注意以下几点，否则示例无法正常运行:

- conf是默认的nginx配置文件，特别注意要更改三个地方为你本机的对应配置
    - `include /data/software/openresty/nginx/conf/mime.types;`，这一行mime.types的路径要修改为你机器上的路径
    - lua_code_cache值要设为on，才能使得示例中的数据更改在刷新页面后继续生效
    - lua_package_path，请修改该值为你机器上的lua和lor对应配置

- app目录是lor项目代码目录


### 启动

两种启动方式

- lord start
- sh start.sh

### 访问

启动成功后，访问http://localhost:8888



### 讨论交流

目前有一个QQ群用于在线讨论：[![QQ群522410959](http://pub.idqqimg.com/wpa/images/group.png)](http://shang.qq.com/wpa/qunwpa?idkey=b930a7ba4ac2ecac927cb51101ff26de1170c0d0a31c554b5383e9e8de004834) 522410959


### License

MIT