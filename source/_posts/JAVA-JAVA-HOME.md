---
title: JAVA JAVA_HOME
date: 2019-05-23 15:13:11
tags: Java
---

### 查看JAVA版本

打开Mac电脑，查看JAVA版本，打开终端Terminal，通过命令行查看java版本：

```shell
$ java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
```

发现已安装Java运行环境。如果你的系统已经安装成功JDK，通过java -version就可以看到相应的jdk版本。如果你的电脑还没有安装JDK的话，可以到Oracle官网下载jdk。

### 查看JAVA安装路径

```shell
$ which java
/usr/bin/java
$ whereis java
/usr/bin/java
```

通过`ls -l  /usr/bin/java` 不能找到真实的安装路径

```text
Many Java applications need to know the location of a $JAVA_HOME directory. The $JAVA_HOME on Mac OS X should be found using the /usr/libexec/java_home command line tool on Mac OS X 10.5 or later. On older Mac OS X versions where the tool does not exist, use the fixed path "/Library/Java/Home". The /usr/libexec/java_home tool dynamically finds the top Java version specified in Java Preferences for the current user. This path allows access to the bin subdirectory where command line tools such as java, javac, etc. exist as on other platforms. The tool /usr/libexec/java_home allows you to specify a particular CPU architecture and Java platform version when locating a $JAVA_HOME.
Another advantage of dynamically finding this path, as opposed to hardcoding the fixed endpoint, is that it is updated when a new version of Java is downloaded via Software Update or installed with a newer version of Mac OS X. For this reason, it is important that developers do not install files in the JDKs inside of /System, since the changes will be lost with subsequent updates by newer versions of Java.
To obtain the path to the currently executing $JAVA_HOME, use the java.home System property.
```

参照苹果的文件文档说明
```shell
$ /usr/libexec/java_home -V
Matching Java Virtual Machines (1):
    1.8.0_60, x86_64:	"Java SE 8"	/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home

/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
```

### 设置JAVA_HOME环境变量

cd回到用户目录，再列出当前的所有文件，可以见到当前系统的.开头的所有文件。
```shell
$ vi .bash_profile
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH
export CLASS_PATH=$JAVA_HOME/lib
$ source .bash_profile
```

到这个步骤，我们就已经配置好了全局的java的path和classpath环境变量。
```shell
$ echo $JAVA_HOME
$ echo $PATH
```
