---
title: JAVA后台运行
date: 2017-09-14 11:43:05
tags: java
---



下面我们来说说服务器上该如何来配置。

### nohup和Shell

该方法主要通过使用`nohup`命令来实现，该命令的详细介绍如下：

> nohup 命令
>
> 用途：不挂断地运行命令。
>
> 语法：nohup Command [ Arg … ][ & ]
>
> 描述：nohup 命令运行由 Command 参数和任何相关的 Arg 参数指定的命令，忽略所有挂断（SIGHUP）信号。在注销后使用 nohup 命令运行后台中的程序。要运行后台中的 nohup 命令，添加 `&`到命令的尾部。

所以，我们只需要使用`nohup java -jar yourapp.jar &`命令，就能让`yourapp.jar`在后台运行了。但是，为了方便管理，我们还可以通过Shell来编写一些用于启动应用的脚本，比如下面几个：

- 关闭应用的脚本：

  ```
  #!/usr/bin/env bash
  PID=$(ps -ef | grep yourapp.jar | grep -v grep | awk '{ print $2 }')  
  if [ -z "$PID" ]  
  then  
      echo Application is already stopped  
  else  
      echo kill $PID  
      kill $PID  
  fi 
  ```


- 启动应用的脚本：

  ```
  #!/usr/bin/env bash
  nohup java -jar yourapp.jar --server.port=8888 &
  ```


- 整合了关闭和启动的脚本：

  ```
  #!/usr/bin/env bash 
  stop() {
    PID=$(ps -ef | grep yourapp.jar | grep -v grep | awk '{ print $2 }')  
    if [ -z "$PID" ]  
    then  
        echo Application is already stopped  
    else  
        echo kill $PID  
        kill $PID  
    fi 
  }

  start() {
  	nohup java -jar yourapp.jar --server.port=8888 &
  }

  restart() {
      echo "restarting server"
      stop
      start "$1"
  }

  case $1 in
  start)
      start "$2"
      ;;

  stop)
      stop
      ;;

  restart)
      restart "$2"
      ;;
  *)
      echo "Usage: $0 {start|stop|restart}" >&2
      ;;

  esac

  exit 0
  ```