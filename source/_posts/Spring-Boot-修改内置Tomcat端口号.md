---
title: Spring Boot修改内置Tomcat端口号
date: 2017-09-14 13:42:46
tags: Spring Boot
---



Spring Boot 内置Tomcat默认端口号为8080，在开发多个应用调试时很不方便.

下面介绍一种**修改默认配置** 的方法:

Spring Boot默认配置文件为CLASSPATH下的application.properties

在application.properties中添加server.port=8081，可将tomcat默认端口号修改为8081