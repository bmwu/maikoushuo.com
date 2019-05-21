---
title: Hexo first post
date: 2016-11-02 16:20:07
tags: Hexo
---

This is my first post using hexo

#### first title 

##### a first subtitle

``` bash 
$ hexo new "my new post"
```

##### second title

========================================================

#### 我遇到的问题

##### 更改了_config.yml 里面的一些配置，刷新页面怎么都没有更新

解决方法: 保存文件, 重启了2次server $ hexo server, 才更新

##### git 多账户配置 由于我丢弃了之前的git账号并新申请了个 再加上公司的账号， $hexo depoly 不成功(user还是之前的那个)

配置信息的时候一直显示的是我之前的github user，我尝试了 [link1](http://www.imooc.com/article/7419)，[link2](https://segmentfault.com/a/1190000002994742) 发现还是不行，在hexo deploy的时候还是指向原来的github user.

解决方法: 苦笑，因为之前的账号就不用，索性全部配置过，从全局 "$ git init“ 开始, enter file in which to save the key 的时候指定了github_rsa(之前是保留了这个key,重新创建了个新的)，我觉得应该不是这个问题，但反正之前账号不用了，索性就替换了。

[More Info](https://malekbenz.com/blog/2016/09/10/Create-Host-Blog-for-free-with-Hexo-Github)