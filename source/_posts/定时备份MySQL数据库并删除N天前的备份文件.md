---
title: 定时备份MySQL数据库并删除N天前的备份文件
date: 2017-09-14 17:30:04
tags: MySQL
---

目标: 定时备份MYSQL, 避免有所疏漏, 确保开发数据不被丢失. 利用crontab来定时执行备份文件，按日期对备份结果进行保存，达到备份的目的。

```shell
#创建备份文件夹
mkdir mysqldata
#编写运行脚本
vi bakmysql.sh
#为脚本添加执行权限
chmod +x /usr/sbin/bakmysql.sh
#修改/etc/crontab
sodu vi /etc/crontab 
#在最后一行中加入： 
00 3 * * * root /usr/sbin/bakmysql.sh
表示每天3点00分执行备份
 
#重启crontab
sudo /usr/sbin/crond restart
#重启不成功处理
ps aux | grep $(cat /var/run/crond.pid)
sudo rm -f /var/run/crond.pid
#恢复数据备份文件：
gunzip maikou2017010101.sql.gz
mysql -u{user} -p{password} {dataname} < maikou2017010101.sql
```

#### 代码：

```shell
#!/bin/bash
# Name:bakmysql.sh
# This is a ShellScript For Auto DB Backup and Delete old Backup
#
backupdir=/home/deployer/bak/mysqldata
time=` date +%Y%m%d%H `
/usr/bin/mysqldump -u{user} -p{password} {databse} | gzip > $backupdir/{name}$time.sql.gz
#
find $backupdir -name "{name}_*.sql.gz" -type f -mtime +5 -exec rm {} \; > /dev/null 2>&1 
```

