---
title: JAVA 从一个 NullPointerException 探究自动装箱拆箱机制
date: 2017-10-17 15:46:39
tags: Java
---



今天遇到了一个 NullPointerException，触发的代码类似下面这样：

```java
public class HelloWorld {

    public static Double getRatio() {
        return null;
    }

    public static void main(String[] args) {
        Double ratio1 = getRatio();
        Double ratio2 = 1.0 - ratio1;
    }
}
```

当obj.getRatio() 返回null时, `Double ratio2 = 1.0 - ratio1;`实际上相当于调用 `Double ratio2 = 1.0 - null;`

## 抛出问题

运行时 `Double ratio2 = 1.0 - ratio1;`这一行抛出NullPointerException.

## 原因分析

ratio1是Double类型(虽然其实是null), 这里会经历一次从类型Double到基本数据类型double的自动拆箱过程.

用命令javac HelloWorld.java 将以上代码编译出HelloWorld.class文件

之后再用命令javap -c HelloWorld.class，将其字节码文件进行反汇编,:

```java
Compiled from "HelloWorld.java"
public class com.bmwu.HelloWorld {
  public com.bmwu.HelloWorld();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static java.lang.Double getRatio();
    Code:
       0: aconst_null
       1: areturn

  public static void main(java.lang.String[]);
    Code:
       0: invokestatic  #2                  // Method getRatio:()Ljava/lang/Double;
       3: astore_1
       4: dconst_1
       5: aload_1
       6: invokevirtual #3                  // Method java/lang/Double.doubleValue:()D
       9: dsub
      10: invokestatic  #4                  // Method java/lang/Double.valueOf:(D)Ljava/lang/Double;
      13: astore_2
      22: return
}
```

从以上字节码及对应的注释可以看出, `Double ratio2 = 1.0 - ratio1;`这一行被编译后等同于如下代码:

```java
Double var2 = Double.valueOf(1.0D - var1.doubleValue());
```

这一行看起来就是自动拆箱的过程了, 而ratio1的value为null,  var1,doubleValue() 会抛出NullPointerException.

## 自动装箱与拆箱

自动装箱与拆箱是Java1.5引入的新特性, 是一种语法糖.

在此之前, 我们要创建一个值为10的Integer对象, 只能写作

`Integer value = new Integer(10);`

而现在, 我们可以更方便地写为:

`Integer value = 10;`

## 定义与实现机制

**自动装箱**，是指从基本数据类型值到其对应的包装类对象的自动转换。比如 `Integer value = 10;`，是通过调用 Integer.valueOf 方法实现转换的。

**自动拆箱**，是指从包装类对象到其对应的基本数据类型值的自动转换。比如 `int primitive = value;`，是通过调用 Integer.intValue 方法实现转换的。

| 基本数据类型  | 包装类型      | 装箱方法                     | 拆箱方法                   |
| ------- | --------- | ------------------------ | ---------------------- |
| boolean | Boolean   | Boolean.valueOf(boolean) | Boolean.booleanValue() |
| byte    | Byte      | Byte.valueOf(byte)       | Byte.byteValue()       |
| char    | Character | Character.valueOf(char)  | Character.charValue()  |
| short   | Short     | Short.valueOf(short)     | Short.shortValue()     |
| int     | Integer   | Integer.valueOf(int)     | Integer.intValue()     |
| long    | Long      | Long.valueOf(long)       | Long.longValue()       |
| float   | Float     | Float.valueOf(float)     | Float.floatValue()     |
| double  | Double    | Double.valueOf(double)   | Double.doubleValue()   |

## 发生时机

自动装箱与拆箱主要发生在以下四种时机：

1. 赋值时；
2. 比较时；
3. 算术运算时；
4. 方法调用时。

## 常见应用场景

**Case 1:**

```
Integer value = 10; // 自动装箱（赋值时）

int primitive = value; // 自动拆箱（方法调用时）

```

**Case 2:**

```
Integer value = 1000;
// ...
if (value <= 1000) { // 自动拆箱（比较时）
    // ...
}

```

**Case 3:**

```
List<Integer> list = new ArrayList<>();
list.add(10); // 自动装箱（方法调用时）

int i = list.get(0); // 自动拆箱（赋值时）

```

*注：集合（Collections）里不能直接放入原始类型，集合只接收对象。*

**Case 4:**

```
ThreadLocal<Integer> local = new ThreadLocal<Integer>();
local.set(10); // 自动装箱（方法调用时）

int i = local.get(); // 自动拆箱（赋值时）

```

*注：ThreadLocal 不能存储基本数据类型，只接收引用类型。*

**Case 5:**

```
public void fun1(Integer value) {
    //
}

public void fun2(int value) {
    //
}

public void test() {
    fun1(10); // 自动装箱（方法调用时）

    Integer value = 10;
    fun2(value); // 自动拆箱（方法调用时）
}

```

