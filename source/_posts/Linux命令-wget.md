---
title: 'Linux命令: wget'
date: 2017-09-11 20:15:44
tags: Linux命令
---

`wget命令`用来从指定的URL下载文件。wget非常稳定，它在带宽很窄的情况下和不稳定网络中有很强的适应性，如果是由于网络的原因下载失败，wget会不断的尝试，直到整个文件下载完毕。如果是服务器打断下载过程，它会再次联到服务器上从停止的地方继续下载。这对从那些限定了链接时间的服务器上下载大文件非常有用。

##### 语法

`wget(选项)(参数)`

##### 使用wget下载单个文件

`wget http://www.linuxde.net/testfile.zip`

##### 测试下载链接

当你打算进行定时下载，你应该在预定时间测试下载链接是否有效。我们可以增加`—spider`参数进行检查。

`wget --spider URL`

如果下载链接正确，将会显示

```
Spider mode enabled. Check if remote file exists. HTTP request sent, awaiting response... 200 OK Length: unspecified [text/html] Remote file exists and could contain further links, but recursion is disabled -- not retrieving.
```

##### 编译安装

```shell
tar zxvf wget-1.9.1.tar.gz
cd wget-1.9.1
./configure
make
make install
```

