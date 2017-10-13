---
title: Spring Boot - Redis
date: 2017-10-09 16:13:23
tags: Spring Boot
---

[Redis](http://redis.io/) is a cache, message broker and richly-featured key-value store. Spring Boot offers basic auto-configuration for the [Jedis](https://github.com/xetorthio/jedis/) client library and abstractions on top of it provided by [Spring Data Redis](https://github.com/spring-projects/spring-data-redis). There is a `spring-boot-starter-data-redis` ‘Starter’ for collecting the dependencies in a convenient way.



搭建环境

​     本文假设已经安装完成了Redis服务，并成功运行。

​     创建maven项目，添加依赖的Jar，本文主要使用jedis

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```



配置文件application.proerties.: 

```
# REDIS (RedisProperties)
# Redis数据库索引（默认为0）
spring.redis.database=1
# Redis服务器地址
spring.redis.host=127.0.0.1
# Redis服务器连接端口
spring.redis.port=6379
# Redis服务器连接密码（默认为空）
spring.redis.password=
```



You can inject an auto-configured `StringRedisTemplate` or vanilla `RedisTemplate` instance as you would any other Spring Bean. By default the instance will attempt to connect to a Redis server using `localhost:6379`:

```java
@Component
public class MyBean {

  	@Autowired
    private StringRedisTemplate template;
  
	@Autowired
    private RedisTemplate redisTemplate;

    public MyBean() {
    }

    // get
  	public Object get(String key) {
		return redisTemplate.opsForValue().get(key);
    }
  
  	// set
  	public void set(String key, Object value) {
        redisTemplate.opsForValue().set(key, value);
    }
  
    // getStringRedisTemplate
  	public Object getStringRedisTemplate(String key) {
		return template.opsForValue().get(key);
    }
  
  	// setStringRedisTemplate
  	public void setStringRedisTemplate(String key, Object value) {
        template.opsForValue().set(key, value);
    }
}
```

