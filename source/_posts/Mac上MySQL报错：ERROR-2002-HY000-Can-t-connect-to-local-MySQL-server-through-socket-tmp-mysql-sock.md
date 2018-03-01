---
title: >-
  Mac上MySQL报错：ERROR 2002 (HY000): Can't connect to local MySQL server through
  socket '/tmp/mysql.sock'
date: 2018-03-01 09:45:22
tags: mysql
---



1. 执行：`$ brew install mysql`

2. 配置文件: `/usr/local/etc/my.cnf`

3. 启动：`mysql.server start`

4. `mysql -uroot -p` 

   如果不执行3，会出现以下错误：

   `ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)`

