---
title: Spring Boot Banner
date: 2017-09-14 13:42:42
tags: Spring Boot
---



## SpringBootBanner

Spring Boot应用在启动的时候会输出一个Banner，同时还会输出使用的Spring Boot的版本。

如果你需要自己替换的话可以放置一个banner.txt文件，这样Spring Boot就会使用自定义的banner，而不是默认的banner。

[SpringBootBanner类](https://github.com/spring-projects/spring-boot/blob/master/spring-boot/src/main/java/org/springframework/boot/SpringBootBanner.java)

```java
/*
 * Copyright 2012-2015 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.boot;

import java.io.PrintStream;

import org.springframework.boot.ansi.AnsiColor;
import org.springframework.boot.ansi.AnsiOutput;
import org.springframework.boot.ansi.AnsiStyle;
import org.springframework.core.env.Environment;

/**
 * Default Banner implementation which writes the 'Spring' banner.
 *
 * @author Phillip Webb
 */
class SpringBootBanner implements Banner {

	private static final String[] BANNER = { "",
			"  .   ____          _            __ _ _",
			" /\\\\ / ___'_ __ _ _(_)_ __  __ _ \\ \\ \\ \\",
			"( ( )\\___ | '_ | '_| | '_ \\/ _` | \\ \\ \\ \\",
			" \\\\/  ___)| |_)| | | | | || (_| |  ) ) ) )",
			"  '  |____| .__|_| |_|_| |_\\__, | / / / /",
			" =========|_|==============|___/=/_/_/_/" };

	private static final String SPRING_BOOT = " :: Spring Boot :: ";

	private static final int STRAP_LINE_SIZE = 42;

	@Override
	public void printBanner(Environment environment, Class<?> sourceClass,
			PrintStream printStream) {
		for (String line : BANNER) {
			printStream.println(line);
		}
		String version = SpringBootVersion.getVersion();
		version = (version == null ? "" : " (v" + version + ")");
		String padding = "";
		while (padding.length() < STRAP_LINE_SIZE
				- (version.length() + SPRING_BOOT.length())) {
			padding += " ";
		}

		printStream.println(AnsiOutput.toString(AnsiColor.GREEN, SPRING_BOOT,
				AnsiColor.DEFAULT, padding, AnsiStyle.FAINT, version));
		printStream.println();
	}

}

```

## 关闭Banner

如果不打算使用上述的图案生成逻辑，则可以使用如下几种方式。

（1）直接修改main方法中的启动代码如下所示：

```java
SpringApplication springApplication = new SpringApplication(Application.class);
springApplication.setShowBanner(false);
springApplication.run(args);
```

​	Application.class对应自己项目中的配置类。

（2）使用SpringApplicationBuilder方式启动

```java
new SpringApplicationBuilder(Application.class).showBanner(false).run(args);
```

# 自定义Banner

1.在src/main/resources目录中新增banner.txt文件，文件的名称必须为banner.txt，否则不生效。

2.启动程序

```shell
////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//            佛祖保佑       永不宕机     永无BUG                    //
////////////////////////////////////////////////////////////////////
```



# 自定义Banner原理

[SpringApplication类](https://github.com/spring-projects/spring-boot/blob/master/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java)

```java
/**
 * Run the Spring application, creating and refreshing a new {@link ApplicationContext}.
 * @param args the application arguments (usually passed from a Java main method)
 * @return a running {@link ApplicationContext}
 */
public ConfigurableApplicationContext run(String... args) {
  StopWatch stopWatch = new StopWatch();
  stopWatch.start();
  ConfigurableApplicationContext context = null;
  Collection<SpringBootExceptionReporter> exceptionReporters = new ArrayList<>();
  configureHeadlessProperty();
  SpringApplicationRunListeners listeners = getRunListeners(args);
  listeners.starting();
  try {
    ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
    ConfigurableEnvironment environment = prepareEnvironment(listeners,
                                                             applicationArguments);
    configureIgnoreBeanInfo(environment);
    Banner printedBanner = printBanner(environment);
    context = createApplicationContext();
    exceptionReporters = getSpringFactoriesInstances(
      SpringBootExceptionReporter.class,
      new Class[] { ConfigurableApplicationContext.class }, context);
    prepareContext(context, environment, listeners, applicationArguments,
                   printedBanner);
    refreshContext(context);
    afterRefresh(context, applicationArguments);
    listeners.finished(context, null);
    stopWatch.stop();
    if (this.logStartupInfo) {
      new StartupInfoLogger(this.mainApplicationClass)
        .logStarted(getApplicationLog(), stopWatch);
    }
    return context;
  }
  catch (Throwable ex) {
    handleRunFailure(context, listeners, exceptionReporters, ex);
    throw new IllegalStateException(ex);
  }
}

