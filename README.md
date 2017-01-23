# Lor Example

这是[lor](https://github.com/sumory/lor)框架的一个示例项目，用于展示如何使用lor框架编写CURD API。


## 快速开始

### 配置更改

下载代码

```
git clone https://github.com/lorlabs/lor-example
```

特别注意以下几点， 否则示例无法正常运行:

- lua_code_cache值要设为on， 才能使得示例中的数据更改在刷新页面后继续生效
- lua_package_path， 请修改该值为你机器上的lua和lor对应配置


### 启动

- sh start.sh

### 访问

启动成功后，访问http://localhost:9999

### License

MIT
