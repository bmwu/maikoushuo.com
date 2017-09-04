---
title: Hexo 基本命令&常见问题解决方案
date: 2017-08-23 10:33:47
tags: Hexo
---

#### 基本命令

```shell
 $ hexo new [layout] <title>
```

新建一篇文章。如果没有设置 `layout` 的话，默认使用 [_config.yml](https://hexo.io/zh-cn/docs/configuration.html) 中的 `default_layout` 参数代替。如果标题包含空格的话，请使用引号括起来。

```shell
$ hexo generate  简写 $ hexo g
```

 生成静态文件

| 选项               | 描述          |
| ---------------- | ----------- |
| `-d`, `--deploy` | 文件生成后立即部署网站 |
| `-w`, `--watch`  | 监视文件变动      |

```shell
 $ hexo server
```

 启动服务器。默认情况下，访问网址为： `http://localhost:4000/`。

```shell
 $ hexo clean
```

 清除缓存文件 (`db.json`) 和已生成的静态文件 (`public`)。

 在某些情况（尤其是更换主题后），如果发现您对站点的更改无论如何也不生效，您可能需要运行该命令。

```shell
 $ hexo deploy 简写 $ hexo d
```

 部署网站。

| 参数                 | 描述           |
| ------------------ | ------------ |
| `-g`, `--generate` | 部署之前预先生成静态文件 |

#### 删除文章

删除文章的过程一样也很简单，先删除本地文件，然后通过生成和部署命令进而将远程仓库中的文件也一并删除。

以hellowrld.md为例, 首先进入到source / _post 文件夹中，找到helloworld.md文件，在本地直接执行删除。然后依次执行`hexo g`，`hexo d`，再去主页查看你就会发现你的博客上面已经空空如也了，这就是如何删除文章的方法。

#### Deploy 没有错误信息,但不成功

**解决方案：**

1. 检查`_config.yml`中deploy设置。参见[http://hexo.io/docs/deployment.html](https://hexo.io/docs/deployment.html)。
2. 删除`.deploy_git`文件夹并且执行`hexo clean`后，重新`hexo deploy`。

