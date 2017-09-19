---
title: 'IAAS, SAAS, PAAS'
date: 2017-09-18 10:37:37
tags: 云计算
---



**原文**是**Pizza‐as‐a‐Service: a detailed view**，用来类比Cloud Service Models。出处来自于Data Sovereignty and the Cloud – A Board and Executive Officers Guide University of NSW Faculty of Law, July 2013。

来源地址：[如何理解云计算？很简单，就像吃货想吃披萨了...](http://www.chinacloud.cn/show.aspx?id=19758&cid=18)



云计算的三个分层，基础设施在最下端，平台在中间，软件在顶端，分别是分别是**Infrastructure-as-a-Service(IaaS)**，**Platform-as-a-Service(PaaS)**，**Software-as-a-Service(SaaS)**，别的一些“软”的层可以在这些层上面添加. 
而你的公司什么都有，现在所处的状态叫本地部署**(On-Premises)**，就像在自己家做pizza一样。 
![image](http://maikoushuo.oss-cn-beijing.aliyuncs.com/%E4%BA%91%E8%AE%A1%E7%AE%97.png)

几年前如果你想在办公室或者公司的网站上运行一些企业应用，你需要去买服务器，或者别的高昂的硬件来控制本地应用，让你的业务运行起来，这就叫本地部署。
假如你家BOSS突然有一天想明白了，只是为了吃上pizza，为什么非要自己做呢?于是，准备考虑一家云服务供应商，这个云服务供应商能提供哪些服务呢?其所能提供的云服务也就是云计算的三个分层：IaaS、PaaS和SaaS，就像pizza店提供三种服务：买成品回家做、外卖和到披萨店吃。
![image](http://maikoushuo.oss-cn-beijing.aliyuncs.com/%E4%BA%91%E8%AE%A1%E7%AE%971.png)



## 现在我们来谈谈具体细节。

### IaaS: Infrastructure-as-a-Service(基础设施即服务)

有了IaaS，你可以将硬件外包到别的地方去。IaaS公司会提供场外服务器，存储和网络硬件，你可以租用。节省了维护成本和办公场地，公司可以在任何时候利用这些硬件来运行其应用。一些大的IaaS公司包括Amazon, Microsoft, VMWare, Rackspace和Red Hat.不过这些公司又都有自己的专长，比如Amazon和微软给你提供的不只是IaaS，他们还会将其计算能力出租给你来host你的网站。

### PaaS: Platform-as-a-Service(平台即服务)

第二层就是所谓的PaaS，某些时候也叫做中间件。你公司所有的开发都可以在这一层进行，节省了时间和资源。PaaS公司在网上提供各种开发和分发应用的解决方案，比如虚拟服务器和操作系统。这节省了你在硬件上的费用，也让分散的工作室之间的合作变得更加容易。网页应用管理，应用设计，应用虚拟主机，存储，安全以及应用开发协作工具等。一些大的PaaS提供者有Google App Engine,Microsoft Azure，Force.com,Heroku，Engine Yard。最近兴起的公司有AppFog,Mendix和Standing Cloud.

### SaaS: Software-as-a-Service(软件即服务)

第三层也就是所谓SaaS。这一层是和你的生活每天接触的一层，大多是通过网页浏览器来接入。任何一个远程服务器上的应用都可以通过网络来运行，就是SaaS了。你消费的服务完全是从网页如Netflix,MOG,Google Apps,Box.net,Dropbox或者苹果的iCloud那里进入这些分类。尽管这些网页服务是用作商务和娱乐或者两者都有，但这也算是云技术的一部分。一些用作商务的SaaS应用包括Citrix的Go To Meeting，Cisco的WebEx，Salesforce的CRM，ADP，Workday和SuccessFactors。