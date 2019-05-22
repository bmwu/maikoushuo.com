---
title: Spring Boot 定义统一异常错误码返回
date: 2017-09-14 13:42:47
tags: Spring Boot
---

### 配置

大致说下流程，

1. 首先我们自定义一个自己的异常类CustomException，继承RuntimeException。再写一个异常管理类ExceptionManager，用来抛出自定义的异常。
2. 然后重写configureHandlerExceptionResolvers统一异常处理.
3. 如果参数是CustomException类型，我们就自定义返回体,返回异常字典的错误信息。如果是其它类型的异常就返回系统异常。

话不多说，上代码。

#### 一、自定义的异常类

```
public class CustomException extends RuntimeException {

    public CustomException(String code, String msg) {
        super(code);
        this.code = code;
        this.msg = msg;
    }

    private String code;

    private String msg;

}
```

#### 二、异常管理类

```
@Component
public class ExceptionManager {

    @Resource
    Environment environment;

    public CustomException create(String code) {
        return new CustomException(code, environment.getProperty(code));
    }

}
```

> Environment是spring的环境类，会包含所有properties文件的键值对。

#### 三、异常字典 exception.properties

```
# 测试
EC00001=错误
```

> 需要加载到spring的环境中，我是用配置类加载的，方式如下:

```
@Component
@PropertySource(value = {"exception.properties"}, encoding = "UTF-8")
public class LoadProperty {

}
```

#### 四、全局异常捕捉类

```
@Configuration
public class WebMvcConfigurer extends WebMvcConfigurerAdapter {

	//统一异常处理
    @Override
    public void configureHandlerExceptionResolvers(List<HandlerExceptionResolver> exceptionResolvers) {
    exceptionResolvers.add((request, response, handler, e) -> {

        //如果是自定义的异常，返回对应的错误信息
        if (e instanceof CustomException) {
            e.printStackTrace();
            CustomException exception = (CustomException) e;
            return ApiResult.error(exception.getCode(), exception.getMsg());
        } else {
            //如果不是已知异常，返回系统异常
            e.printStackTrace();
            return ApiResult.error("SYS_EXCEPTION", "系统异常");
        }
    });
}
```

### 使用示例

```
@RestController
@RequestMapping("/exception")
public class ExceptionController {

    @Resource
    ExceptionManager exceptionManager;

    @RequestMapping("/controller")
    public String exceptionInController() {
        if (true) {
            throw exceptionManager.create("EC00001");
        }
        return "controller exception!";
    }

}
```

返回信息如下:

```
{
    "code": "EC00001",
    "msg": "错误"
}
```