private Banner printBanner(ConfigurableEnvironment environment) {
  if (this.bannerMode == Banner.Mode.OFF) {
    return null;
  }
  ResourceLoader resourceLoader = this.resourceLoader != null ? this.resourceLoader
    : new DefaultResourceLoader(getClassLoader());
  SpringApplicationBannerPrinter bannerPrinter = new SpringApplicationBannerPrinter(
    resourceLoader, this.banner);
  if (this.bannerMode == Mode.LOG) {
    return bannerPrinter.print(environment, this.mainApplicationClass, logger);
  }
  return bannerPrinter.print(environment, this.mainApplicationClass, System.out);
}
```

[**SpringApplicationBannerPrinter**类](https://github.com/spring-projects/spring-boot/blob/master/spring-boot/src/main/java/org/springframework/boot/SpringApplicationBannerPrinter.java)

```java
class SpringApplicationBannerPrinter {

	static final String BANNER_LOCATION_PROPERTY = "banner.location";

	static final String BANNER_IMAGE_LOCATION_PROPERTY = "banner.image.location";

	static final String DEFAULT_BANNER_LOCATION = "banner.txt";

	static final String[] IMAGE_EXTENSION = { "gif", "jpg", "png" };

	private static final Banner DEFAULT_BANNER = new SpringBootBanner();

	private final ResourceLoader resourceLoader;

	private final Banner fallbackBanner;

	SpringApplicationBannerPrinter(ResourceLoader resourceLoader, Banner fallbackBanner) {
		this.resourceLoader = resourceLoader;
		this.fallbackBanner = fallbackBanner;
	}

	public Banner print(Environment environment, Class<?> sourceClass, Log logger) {
		Banner banner = getBanner(environment);
		try {
			logger.info(createStringFromBanner(banner, environment, sourceClass));
		}
		catch (UnsupportedEncodingException ex) {
			logger.warn("Failed to create String for banner", ex);
		}
		return new PrintedBanner(banner, sourceClass);
	}

	public Banner print(Environment environment, Class<?> sourceClass, PrintStream out)  {
		Banner banner = getBanner(environment);
		banner.printBanner(environment, sourceClass, out);
		return new PrintedBanner(banner, sourceClass);
	}

	private Banner getBanner(Environment environment) {
		Banners banners = new Banners();
		banners.addIfNotNull(getImageBanner(environment));
		banners.addIfNotNull(getTextBanner(environment));
		if (banners.hasAtLeastOneBanner()) {
			return banners;
		}
		if (this.fallbackBanner != null) {
			return this.fallbackBanner;
		}
		return DEFAULT_BANNER;
	}

	private Banner getTextBanner(Environment environment) {
		String location = environment.getProperty(BANNER_LOCATION_PROPERTY,
				DEFAULT_BANNER_LOCATION);
		Resource resource = this.resourceLoader.getResource(location);
		if (resource.exists()) {
			return new ResourceBanner(resource);
		}
		return null;
	}

	private Banner getImageBanner(Environment environment) {
		String location = environment.getProperty(BANNER_IMAGE_LOCATION_PROPERTY);
		if (StringUtils.hasLength(location)) {
			Resource resource = this.resourceLoader.getResource(location);
			return (resource.exists() ? new ImageBanner(resource) : null);
		}
		for (String ext : IMAGE_EXTENSION) {
			Resource resource = this.resourceLoader.getResource("banner." + ext);
			if (resource.exists()) {
				return new ImageBanner(resource);
			}
		}
		return null;
	}

	private String createStringFromBanner(Banner banner, Environment environment,
			Class<?> mainApplicationClass) throws UnsupportedEncodingException {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		banner.printBanner(environment, mainApplicationClass, new PrintStream(baos));
		String charset = environment.getProperty("banner.charset", "UTF-8");
		return baos.toString(charset);
	}

	/**
	 * {@link Banner} comprised of other {@link Banner Banners}.
	 */
	private static class Banners implements Banner {

		private final List<Banner> banners = new ArrayList<>();

		public void addIfNotNull(Banner banner) {
			if (banner != null) {
				this.banners.add(banner);
			}
		}

		public boolean hasAtLeastOneBanner() {
			return !this.banners.isEmpty();
		}

		@Override
		public void printBanner(Environment environment, Class<?> sourceClass,
				PrintStream out) {
			for (Banner banner : this.banners) {
				banner.printBanner(environment, sourceClass, out);
			}
		}

	}

	/**
	 * Decorator that allows a {@link Banner} to be printed again without needing to
	 * specify the source class.
	 */
	private static class PrintedBanner implements Banner {

		private final Banner banner;

		private final Class<?> sourceClass;

		PrintedBanner(Banner banner, Class<?> sourceClass) {
			this.banner = banner;
			this.sourceClass = sourceClass;
		}

		@Override
		public void printBanner(Environment environment, Class<?> sourceClass,
				PrintStream out) {
			sourceClass = (sourceClass == null ? this.sourceClass : sourceClass);
			this.banner.printBanner(environment, sourceClass, out);
		}

	}

}
```

通过上面的代码可以知道用户自定义的Banner名称必须是banner.txt，除非自定义一个类继承SpringApplication类，并重写printBanner方法。