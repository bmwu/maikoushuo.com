---
title: Spring Boot日志配置
date: 2017-09-14 14:42:59
tags: Spring Boot
---



# Spring Boot 日志配置

Spring Boot 采用 `Commons Logging` 作为内部的日志框架。对于日志的具体实现，则没有限制。默认的提供了对`Java Util Logging`，`Log4J2` 和 `Logback` 的支持。每种方式下，`Console`的日志输出，作为默认的日志输出。
在默认情况下，采用`Starters` 来启动Spring Boot 项目，`Logback` 是默认的日志实现方案。当然，Logback 路由能够保证依赖的包使用的其他日志也可以很好的工作。

maven依赖中添加了spring-boot-starter-logging：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
```

## 默认日志Logback

[SLF4J](http://www.slf4j.org/)——Simple Logging Facade For [Java](http://lib.csdn.net/base/javase)，它是一个针对于各类Java日志框架的统一[Facade](https://en.wikipedia.org/wiki/Facade_pattern)抽象。Java日志框架众多——常用的有`java.util.logging`, `log4j`, `logback`，`commons-logging`, Spring框架使用的是Jakarta Commons Logging API (JCL)。而SLF4J定义了统一的日志抽象接口，而真正的日志实现则是在运行时决定的——它提供了各类日志框架的binding。

[Logback](http://logback.qos.ch/)是log4j框架的作者开发的新一代日志框架，它效率更高、能够适应诸多的运行环境，同时天然支持SLF4J。

默认情况下，Spring Boot会用Logback来记录日志，并用INFO级别输出到控制台。在运行应用程序和其他例子时，你应该已经看到很多INFO级别的日志了。

![image](http://maikoushuo.oss-cn-beijing.aliyuncs.com/SpringBoot.png)

从上图可以看到，日志输出内容元素具体如下：

- 时间日期：精确到毫秒
- 日志级别：ERROR, WARN, INFO, DEBUG or TRACE
- 进程ID: 79996
- 分隔符：`---` 标识实际日志的开始
- 线程名：方括号括起来（可能会截断控制台输出）
- Logger名：通常使用源代码的类名
- 日志内容

那么，我们的Spring Boot应用将自动使用logback作为应用日志框架，Spring Boot启动的时候，由org.springframework.boot.logging.Logging-Application-Listener根据情况初始化并使用。

### 日志输出文件

默认情况下，Spring Boot将日志输出到控制台，不会写到日志文件。如果要编写除控制台输出之外的日志文件，则需在application.properties中设置logging.file或logging.path属性。

- logging.file，设置文件，可以是绝对路径，也可以是相对路径。如：`logging.file=my.log`
- logging.path，设置目录，会在该目录下创建spring.log文件，并写入日志内容，如：`logging.path=/var/log`

如果只配置 logging.file，会在项目的当前路径下生成一个 xxx.log 日志文件。
如果只配置 logging.path，在 /var/log文件夹生成一个日志文件为 spring.log

```properties
#日志输出
logging.file=logs/log.log
logging.level.root=INFO
logging.level.org.springframework.web=INFO
logging.level.org.hibernate=ERROR
```

> 注：二者不能同时使用，如若同时使用，则只有logging.file生效

**默认情况下，日志文件的大小达到10MB时会切分一次，产生新的日志文件，默认级别为：ERROR、WARN、INFO**

### 自定义日志配置

由于日志服务一般都在ApplicationContext创建前就初始化了，它并不是必须通过Spring的配置文件控制。因此通过系统属性和传统的Spring Boot外部配置文件依然可以很好的支持日志控制和管理。

根据不同的日志系统，你可以按如下规则组织配置文件名，就能被正确加载：

- Logback：`logback-spring.xml`, `logback-spring.groovy`, `logback.xml`, `logback.groovy`
- Log4j：`log4j-spring.properties`, `log4j-spring.xml`, `log4j.properties`, `log4j.xml`
- Log4j2：`log4j2-spring.xml`, `log4j2.xml`
- JDK (Java Util Logging)：`logging.properties`

**Spring Boot官方推荐优先使用带有-spring的文件名作为你的日志配置（如使用logback-spring.xml，而不是logback.xml），命名为logback-spring.xml的日志配置文件，spring boot可以为它添加一些spring boot特有的配置项（下面会提到）。**

上面是默认的命名规则，并且放在`src/main/resources`下面即可。