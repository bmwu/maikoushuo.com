---
title: JAVA集合框架
date: 2017-08-28 09:50:59
tags: JAVA集合框架
---

![image](https://github.com/bmwu/bmwu.github.io/blob/master/images/JAVA%E9%9B%86%E5%90%88%E5%9B%BE%E8%B0%B1.jpeg?raw=true)

Java的集合类主要由两个接口派生而出：Collection和Map，Collection和Map是Java集合框架的根接口，这两个接口又包含了一些接口或实现类。

- List和Set接口是Collection接口派生的两个子接口，Queue是Java提供的队列实现，类似于List。


- Map实现类用于保存具有映射关系的数据（key-value）。

List、Set和Map可以看做集合的三大类。

- List集合是有序集合，集合中的元素可以重复，访问集合中的元素可以根据元素的索引来访问。


- Set集合是无序集合，集合中的元素不可以重复，访问集合中的元素只能根据元素本身来访问（也是不能集合里元素不允许重复的原因）。

Map集合中保存Key-value对形式的元素，访问时只能根据每项元素的key来访问其value。

接下来我会陆续对JAVA的集合框架进行探究.