**Case 6:**

```
Integer v1 = new Integer(10);
Integer v2 = new Integer(20);
int v3 = 30;

int sum = v1 + v2; // 自动拆箱（算术运算时）
sum = v1 + 30; // 自动拆箱（算术运算时）
```

## 相关知识点

#### 比较

除 `==` 以外，包装类对象与基本数据类型值的比较，包装类对象与包装类对象之间的比较，都是自动拆箱后对基本数据类型值进行比较，所以，**要注意这些类型间进行比较时自动拆箱可能引发的 NullPointerException**。

`==` 比较特殊，因为可以用于判断左右是否为同一对象，所以两个包装类对象之间 `==`，会用于判断是否为同一对象，而不会进行自动拆箱操作；包装类对象与基本数据类型值之间 `==`，会自动拆箱。

示例代码：

```
Integer v1 = new Integer(10);
Integer v2 = new Integer(20);

if (v1 < v2) { // 自动拆箱
    // ...
}

if (v1 == v2) { // 不拆箱
    // ...
}

if (v1 == 10) { // 自动拆箱
    // ...
}

```

## 缓存

Java 为整型值包装类 Byte、Character、Short、Integer、Long 设置了缓存，用于存储一定范围内的值，详细如下：

| 类型        | 缓存值范围           |
| --------- | --------------- |
| Byte      | -128 ~ 127      |
| Character | 0 ~ 127         |
| Short     | -128 ~ 127      |
| Integer   | -128 ~ 127（可配置） |
| Long      | -128 ~ 127      |

在一些情况下，比如自动装箱时，如果值在缓存值范围内，将不创建新对象，直接从缓存里取出对象返回，比如：

```
Integer v1 = 10;
Integer v2 = 10;
Integer v3 = new Integer(10);
Integer v4 = 128;
Integer v5 = 128;
Integer v6 = Integer.valueOf(10);

System.out.println(v1 == v2); // true
System.out.println(v1 == v3); // false
System.out.println(v4 == v5); // false
System.out.println(v1 == v6); // true

```

**缓存实现机制：**

这里使用了设计模式享元模式。

以 Short 类实现源码为例：

```
// ...
public final class Short extends Number implements Comparable<Short> {
    // ...
    private static class ShortCache {
        private ShortCache(){}

        static final Short cache[] = new Short[-(-128) + 127 + 1];

        static {
            for(int i = 0; i < cache.length; i++)
                cache[i] = new Short((short)(i - 128));
        }
    }

    // ...
    public static Short valueOf(short s) {
        final int offset = 128;
        int sAsInt = s;
        if (sAsInt >= -128 && sAsInt <= 127) { // must cache
            return ShortCache.cache[sAsInt + offset];
        }
        return new Short(s);
    }
    // ...
}

```

在第一次调用到 `Short.valueOf(short)` 方法时，将创建 -128 ~ 127 对应的 256 个对象缓存到堆内存里。

这种设计，在频繁用到这个范围内的值的时候效率较高，可以避免重复创建和回收对象，否则有可能闲置较多对象在内存中。

## 使用不当的情况

自动装箱和拆箱这种语法糖为我们写代码带来了简洁和便利，但如果使用不当，也有可能带来负面影响。

1. 性能的损耗

   ```
   Integer sum = 0;
   for (int i = 1000; i < 5000; i++) {
       // 1. 先对 sum 进行自动拆箱
       // 2. 加法
       // 3. 自动装箱赋值给 sum，无法命中缓存，会 new Integer(int)
       sum = sum + i;
   }

   ```

   在循环过程中会分别调用 4000 次 Integer.intValue() 和 Integer.valueOf(int)，并 new 4000 个 Integer 对象，而这些操作将 sum 的类型改为 int 即可避免，节约运行时间和空间，提升性能。

2. java.lang.NullPointerException

   尝试对一个值为 null 的包装类对象进行自动拆箱，就有可能造成 NullPointerException。

   比如：

   ```
   Integer v1 = null;
   int v2 = v1; // NullPointerException

   if (v1 > 10) { // NullPointerException
       // ...
   }

   int v3 = v1 + 10; // NullPointerException

   ```

   还有一种更隐蔽的情形

   ```
   public class Test {
       public static void main(String[] args) {
           long value = true ? null : 1; // NullPointerException
       }
   }

   ```

   这实际上还是对一个值为 null 的 Long 类型进行自动拆箱，反汇编代码：

   ```
   Compiled from "Test.java"
   public class Test {
     public Test();
       Code:
          0: aload_0
          1: invokespecial #1                  // Method java/lang/Object."<init>":()V
          4: return

     public static void main(java.lang.String[]);
       Code:
          0: aconst_null
          1: checkcast     #2                  // class java/lang/Long
          4: invokevirtual #3                  // Method java/lang/Long.longValue:()J
          7: lstore_1
          8: return
   }
   ```