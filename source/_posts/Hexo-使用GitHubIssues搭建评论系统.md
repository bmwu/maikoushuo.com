---
title: Hexo-使用 GitHub Issues 搭建评论系统
date: 2019-05-22 15:32:59
tags: Hexo
---

gitment的介绍，直接 https://imsun.net/posts/gitment-introduction/
我就简单描述下我遇到的问题

### Gitment配置信息
我使用的是next主题，_config.yml下面配置, 需要注意的是
1. owner是 https://github.com/bmwu 里面的bmwu
2. repo是 https://github.com/bmwu/bmwu.github.io 里面的 bmwu.github.io
3. 所有的变量都需要加 ''，不要comments加载不出来的

```yml
gitment:
  # Switch
  enable: true
  # Your Github ID (Github username):
  owner:
  # The repo to store comments:
  repo: 
  # Your client ID:
  client_id: ''
  # Your client secret:
  client_secret: ''
```

### gitment.swig
直接上文件，需要注意的是id可以配置为 page.title；id不配置会报"validation error"；id设置为location.href，是强指定了，会出现所有文章都是相同的comments

```javascript
{% if theme.gitment.enable and theme.gitment.client_id and theme.gitment.client_secret %}
    <div id="container_gitment"></div>
    <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
    <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
    <script>
      var gitment = new Gitment({
        id: '{{ page.title }}',
        owner: '{{ theme.gitment.github_id }}',
        repo: '{{ theme.gitment.repo }}',
        oauth: {
          client_id: '{{ theme.gitment.client_id }}',
          client_secret: '{{ theme.gitment.client_secret }}',
        }
      });
      gitment.render('container_gitment');
    </script>
{% endif %}
```

### 初始化评论
现在确实好像需要手动去初始化， 假如你id配置了page.title，当里面存在'或者/时，好像不会出现comments，所以title的命名需要注意下


### [object ProgressEvent]
https://github.com/imsun/gitment/issues/170
作者提供给使用者的加 CORS header 的服务已经停了，如果想继续使用我们就得自己搭一个这样的服务；
单纯把"https://gh-oauth.imsun.net"改为请求 github 认证的接口'https://github.com/login/oauth/access_token'是不行的，存在跨域问题，比较懒，直接用的@jjeejj的
```text
修改文件themes\next\layout_third-party\comments\gitment.swig：
https://imsun.github.io/gitment/style/default.css 修改为 https://www.wenjunjiang.win/css/gitment.css
https://imsun.github.io/gitment/dist/gitment.browser.js 修改为 https://www.wenjunjiang.win/js/gitment.js
```
