---
title: MyBatis-Spring 配置
date: 2017-08-23 11:58:06
tags:
---

##### SqlSessionFactoryBean 配置

在基本的 MyBatis 中,session 工厂可以使用 SqlSessionFactoryBuilder 来创建。而在 MyBatis-[spring](http://lib.csdn.net/base/javaee) 中,则使用 SqlSessionFactoryBean 来替代。

###### dataSource 属性

该属性必须配置，多数据源时会有多个`dataSource`，同时也需要配置多个`sqlSessionFactory`来对应

###### **mapperLocations属性**

配置该属性后，`sqlSessionFactory`会自动扫描该路径下的所有文件并解析。

该路径支持多个，可以用`,;\t\n`进行分割。每一个路径都可以用直接的包路径，或者Ant风格的表达式。

###### **configLocation属性**

当`SqlSessionFactoryBean`提供的配置不能满足使用时，你可以使用`mybatis-config.xml`配置文件配置其他属性，然后通过`configLocation`属性指定该配置的路径，`SqlSessionFactoryBean`会使用该配置文件创建`Configuration`。

```xml
<!-- 创建SqlSessionFactory，同时指定数据源 -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
  <property name="dataSource" ref="dataSource" />
  <!-- 自动扫描mapping.xml文件 -->  
  <property name="configLocation" value="classpath:mybatis-config.xml"/>
  <property name="mapperLocations" value="classpath:mybatis/*.xml" />
</bean>
```

##### MapperScannerConfigurer 配置

为了代替手工使用 SqlSessionDaoSupport 或 SqlSessionTemplate 编写数据访问对象 (DAO)的代码,MyBatis-Spring 提供了一个动态代理的实现:MapperFactoryBean。这个类 可以让你直接注入数据映射器接口到你的 service 层 bean 中。当使用映射器时,你仅仅如调 用你的 DAO 一样调用它们就可以了,但是你不需要编写任何 DAO 实现的代码,因为 MyBatis-Spring 将会为你创建代理。

```xml
<!-- DAO接口所在包名，Spring会自动查找其下的类 --> 
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
  <property name="basePackage" value="com.company.project.dao" />
  <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
</bean>
```

一般用过的最多也就是这3个属性，实际情况下最常用的只有`basePackage`。

###### basePackage属性

`basePackage`可以写多个，可以用`,;\t\n`进行分割。每一个路径都可以用直接的包路径，或者Ant风格的表达式。

###### annotationClass属性

该属性实际上就是起到一个过滤的作用，如果设置了该属性，那么MyBatis的接口只有包含该注解，才会被扫描进去。

###### sqlSessionFactoryBeanName属性

这个属性一般都用不到，只有当你配置多数据源的时候，这是会有多个`sqlSessionFactory`，你就需要通过该属性来指定哪一个`sqlSessionFactory`（值为`SqlSessionFactoryBean` `<bean>`配置中的`id`属性）。

##### MyBatis-Java配置 (spring-boot)

application.properties (依赖MySQL JDBC驱动 mysql-connector-java)

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/test
spring.datasource.username=root
spring.datasource.password=password
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

MybatisConfigurer.java

```java
@Configuration
public class MybatisConfigurer {

    @Bean
    public SqlSessionFactory sqlSessionFactoryBean(DataSource dataSource) throws Exception {
        SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
        factory.setDataSource(dataSource);
        factory.setTypeAliasesPackage(MODEL_PACKAGE);

        //配置分页插件，详情请查阅官方文档
        PageHelper pageHelper = new PageHelper();
        Properties properties = new Properties();
        properties.setProperty("pageSizeZero", "true");//分页尺寸为0时查询所有纪录不再执行分页
        properties.setProperty("reasonable", "true");//页码<=0 查询第一页，页码>=总页数查询最后一页
        properties.setProperty("supportMethodsArguments", "true");//支持通过 Mapper 接口参数来传递分页参数
        pageHelper.setProperties(properties);

        //添加插件
        factory.setPlugins(new Interceptor[]{pageHelper});

        //添加XML目录
        ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        factory.setMapperLocations(resolver.getResources("classpath:mapper/*.xml"));
        return factory.getObject();
    }

    @Bean
    public MapperScannerConfigurer mapperScannerConfigurer() {
        MapperScannerConfigurer mapperScannerConfigurer = new MapperScannerConfigurer();
        mapperScannerConfigurer.setSqlSessionFactoryBeanName("sqlSessionFactoryBean");
        mapperScannerConfigurer.setBasePackage(MAPPER_PACKAGE);   // Mapper所在包

        //配置通用Mapper，详情请查阅官方文档
        Properties properties = new Properties();
        properties.setProperty("mappers", MAPPER_INTERFACE_REFERENCE); // Mapper插件基础接口的完全限定名
        properties.setProperty("notEmpty", "false");//insert、update是否判断字符串类型!='' 即 test="str != null"表达式内是否追加 and str != ''
        properties.setProperty("IDENTITY", "MYSQL");
        mapperScannerConfigurer.setProperties(properties);

        return mapperScannerConfigurer;
    }
}
```

参考:

[MyBatis-Spring配置](http://blog.csdn.net/isea533/article/details/45640319)