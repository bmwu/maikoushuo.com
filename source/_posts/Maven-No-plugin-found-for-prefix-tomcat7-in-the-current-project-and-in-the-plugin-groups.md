---
title: >-
  Maven - No plugin found for prefix 'tomcat7' in the current project and in the
  plugin groups
date: 2017-09-20 15:04:32
tags: Maven
---



## 主题

直接正式进入主题: 当`mvn tomcat7:run`时, 抛出了"Maven - No plugin found for prefix 'tomcat7' in the current project and in the  plugin groups". 该怎么解决?

Ans: You are probably executing this command NOT from **your web project**. 



## 题外话

Maven如何使用[tomcat7插件](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/plugin-info.html), tomcat7-maven-plugin [插件官网](http://tomcat.apache.org/maven-plugin.html)

### 命令

[tomcat7:run](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/run-mojo.html)
运行当前项目

[tomcat7:deploy](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/deploy-mojo.html)
部署当前项目

[tomcat7:redeploy](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/deploy-mojo.html)
重新部署项目

[tomcat7:exec-war](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/exec-war-mojo.html)
创建一个可执行的jar文件，允许使用java -jar mywebapp.jar 运行web项目

[tomcat7:undeploy](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/undeploy-mojo.html)
取消部署一个war

[tomcat7:help](https://tomcat.apache.org/maven-plugin-trunk/tomcat7-maven-plugin/help-mojo.html)
在tomcat7-maven-plugin显示帮助信息

### pom.xml文件配置

```xml
<!-- tomcat7插件 -->
<plugin>
  <groupId>org.apache.tomcat.maven</groupId>
  <artifactId>tomcat7-maven-plugin</artifactId>
  <version>${tomcat.version}</version> 
  <configuration>
    <port>${webserver.port}</port>
    <path>/${project.artifactId}</path>
    <uriEncoding>${project.build.sourceEncoding}</uriEncoding>
  </configuration>
</plugin>
```

