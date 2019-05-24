---
title: JAVA 运行排查工具 greys
date: 2019-05-23 15:36:04
tags: Java
---

### 简介
我们平时在线上或者开发中会遇到各种性能、功能等问题，在运行过程中需要查看方法入参、返回值，或者方法执行的堆栈时间，或者jar冲突时类加载来自那个jar包等问题。我们在开发过程中，可能会打印log日志、手动去打印入参、返回值等，或者自己实现简单的profile方法，代码侵入性大且效率较低；另外我们可以使用类似btrace工具去跟踪，这需要自己去实现btrace脚本，服务端需要启动agent，也有点小麻烦。后来淘宝聚石用scala写了个houseMD，但只支持到jdk1.6，后续也没有更新了；后面又有淘宝同学借鉴了btrace和houseMD，写了Greys，方便定位常见的java问题，下面简单介绍其使用方法。

下载地址：http://ompc.oss.aliyuncs.com/greys/release/greys-1.7.6.4-bin.zip

### 安装
- **在线安装（推荐）**

  请复制以下内容，并粘贴到命令行中。

  ```
  curl -sLk http://ompc.oss.aliyuncs.com/greys/install.sh|bash
  ```

  命令将会下载启动脚本文件`greys.sh`到当前目录，你可以放在任何地方或加入到`$PATH`中

- **本地安装**

  在某些情况下，目标服务器无法访问远程阿里云主机，此时你需要自行下载greys的安装文件。

  1. 下载最新版本的GREYS

     > <http://ompc.oss.aliyuncs.com/greys/release/greys-stable-bin.zip>

  2. 解压zip文件后，执行以下命令

     ```
     cd greys
     sh ./install-local.sh
     ```

     即完成本地安装。

### 待监控应用启动AGENT
pid为应用进程号
```shell
$ ./ga.sh pid
```
### 应用监控控制客户端
pid 为应用进程号， ip为应用所在机器， 3658为agent默认端口号
```shell
./greys.sh pid@ip:3658
```

或者远程访问telnet ip 3658
```shell
./gs.sh ip
```

### 命令清单

| 命令                                 | 说明                                                         |
| :---------------------------------- | ------------------------------------------------------------ |
| [help](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#help%E5%91%BD%E4%BB%A4) | 查看命令的帮助文档，每个命令和参数都有很详细的说明           |
| [sc](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#sc%E5%91%BD%E4%BB%A4) | 查看JVM已加载的类信息                                        |
| [sm](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#sm%E5%91%BD%E4%BB%A4) | 查看已加载的方法信息                                         |
| [monitor](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#monitor%E5%91%BD%E4%BB%A4) | 方法执行监控                                                 |
| [trace](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#trace%E5%91%BD%E4%BB%A4) | 渲染方法内部调用路径，并输出方法路径上的每个节点上耗时       |
| [ptrace](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#ptrace%E5%91%BD%E4%BB%A4) | 强化版的`trace`命令。通过指定渲染路径，并可记录下路径中所有方法的入参、返值；与`tt`命令联动。 |
| [watch](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#watch%E5%91%BD%E4%BB%A4) | 方法执行数据观测                                             |
| [tt](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#tt%E5%91%BD%E4%BB%A4) | 方法执行数据的时空隧道，记录下指定方法每次调用的入参和返回信息，并能对这些不同的时间下调用进行观测 |
| [stack](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#stack%E5%91%BD%E4%BB%A4) | 输出当前方法被调用的调用路径                                 |
| [js](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#js%E5%91%BD%E4%BB%A4) | 支持使用JavaScript脚本；支持CommonJS部分规范模块化（BMD规范） |
| [version](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#version%E5%91%BD%E4%BB%A4) | 输出当前目标Java进程所加载的Greys版本号                      |
| [quit](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#quit%E5%91%BD%E4%BB%A4) | 退出greys客户端                                              |
| [shutdown](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#shutdown%E5%91%BD%E4%BB%A4) | 关闭greys服务端                                              |
| [reset](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#reset%E5%91%BD%E4%BB%A4) | 重置增强类，将被greys增强过的类全部还原                      |
| [session](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#session%E5%91%BD%E4%BB%A4) | 查看当前会话                                                 |
| [jvm](https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf#jvm%E5%91%BD%E4%BB%A4) | 查看当前JVM的信息                                            |

#### 访问agent
```shell
telnet 10.57.17.146 3658   或  ./greys.sh 17602
```

#### 查看JVM已加载的类信息
```shell
sc -df cn.fraudmetrix.norns.controller.ListValueController
```

#### 查看类方法
```shell
sm -d cn.fraudmetrix.norns.controller.ListValueController *
```

#### 统计一段周期类方法执行情况（默认120s）
```shell
monitor -c 5 *ListValueController queryCache
```

#### 追踪方法执行链
```shell
trace cn.fraudmetrix.norns.controller.ListValueController queryCache
```

#### 查看方法执行时间
```shell
ptrace  -t -n 5 cn.fraudmetrix.norns.controller.ListValueController queryCache
```

#### 查看入参
```shell
watch -b cn.fraudmetrix.norns.controller.ListValueController queryCache '"partnerCode="+params[0]'
```

#### 查看返回值
```shell
watch -s cn.fraudmetrix.norns.controller.ListValueController queryCache returnObj -x 4
```

#### 统计方法执行时间
```shell
tt -t -n 3 cn.fraudmetrix.norns.controller.ListValueController queryCache
```

#### 重放请求
```shell
tt -i 1055 -p
```

#### 查看方法栈
```shell
stack cn.fraudmetrix.norns.controller.ListValueController queryCache
```

参考地址：
https://github.com/oldmanpushcart/greys-anatomy/wiki/greys-pdf