# toolkit

这是一个集成了 frps 及 vlmcsd 的镜像

## 当前版本

- vlmcsd：2025-04-16 编译
- frps：v0.62.1

## 如何使用

修改`conf.d/frps.toml`中的`webServer.password`及`auth.token`即可，亦可以参考 Frps 官方的配置。

## 示例

文件结构，以上文件啊均可以从仓库中获取到

```
.
├── conf.d
│   └── frps.toml
└── docker-compose.yml
```

```shell
docker compose up -d
```
