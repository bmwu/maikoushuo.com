---
title: Spring Boot @EnableScheduling and @Scheduled Job Example
date: 2017-10-16 15:01:21
tags:
---



To **schedule job in spring boot** application to run periodically, spring boot provides `@EnableScheduling` and `@Scheduled`annotations. Lets learn to use them.

Let’s say you want to run job at every 10 seconds interval. You can achieve this job scheduling in below steps:

## 1) @EnableScheduling to Spring Boot Application class

Add `@EnableScheduling` annotation to your spring boot application class. `@EnableScheduling` is a Spring Context module annotation. It internally imports the `SchedulingConfiguration` via the `@Import(SchedulingConfiguration.class)` instruction



[Home](https://howtodoinjava.com/)  >  [Spring](https://howtodoinjava.com/category/spring/)  >  [Spring Boot](https://howtodoinjava.com/category/spring/spring-boot/)  >  Spring boot @EnableScheduling and @Scheduled Job Example

# Spring boot @EnableScheduling and @Scheduled Job Example

To **schedule job in spring boot** application to run periodically, spring boot provides `@EnableScheduling` and `@Scheduled`annotations. Lets learn to use them.

Let’s say you want to run job at every 10 seconds interval. You can achieve this job scheduling in below steps:

## 1 @EnableScheduling to Spring Boot Application class

Add `@EnableScheduling` annotation to your spring boot application class. `@EnableScheduling` is a Spring Context module annotation. It internally imports the `SchedulingConfiguration` via the `@Import(SchedulingConfiguration.class)` instruction

## 2 Add @Scheduled annotations

Now you can add `@Scheduled` annotations on methods which you want to scedule. Only condition is that methods should be **without arguments**.

`ScheduledAnnotationBeanPostProcessor` that will be created by the imported `SchedulingConfiguration` scans all declared beans for the presence of the `@Scheduled` annotations.

For every annotated method without arguments, the appropriate executor thread pool will be created. This thread pool will manage the scheduled invocation of the annotated method.

Now observe the output in console:

Happy Learning !!