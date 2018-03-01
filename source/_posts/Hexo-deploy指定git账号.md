---
title: Hexo deploy指定git账号
date: 2018-03-01 10:18:18
tags: Hexo
---

Q：hexo deploy默认使用全局的git user.name user.email，那么请问能否hexo deploy 时带上临时指定的git账户 或者 在_config.yml指定git账户 使得push时与全局git账户区分开?

A: 可以在_config.yml里面设置

```yaml
# You can use this:
deploy:
  type: git
  repo: <repository url>
  branch: [branch]
  message: [message]
  name: [git user]
  email: [git email]
  extend_dirs: [extend directory]
```

1. 如果`.deploy_git`目录已经生成的情况下，需要删掉整个目录，再执行一次`hexo d`才行
2. 原有所有的git 提交记录全部没有了，会生产一个磨默认的"First commit"和你hexo d的那个。