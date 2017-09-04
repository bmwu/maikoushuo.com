---
title: JAVA集合框架之Map
date: 2017-08-29 23:16:56
tags: JAVA集合框架
---

![image](https://github.com/bmwu/bmwu.github.io/blob/master/images/JAVA%E9%9B%86%E5%90%88%E5%9B%BE%E8%B0%B1-Map.png?raw=true)

Java的集合类主要由2个接口类派生而出: Collection和Map. 今天就来讲讲Map. 由于上述是脑图, 简单说明下, 主要分三类, 一是实现类, 比如TreeMap, EnumMap, HashMap, LinkedHashMap, IdentityHashMap和WeakHashMap; 二是接口类, 比如SortedMap, NavigableMap; 三是抽象类, 比如AbstractMap. 

下面来说说抽象类AbstractMap, 如果要自己去实现一个个集合类(比如HashMap, TreeMap等), 去实现那些抽象的接口就比较麻烦, 工作量很大不说, 还有很多重复的代码. 抽象类会是个不错的选择, 我们可以在抽象类里面实现一些通用的方法实现. 这样就可以按照自己的实际情况重写一些方法或者添加自己的实现.

接下来以Put方法为例, 谈谈HashMap和LinkedHashMap: 总所周知, map中的key是一个set集合, 当我们把元素put进map, 输出map集合的时候里面的key元素并不是按照我们put进去的顺利来输出的. 这时候大多数人肯定想到了LinkedHashMap, 因为它是在HashMap的基础上维护了一个链表, 保持put的顺利; 而且迭代的时候, 也是按照put的顺序迭代. 



现在大家来看下具体的实现, 

首先Map.java的接口类的实现

```java
V put(K key, V value);
```

还有抽象类AbstractMap.java

```java
/**
 * {@inheritDoc}
 *
 * @implSpec
 * This implementation always throws an
 * <tt>UnsupportedOperationException</tt>.
 *
 * @throws UnsupportedOperationException {@inheritDoc}
 * @throws ClassCastException            {@inheritDoc}
 * @throws NullPointerException          {@inheritDoc}
 * @throws IllegalArgumentException      {@inheritDoc}
*/
public V put(K key, V value) {
  throw new UnsupportedOperationException();
}
```

还有HashMap.java

```java
public V put(K key, V value) {
	return putVal(hash(key), key, value, false, true);
}
```

LinkedHashMap.java里面是没有put方法的, 因为它用的也是HaspMap.java里面的. 那为什么会有不一样的效果. 我们来看下putVal的实现:

```java
 final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                boolean evict) {
   Node<K,V>[] tab; Node<K,V> p; int n, i;
   if ((tab = table) == null || (n = tab.length) == 0)
     n = (tab = resize()).length;
   if ((p = tab[i = (n - 1) & hash]) == null)
     tab[i] = newNode(hash, key, value, null);
   else {
     Node<K,V> e; K k;
     if (p.hash == hash &&
         ((k = p.key) == key || (key != null && key.equals(k))))
       e = p;
     else if (p instanceof TreeNode)
       e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
     else {
       for (int binCount = 0; ; ++binCount) {
         if ((e = p.next) == null) {
           p.next = newNode(hash, key, value, null);
           if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
             treeifyBin(tab, hash);
           break;
         }
         if (e.hash == hash &&
             ((k = e.key) == key || (key != null && key.equals(k))))
           break;
         p = e;
       }
     }
     if (e != null) { // existing mapping for key
       V oldValue = e.value;
       if (!onlyIfAbsent || oldValue == null)
         e.value = value;
       afterNodeAccess(e);
       return oldValue;
     }
   }
   ++modCount;
   if (++size > threshold)
     resize();
   afterNodeInsertion(evict);
   return null;
 }
```

大家应该注意到了`newNode(hash, key, value, null)`, 对, 因为LinkedHashMap.java里面重写了这个方法, 维护了一个简单的链表.

HashMap.java

```java
// Create a regular (non-tree) node
Node<K,V> newNode(int hash, K key, V value, Node<K,V> next) {
  return new Node<>(hash, key, value, next);
}
```

LinkedHashMap.java

```java
// link at the end of list
private void linkNodeLast(LinkedHashMap.Entry<K,V> p) {
  LinkedHashMap.Entry<K,V> last = tail;
  tail = p;
  if (last == null)
    head = p;
  else {
    p.before = last;
    last.after = p;
  }
}

Node<K,V> newNode(int hash, K key, V value, Node<K,V> e) {
  LinkedHashMap.Entry<K,V> p =
    new LinkedHashMap.Entry<K,V>(hash, key, value, e);
  linkNodeLast(p);
  return p;
}
```



未完待续...