---
title: AndroidUseKotlin
date: 2017-03-30 14:22:27
tags:
  - Android
  - Kotlin
  - 原创
  - 学习笔记
thumbnail: /img/blog/screen-shot.png
---

### 起因
最近测试项目由于各种原因需求进度与各种开发需要降低所以较为清闲,公司的技术高手推荐去研究一些可以用于替换 Java 来开发 Android 软件的语言,高手推荐了 [Groovy](!https://github.com/groovy/groovy-android-gradle-plugin) 试着配置了一下 Groovy 的环境(可是失败了),但是我在查找资料的时候发现了一个好东西那就是 [Kotlin](!https://github.com/JetBrains/kotlin),试了一下发现真的不错,和 JAVA 的兼用性和 IDE 的适配性相当之强,关于配置也十分的简单明了,不愧是 JetBrains 这群高手开发出来了.

### Kotlin 简介
按照习惯先粘贴一下关于 Kotlin 的介绍.

> Kotlin 是一种在 Java 虚拟机上执行的静态型别编程语言，它也可以被编译成为 JavaScript 源代码。它主要是由俄罗斯圣彼得堡的 JetBrains 开发团队所发展出来的编程语言，其名称来自于圣彼得堡附近的科特林岛。 在 2012 年一月的著名期刊Dr. Dobb's Journal中 Kotlin 被认为是该月份最佳语言。虽然跟 Java 语法并不相容，但 Kotlin 被设计成可以和 Java 程式码相互运作，并可以重复使用如 Java 集合框架等的现有 Java 类别库。                 -- 引自维基百科

### AS 中 kotlin 配置
 - 安装 Kotlin 插件
  ![安装插件](http://olihtbm3u.bkt.clouddn.com/image/03/30/plugins_install.jpg)

 - 配置 Project 的 build.gradle

 ```

  buildscript {
    ext.kotlin_version = '1.1.1'
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:2.3.0'

        classpath "org.jetbrains.kotlin:kotlin-android-extensions:$kotlin_version"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
 }
 allprojects {
     repositories {
         jcenter()
     }
 }

 task clean(type: Delete) {
     delete rootProject.buildDir
 }
 ```
 - 配置 Module 的 build.gradle

 ```

 apply plugin: 'kotlin-android'
 apply plugin: 'kotlin-android-extensions'
 dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    androidTestCompile('com.android.support.test.espresso:espresso-core:2.2.2', {
        exclude group: 'com.android.support', module: 'support-annotations'
    })
    compile 'com.android.support:appcompat-v7:25.1.0'
    compile 'com.android.support.constraint:constraint-layout:1.0.1'
    compile "org.jetbrains.kotlin:kotlin-stdlib-jre7:$kotlin_version" // For appcompat-v7 bindings
    testCompile 'junit:junit:4.12'
}
 ```

 - 配合 anko 使用

 ```
    compile 'org.jetbrains.anko:anko-sdk15:0.8.2' // sdk19, sdk21, sdk23 are also available
    compile 'org.jetbrains.anko:anko-support-v4:0.8.2' // In case you need support-v4 bindings
    compile 'org.jetbrains.anko:anko-appcompat-v7:0.8.2'
 ```

 - 创建一个 Kotlin Activity
 ![创建 Kotlin](http://olihtbm3u.bkt.clouddn.com/image/03/30/new_kotlin.png)

### 实例
还是选用了是分常用的 ListView 作为展示实例,其中包括了 类的继承 Adapter 的基础实现 控件的使用,当然由于我使用时间也不长,所以用的还是不能得心应手,里面还是很多地方能够以更优秀的形式展示出来的.

![Demo](http://olihtbm3u.bkt.clouddn.com/image/03/30/demo.png)

主要代码如下

BaseActivity.kt
```
abstract class BaseActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initUtils()
        setContentView(activityLayoutId())
        initView()
        initData()

    }

    open fun initView() {

    }

    open fun initUtils() {

    }

    open fun initData() {

    }

    open abstract fun activityLayoutId(): Int
}
```

MainActivity.kt
```
class MainActivity : BaseActivity() {
    override fun activityLayoutId(): Int = R.layout.activity_main
    var strList: ArrayList<String> = ArrayList()
    override fun initData() {
        super.initData()
        strList.add("Java")
        strList.add("Go")
        strList.add("Kotlin")
        strList.add("Groovy")
        (listView.adapter as BaseAdapter).notifyDataSetChanged()
    }

    override fun initView() {
        super.initView()
        listView.adapter = TestAdapter(strList, this@MainActivity)
    }

    class TestAdapter(var testList: ArrayList<String>, var context: Context) : BaseAdapter() {
        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
            val holder: TestViewHolder
            val v: View
            if (convertView == null) {
                v = View.inflate(context, R.layout.item_sim, null)
                holder = TestViewHolder(v)
                v.tag = holder
            } else {
                v = convertView
                holder = v.tag as TestViewHolder
            }
            holder.strText.text = testList[position]
            return v

        }

        override fun getItem(position: Int): Any = testList[position]

        override fun getItemId(position: Int): Long = position.toLong()

        override fun getCount(): Int = testList.size

        class TestViewHolder(v: View) {
            var strText: TextView = v.findViewById(R.id.text_sim) as TextView
        }
    }
}
```

### 总结
Kotlin 是一个十分适合替换 Java 的语言,它甚至可以和 Java 混合使用,这就相当于你可以在你任何成熟的使用 Java 的项目中无缝切换使用 Kotlin 当你遇到了不熟悉的地方时,可以随时切换回 Java 而不用担心遇到技术问题.

以下为一些参考资料,感谢这些分享知识的人
> [Kotlin 中文文档](http://www.liying-cn.net/kotlin/docs/reference/basic-syntax.html)

> [Kotlin ，一种新的书写 android 的语言](http://blog.csdn.net/yianemail/article/details/52314600)
