---
title: Maven插件
date: 2017-09-12 19:46:57
tags: Maven
---

我们都知道Maven本质上是一个插件框架，它的核心并不执行任何具体的构建任务，所有这些任务都交给插件来完成，例如编译源代码是由maven-compiler-plugin完成的。进一步说，每个任务对应了一个插件目标（goal），每个插件会有一个或者多个目标，例如maven-compiler-plugin的compile目标用来编译位于src/main/java/目录下的主源码，testCompile目标用来编译位于src/test/java/目录下的测试源码。

用户可以通过两种方式调用Maven插件目标。第一种方式是将插件目标与生命周期阶段（lifecycle phase）绑定，这样用户在命令行只是输入生命周期阶段而已，例如Maven默认将maven-compiler-plugin的compile目标与compile生命周期阶段绑定，因此命令mvn compile实际上是先定位到compile这一生命周期阶段，然后再根据绑定关系调用maven-compiler-plugin的compile目标。第二种方式是直接在命令行指定要执行的插件目标，例如mvn archetype:generate 就表示调用maven-archetype-plugin的generate目标，这种带冒号的调用方式与生命周期无关。

认识上述Maven插件的基本概念能帮助你理解Maven的工作机制，不过要想更高效率地使用Maven，了解一些常用的插件还是很有必要的，这可以帮助你避免一不小心重新发明轮子。多年来Maven社区积累了大量的经验，并随之形成了一个成熟的插件生态圈。Maven官方有两个插件列表，第一个列表的GroupId为org.apache.maven.plugins，这里的插件最为成熟，[具体地址](http://maven.apache.org/plugins/index.html)。第二个列表的GroupId为org.codehaus.mojo，这里的插件没有那么核心，但也有不少十分有用，[地址](http://mojo.codehaus.org/plugins.html)。

接下来我根据自己的经验介绍一些Maven的打包和运行，熟练地使用它们能让你的日常构建工作事半功倍。


## 打包和运行

将项目进行编译, 测试之后, 下一个重要步骤就是打包(package ), 我们可以简单地执行命令**mvn clean package**进行打包, 可以看到如下输出:

```shell
➜  maikou git:(master) ✗ mvn clean package
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building maikou 1.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.6.1:clean (default-clean) @ maikou ---
[INFO] Deleting /Users/michael/Desktop/github/maikou/target
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ maikou ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 4 resources
[INFO] Copying 20 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ maikou ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 95 source files to /Users/michael/Desktop/github/maikou/target/classes
[WARNING] /Users/michael/Desktop/github/maikou/src/main/java/com/maikou/core/AbstractService.java: /Users/michael/Desktop/github/maikou/src/main/java/com/maikou/core/AbstractService.java uses unchecked or unsafe operations.
[WARNING] /Users/michael/Desktop/github/maikou/src/main/java/com/maikou/core/AbstractService.java: Recompile with -Xlint:unchecked for details.
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ maikou ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 5 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ maikou ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /Users/michael/Desktop/github/maikou/target/test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.18.1:test (default-test) @ maikou ---
[INFO] 
[INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ maikou ---
[INFO] Building jar: /Users/michael/Desktop/github/maikou/target/maikou-1.0.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 6.558 s
[INFO] Finished at: 2017-09-12T20:17:20+08:00
[INFO] Final Memory: 33M/284M
[INFO] ------------------------------------------------------------------------

```

细数了下, 共用到了7个插件, 每个插件都是默认配置, Maven实际执行了：clean: clean，resources: resources，compiler: compile，resources: testResources，compiler: testCompile，surefire: test,  jar:jar。详细来说，Maven在打包时，会执行：目录清理、主资源处理、主代码编译、测试资源处理、测试代码编译、执行测试, 打包等过程，这是Maven生命周期的一个特性.

`maven-clean-plugin:2.6.1:clean (default-clean) ` 

**清理目录** target/

当你在命令行运行Maven的时候你经常会在任何其它生命周期阶段前指定clean生命周期阶段。当你指定clean，你就确认了在编译和打包一个应用之前，Maven会移除旧的输出。运行clean不是必要的，但这是一个确保你正执行“干净构建”的十分有用的预防措施

`maven-resources-plugin:2.6:resources (default-resources) `

**主资源处理**

`maven-compiler-plugin:3.1:compile (default-compile) `

**主代码编译**，默认输出到target/目录下.

`maven-resources-plugin:2.6:testResources (default-testResources) `

**测试资源处理**

`maven-compiler-plugin:3.1:testCompile (default-testCompile) `

**测试代码编译**

`maven-surefire-plugin:2.18.1:test (default-test) `

**执行测试**: surefire是执行测试的插件，其运行测试用例，并输出测试报告

`maven-jar-plugin:2.6:jar (default-jar) `

**进行打包**: 会生成名为*maikou-1.0-SNAPSHOT.jar*, 该文件位于*target/*输出目录中, 它是根据artifact-version.jar规则进行命名的，如有需要，我们还可以使用*finalName*来自定义该文件的名称.

至此，我们得到了项目的输出，如果有需要的话，就可以复制这个jar文件到其他项目的Classpath中从而使用maikou类。但是，如何才能让其他的Maven项目直接引用这个jar呢？我们还需要一个安装的步骤，执行 **mvn clean install**, 相比较**mvn clean package** 多了一个plugin的信息

```shell
[INFO] --- maven-install-plugin:2.5.2:install (default-install) @ maikou ---
[INFO] Installing /Users/michael/Desktop/github/maikou/target/maikou-1.0.jar to /Users/michael/.m2/repository/com/maikou/maikou/1.0/maikou-1.0.jar
[INFO] Installing /Users/michael/Desktop/github/maikou/pom.xml to /Users/michael/.m2/repository/com/maikou/maikou/1.0/maikou-1.0.pom
[INFO] ------------------------------------------------------------------------
```

`maven-install-plugin:2.5.2:install`

从输出我们看到该任务将项目输出的jar安装到了Maven本地仓库中，我们可以打开相应的文件夹看到maikou项目的pom和jar。只有将maikou的构件安装到本地仓库之后，其他Maven项目才能使用它。

我们已经将体验了Maven最主要的命令：**mvn clean package**、**mvn clean install**。执行test之前是会先执行compile的，执行package之前是会先执行test的，而类似地，install之前会执行package。我们可以在任何一个Maven项目中执行这些命令，而且我们已经清楚它们是用来做什么的。

到目前为止，我们还没有运行maikou项目，不要忘了maikou类可是有一个main方法的。默认打包生成的jar是不能够直接运行的，因为带有main方法的类信息不会添加到manifest中(我们可以打开jar文件中的*META-INF/MANIFEST.MF*文件，将无法看到Main-Class一行)

```makefile
Manifest-Version: 1.0
Implementation-Title: maikou
Implementation-Version: 1.0
Archiver-Version: Plexus Archiver
Built-By: michael
Implementation-Vendor-Id: com.maikou
Created-By: Apache Maven 3.3.9
Build-Jdk: 1.8.0_102
Implementation-URL: http://projects.spring.io/spring-boot/maikou/
Implementation-Vendor: Pivotal Software, Inc.
```

如果使用java -jar 命令执行运行jar文件, 会出现错误

```shell
➜  maikou git:(master) ✗ java -jar target/maikou-1.0.jar 
no main manifest attribute, in target/maikou-1.0.jar
```

首先, 我们在jar包中的META-INF/MANIFEST.MF中指定Main-Class，这样才能确定程序的入口在哪里, 我们借助**maven-jar-plugin**, 插件配置如下:

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-jar-plugin</artifactId>
  <version>2.3</version>
  <configuration>
    <finalName>${project.artifactId}</finalName>
    <archive>
      <index>1</index>
      <manifest>
        <mainClass>com.maikou.Application</mainClass>
      </manifest>
    </archive>
  </configuration>
</plugin>
```

继续使用java -jar 命令执行运行jar文件, 出现错误如下:

```shell
➜  maikou git:(master) ✗ java -jar target/maikou.jar    
Exception in thread "main" java.lang.NoClassDefFoundError: org/springframework/boot/SpringApplication
        at com.maikou.Application.main(Application.java:9)
Caused by: java.lang.ClassNotFoundException: org.springframework.boot.SpringApplication
        at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
        at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
        at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:331)
        at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
        ... 1 more
```

从输出可以看出没有加载到依赖包. 

这里要明确一个概念, 要想jar包能直接通过java -jar xxx.jar运行，需要满足：

1、在jar包中的META-INF/MANIFEST.MF中指定Main-Class，这样才能确定程序的入口在哪里；

2、要能加载到依赖包。

### 方法一: 使用maven-jar-plugin和maven-dependency-plugin插件打包

所有 Maven 插件通过一个 `<configuration>` 元素公布了其配置，在本例中，`maven-jar-plugin` 修改它的 `archive` 属性，特别是存档文件的 `manifest` 属性，它控制 MANIFEST.MF 文件的内容。包括 3 个元素：

- `addClassPath`：将该元素设置为 *true* 告知 `maven-jar-plugin` 添加一个 `Class-Path` 元素到 MANIFEST.MF 文件，以及在 `Class-Path` 元素中包括所有依赖项。

- `classpathPrefix`：如果您计划在同一目录下包含有您的所有依赖项，作为您将构建的 JAR，那么您可以忽略它；否则使用 `classpathPrefix` 来指定所有依赖 JAR 文件的前缀。`classpathPrefix` 指出，相对存档文件，所有的依赖项应该位于 “`lib`” 文件夹。

- `mainClass`：当用户使用 `lib` 命令执行 JAR 文件时，使用该元素定义将要执行的类名。

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-jar-plugin</artifactId>
  <version>2.3</version>
  <configuration>
    <finalName>${project.artifactId}</finalName>
    <archive>
      <index>1</index>
      <manifest>
        <addClasspath>true</addClasspath>
        <classpathPrefix>lib/</classpathPrefix>
        <mainClass>com.maikou.Application</mainClass>
      </manifest>
      <manifestEntries>
        <mode>development</mode>
        <Class-Path>conf/</Class-Path>
        <version>${project.version}</version>
      </manifestEntries>
    </archive>
  </configuration>
</plugin>

```

如果您发现Maven Archiver的其他配置选项不足以处理清单，您可以添加自己的条目。 这是通过<manifestEntries>配置元素完成的。比如maven生成的MANIFEST.MF中的Class-Path的内容缺少一些内容，比如当前执行目录(.) 或者 配置文件夹(conf)，那么可以通过上面manifestEntries的方式增加进来，增加后的效果：

```makefile
Main-Class: com.maikou.Application
Class-Path: conf/ lib/spring-boot-starter-web-1.5.4.RELEASE.jar lib/sp
 ring-boot-starter-1.5.4.RELEASE.jar lib/spring-boot-1.5.4.RELEASE.jar
  lib/spring-boot-starter-logging-1.5.4.RELEASE.jar
```

当您使用上面这 3 个元素配置好了 MANIFEST.MF 文件之后，下一步是将所有的依赖项复制到 `lib` 文件夹。为此，使用 `maven-dependency-plugin`

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-dependency-plugin</artifactId>
  <version>2.10</version>
  <executions>
    <execution>
      <id>copy-dependencies</id>
      <phase>package</phase>
      <goals>
        <goal>copy-dependencies</goal>
      </goals>
      <configuration>
        <outputDirectory>${project.build.directory}/lib</outputDirectory>
      </configuration>
    </execution>
  </executions>
</plugin>
```

`maven-dependency-plugin` 有一个 `copy-dependencies`，目标是将您的依赖项复制到您所选择的目录。本例中，我将依赖项复制到 `build` 目录下的 `lib` 目录（`project-home/target/lib`）。

配置完成后，通过mvn package指令打包，会在target目录下生成jar包，并将依赖包拷贝到target/lib目录下.

指定了Main-Class，有了依赖包，那么就可以直接通过java -jar xxx.jar运行jar包。

这种方式生成jar包有个缺点，就是生成的jar包太多不便于管理，下面两种方式只生成一个jar文件，包含项目本身的代码、资源以及所有的依赖包。


### 方法二: 使用maven-jar-plugin和maven-assembly-plugin插件打包

<http://maven.apache.org/plugins/maven-assembly-plugin/>

maven-assembly-plugin的用途是制作项目分发包，该分发包可能包含了项目的可执行文件、源代码、readme、平台脚本等等。maven-assembly-plugin支持各种主流的格式如zip、tar.gz、jar和war等，具体打包哪些文件是高度可控的，例如用户可以按文件级别的粒度、文件集级别的粒度、模块级别的粒度、以及依赖级别的粒度控制打包，此外，包含和排除配置也是支持的。maven-assembly-plugin要求用户使用一个名为`assembly.xml`的元数据文件来表述打包，它的single目标可以直接在命令行调用，也可以被绑定至生命周期。

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-assembly-plugin</artifactId>
  <version>2.3</version>
  <configuration>
    <appendAssemblyId>false</appendAssemblyId>
    <finalName>${project.artifactId}-${project.version}</finalName>
    <descriptors>
      <descriptor>src/main/resources/assembly.xml</descriptor>
    </descriptors>
  </configuration>
  <executions>
    <execution>
      <id>copy-scripts</id>
      <phase>package</phase>
      <goals>
        <goal>single</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

assembly.xml配置如下:

```xml
<assembly>
    <id>bin</id>
    <formats>
        <format>zip</format>
    </formats>

    <dependencySets>
        <dependencySet>
            <useProjectArtifact>true</useProjectArtifact>
            <outputDirectory>lib</outputDirectory>
            <unpack>false</unpack>
        </dependencySet>
    </dependencySets>

    <fileSets>
        <fileSet>
            <directory>${project.build.directory}</directory>
            <outputDirectory></outputDirectory>
            <includes>
                <include>*.jar</include>
            </includes>
            <fileMode>0755</fileMode>
        </fileSet>
        <fileSet>
            <directory>src/main/resources/</directory>
            <outputDirectory>conf/</outputDirectory>
            <includes>
                <include>application.properties</include>
            </includes>
            <fileMode>0755</fileMode>
        </fileSet>
    </fileSets>
</assembly>
```



麦口说: 初心易得, 始终难守