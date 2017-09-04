---
title: NPM使用
date: 2017-08-30 14:37:14
tags: NPM
---

**NPM(node package manager)**是随同NodeJS一起安装的包管理工具，能解决NodeJS代码部署上的很多问题，常见的使用场景有以下几种：

- 允许用户从NPM服务器下载别人编写的第三方包到本地使用。
- 允许用户从NPM服务器下载并安装别人编写的命令行程序到本地使用。
- 允许用户将自己编写的包或命令行程序上传到NPM服务器供别人使用。

npm官网：[https://npmjs.org/](https://npmjs.org/)



##### 本地安装 vs 全局安装

node 包安装分两种: 本地安装和全局安装.

- 本地安装: `npm install {package}`  - package会被下载到当前所在目录, 也只能在当前目录下使用.
- 全局安装: `npm install -g {package}` - package会被下载到特定的系统目录下, 安装的package能够在所有目录下使用.

```shell
➜  datav-coms npm install datav-cli -g
/Users/{user}/.nvm/versions/node/v6.9.1/bin/datav -> /Users/{user}/.nvm/versions/node/v6.9.1/lib/node_modules/datav-cli/bin/maliang.js
/Users/{user}/.nvm/versions/node/v6.9.1/lib
└─┬ datav-cli@0.2.1
  ├── bcore@0.0.18
  ├─┬ body-parser@1.15.2
  │ ├── bytes@2.4.0
  ...
```

- datav-cli@0.2.1: package名字为datav-cli, 版本号为0.2.1

- node_modules/datav-cli: 安装目录

- bcore@0.0.18: 依赖包

  ​


`npm ls`: 查看安装包, 如果是要查看package的全局安装信息，加上`-g`就可以

`npm ls pkg`：查看特定package的信息

`npm update pkg`: 更新

`npm search pkg`: 搜索