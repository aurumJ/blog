---
title: 设计模式学习记录:观察者模式
date: 2017-07-05 14:03:57
tags:
  - 设计模式
  - 原创
thumbnail: /img/blog/guanchazhe.jpg
---

> 这一阵子因为项目进度原因一直没有时间学习(其实也都是接口,只是懒罢了),之前也研究过这些设计模式,但总是不得其法,每次都是朦朦胧胧看似懂了,但是到了真正应用起来总是不能得心应手,这次想下下苦工(相比之前),记录下自己学习的过程,希望自己能在这个过程中获得更多收货.

### 前言
既然要研究设计模式,那么就要清楚设计模式是什么,设计模式是一种为了解决在软件开发中反复出现的各种问题的一种解决方案.本学习的观察者模式就是其中的一种.

### 定义
> 观察者模式: 在这个模式中,一个目标对象管理所有依赖它的观察者对象,并且在本身状态改变时主动发出通知

### UML 类图
> 图片引自维基百科

![UML 类图](http://olihtbm3u.bkt.clouddn.com/image/07/05/Observer-pattern-class-diagram.png)


### 个人理解
本人沉迷与游戏,特别是射击类游戏,那么这次就用 CSGO 中的一个设定来描述一下个人对观察者模式的理解.

首先所有的 CT(反恐精英) 为观察者而 C4 作为被观察者,所有的 CT 时刻监听这 C4 的状态(是否被安装), 按照 CSGO 中的设定一旦 T(恐怖分子) 安装了 C4 后会对所有的 CT 发出通知(C4 已安装之类的), 这时所有的 CT 就会知道 C4 已经被安装,这就是一个观察者模式.

### 代码演示
> 以下所有代码片段为 Kotiln 代码

被观察者接口
``` Kotiln
/**
 * 被观察者接口
 * Created by Jin on 2017/7/5.
 */
interface Observable {

    //登记观察者
    fun registerObserver(o: Observer)

    //删除观察者
    fun removeObserver(o: Observer)

    //触发刷新
    fun notifyObservers()
}

```
观察者接口
```Kotiln
/**
 * 观察者接口
 * Created by Jin on 2017/7/5.
 */
interface Observer {
    fun update()
}
```

C4 对象

```Kotiln
/**
 * C4 被观察者
 * Created by Jin on 2017/7/5.
 */
class C4 : Observable {
    //观察者列表
    val observers = ArrayList<Observer>()

    //登记观察者
    override fun registerObserver(o: Observer) {
        observers.add(o)
    }

    //移除观察者
    override fun removeObserver(o: Observer) {
        if (observers.contains(o)) {
            observers.remove(o)
        }
    }

    //通知观察者
    override fun notifyObservers() {
        observers.forEach { observer: Observer -> observer.update() }
    }
}
```

CT 对象

```Kotlin
/**
 * Created by Jin on 2017/7/5.
 */
class CT(var name: String) : Observer {
    override fun update() {
        Log.i("Jin", "$name 得到了 C4 已经安装的消息")
    }
}
```

MainActivity

```Kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val c4 = C4()
        val ct1 = CT("CT 1 号")
        val ct2 = CT("CT 2 号")
        val ct3 = CT("CT 3 号")
        val ct4 = CT("CT 4 号")
        val ct5 = CT("CT 5 号")
        c4.registerObserver(ct1)
        c4.registerObserver(ct2)
        c4.registerObserver(ct3)
        c4.registerObserver(ct4)
        c4.registerObserver(ct5)
        c4.notifyObservers()
    }
}
```

以下为一些参考资料,感谢这些分享知识的人
>[维基百科 -- 观察者模式](https://zh.wikipedia.org/wiki/%E8%A7%82%E5%AF%9F%E8%80%85%E6%A8%A1%E5%BC%8F)

>[设计模式 -- 观察者模式 (Java)](http://www.jianshu.com/p/109eb51accb9)

>[学习、探究 Java 设计模式 -- 观察者模式](http://blog.csdn.net/a553181867/article/details/52454178)
