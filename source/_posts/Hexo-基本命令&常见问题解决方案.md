---
title: Hexo 基本命令&常见问题解决方案
date: 2016-11-23 10:33:47
tags: Hexo
---


查看 npm 安装各 hexo 插件的情况
```shell
 $ npm ls --depth 0
 hexo-site@0.0.0 /IdeaProjects/github/bmwu.github.io
 ├── hexo@3.8.0
 ├── hexo-deployer-git@0.2.0
 ├── hexo-generator-archive@0.1.5
 ├── hexo-generator-category@0.1.3
 ├── hexo-generator-feed@1.2.2
 ├── hexo-generator-index@0.2.1
 ├── hexo-generator-tag@0.2.0
 ├── hexo-renderer-ejs@0.2.0
 ├── hexo-renderer-marked@0.2.11
 ├── hexo-renderer-stylus@0.3.3
 └── hexo-server@0.2.2
```

逐一解决包问题
```shell
$ npm install hexo-generator-archive --save
...
```

## 基本命令

### 新建

```shell
 $ hexo new [layout] <title>
```

新建一篇文章。如果没有设置 `layout` 的话，默认使用 [_config.yml](https://hexo.io/zh-cn/docs/configuration.html) 中的 `default_layout` 参数代替。如果标题包含空格的话，请使用引号括起来。

### 生成静态文件

```shell
$ hexo generate  简写 $ hexo g
```

| 选项               | 描述          |
| ---------------- | ----------- |
| `-d`, `--deploy` | 文件生成后立即部署网站 |
| `-w`, `--watch`  | 监视文件变动      |

### 启动服务器

```shell
 $ hexo server
```

 默认情况下，访问网址为： `http://localhost:4000/`。
 
### 清除缓存

```shell
 $ hexo clean
```

 清除缓存文件 (`db.json`) 和已生成的静态文件 (`public`)。

 在某些情况（尤其是更换主题后），如果发现您对站点的更改无论如何也不生效，您可能需要运行该命令。
 
### 部署

```shell
 $ hexo deploy 简写 $ hexo d
```

 部署网站

| 参数                 | 描述           |
| ------------------ | ------------ |
| `-g`, `--generate` | 部署之前预先生成静态文件 |

 Q：hexo deploy默认使用全局的git user.name user.email，那么请问能否hexo deploy 时带上临时指定的git账户 或者 在_config.yml指定git账户 使得push时与全局git账户区分开?
 
 A: 可以在_config.yml里面设置，hexo d 的时候会自动push代码到相应的repo
    1. 如果`.deploy_git`目录已经生成的情况下，需要删掉整个目录，再执行一次`hexo d`才行
    2. 原有所有的 git 提交记录全部没有了，会生产一个磨默认的"First commit"和你hexo d的那个。
 ```yaml
# You can use this:
deploy:
  type: git
  repo: <repository url>
  branch: [branch]
  message: [message]
  name: [git user]
  email: [git email]
  extend_dirs: [extend directory]
```

### 删除文章

删除文章的过程一样也很简单，先删除本地文件，然后通过生成和部署命令进而将远程仓库中的文件也一并删除。

以hellowrld.md为例, 首先进入到source / _post 文件夹中，找到helloworld.md文件，在本地直接执行删除。然后依次执行`hexo g`，`hexo d`，再去主页查看你就会发现你的博客上面已经空空如也了，这就是如何删除文章的方法。

## 常见问题及解决方案

### 1 Deploy 没有错误信息,但不成功

** 解决方案：**
1. 检查`_config.yml`中deploy设置。参见[http://hexo.io/docs/deployment.html](https://hexo.io/docs/deployment.html)。
2. 删除`.deploy_git`文件夹并且执行`hexo clean`后，重新`hexo deploy`。

### 2 当遇到 hexo g 生成的静态页面不正确时

** 解决方案：**
当遇到 hexo g 生成的静态页面不正确时，或者没有扫描到正确的source包时，可能就是hexo的generator的插件没有安装，查看hexo插件的安装情况并安装即可。

### 3 上传README.md

** 解决方案：**
修改Hexo目录下的_config.yml，将skip_render参数的值设置上。skip_render: README.md，保存退出即可。
使用hexo d 命令就不会在渲染 README.md 这个文件了。


