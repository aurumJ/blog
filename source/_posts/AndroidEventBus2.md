---
title: Jin 的学习记录 AndroidEventBus 源码拜读记录(二)
date: 2017-02-07 17:15:32
tags:
    - Android
    - AndroidEventBus
    - 原创
---
## 事件接收函数注解类(Subscriber)
为什么要先从这个类开始读呢?因为这个事件注解类是我们在使用 [AndroidEventBus](https://github.com/hehonghui/AndroidEventBus) 的时候需要经常使用的类,也是对于像我这样的新手接触的较少的一个新东西,所以就优先从这个注解类开始阅读吧.
- 示例
使用 [AndroidEventBus](https://github.com/hehonghui/AndroidEventBus)的时候经常会使用如下代码:
```
@Subscriber(tag = "my_tag", mode = ThreadMode.ASYNC)
private void updateUserAsync(User user) {   
    Log.e("Jin", user.getName() + ", thread name = " + Thread.currentThread().getName());
}
```
其中的
>@Subscriber(tag = "my_tag", mode = ThreadMode.ASYNC)

就是这个注解类在发挥着重要的作用
- 代码分析
Subscriber 类中的代码量十分的少,但是如果对注解一无所知的时候就会看的一头雾水
可以看到这个注解类其实和接口的书写方式十分相似,甚至可以说注解就是一种另类的接口, Subscriber 注解类中只有两个方法 tag() 和 mode() 
1.tag() 此方法返回一个字符串 (事件标识符),默认值为 EventType.DEFAULT_TAG
2.mode()  此方法返回一个 ThreadMode 枚举(事件执行线程),默认值为ThreadMode.MAIN

## 事件执行线程枚举类 (ThreadMode)
这个类是个枚举类,在 Subscriber 类中使用过,基本作用:标识一个订阅者的事件执行在那个线程中
订阅事件可以执行在三种线程中:
1.MAIN 主线程
2.POST 发布线程,即你这个事件是在哪个线程发布的,就会在那个线程执行
3.ASYNC 子线程,事件将会执行在子线程中

> 关于注解我也只是一知半解,所以特意去看了一下:
[http://gityuan.com/2016/01/23/java-annotation/](http://gityuan.com/2016/01/23/java-annotation/) 
[http://blog.csdn.net/wzgiceman/article/details/53406248](http://blog.csdn.net/wzgiceman/article/details/53406248)
感谢这些分享者,知识需要分享,我也在为能分享出对大家有用的知识而努力.