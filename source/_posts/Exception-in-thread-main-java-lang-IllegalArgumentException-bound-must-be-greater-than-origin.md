---
title: >-
  Exception in thread main java.lang.IllegalArgumentException: bound must be greater than origin
date: 2017-10-13 20:17:59
tags: Java
---



先认识下IllegalArgumentException, 它有3个messages, 我们遇到的正式BadRange.

```java
static final String BadBound = "bound must be positive";
static final String BadRange = "bound must be greater than origin";
static final String BadSize  = "size must be non-negative";
```



以nextLong为例, 正是因为origin>=bound, 才触发了此Exception

```java
/**
 * Returns a pseudorandom {@code long} value between the specified
 * origin (inclusive) and the specified bound (exclusive).
 *
 * @param origin the least value returned
 * @param bound the upper bound (exclusive)
 * @return a pseudorandom {@code long} value between the origin
 *         (inclusive) and the bound (exclusive)
 * @throws IllegalArgumentException if {@code origin} is greater than
 *         or equal to {@code bound}
 */
public long nextLong(long origin, long bound) {
    if (origin >= bound)
        throw new IllegalArgumentException(BadRange);
    return internalNextLong(origin, bound);
}
```

