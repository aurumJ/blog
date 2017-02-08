---
title: AndroidEventBus 使用后感受
date: 2017-02-08 14:50:07
tags:
  - Android
  - AndroidEventBus
  - 原创
---
本来是写了一些关于 [AndroidEventBus](https://github.com/hehonghui/AndroidEventBus) 源码的阅读记录,也在接触使用本工具,但是使用的次数多了之后问题就慢慢展现出来了,这里总结记录一下我发现的 [AndroidEventBus](https://github.com/hehonghui/AndroidEventBus)  的优缺点
### 优点
  - 大幅度降低各个组件和线程间的通信难度
  - 使用方式简单方便
  - 降低程序耦合性

### 缺点
  - 过多使用会导致程序混乱
  - 增加程序维护难度

### 总结
任何工具都是具有两面性的,这个工具也不例外,过犹不及, AndroidEventBus 固然能大幅度降低通信难度,但是其带来的副作用也是相当大的,甚至让程序变得相当难以维护.

就如同 goto 语句一样, AndroidEventBus 可以让你有最大的通信自由度,然而也会让你的通讯变得混乱未知.

我也是在过度的使用此工具之后才发现了这个致命的问题在此记录一下,希望警示自己以后不要过分的依赖一个工具,使用工具要适度.
