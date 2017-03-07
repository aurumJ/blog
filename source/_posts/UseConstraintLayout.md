---
title: 学习使用 ConstraintLayout
date: 2017-03-07 10:15:07
tags:
  - Android
  - ConstraintLayout
  - 原创
thumbnail: /img/blog/three_buttons_working_as_expected.png
---

### 起因
每件事情都需要一个起因来引发,我觉得学习也同样需要,当你觉得一门技术你需要使用或值得你使用你就会去学习,这个需求就是一个起因.那么至此为什么要学习 ConstraintLayout 这个布局呢? 是因为我在昨天更新了一下 AndroidStudio 将其从 2.2 版本更新至 2.3 版本.也去看了一些 IDE 方面的改变,但是奈何技术水平所限一些东西没怎么看明白,但是我对 2.3 版本关于布局方面的更改还是有些兴趣的,当我新建了一个测试项目想要测试一下 2.3 版本又对布局方面做了哪些更改的时候我发现新项目默认的根布局不再是我所熟知的 RelativeLayout 而变为了 ConstraintLayout, 这证明以后 ConstraintLayout 会发展为一种趋势,甚至是比 RelativeLayout 更常用的一种布局,所以赶紧就去找一下各位大牛分享出来的技术文章学习一下

### ConstraintLayout(约束布局) 简介
在查阅了郭霖大大分享出来的文章 [最全面的 ConstraintLayout 教程](http://chuansong.me/n/1526028851022) 后发现原来 ConstraintLayout 早在 Android Studio 2.2 中就已经出现了(羞愧啊~)虽然是测试版,在我写这篇学习记录的时候 ConstraintLayout 已经更新了正式版本,添加以下依赖便可引入 1.0.1 版本
```
  compile 'com.android.support.constraint:constraint-layout:1.0.1'
```
_郭霖大大很厉害的,他的 <第一行代码> 我有买哦~_


### ConstraintLayout 学习总结
关于如何使用 ConstraintLayout ,下面的的几篇推荐文章已经进行了很好的说明,在我的学习记录中就不在重复的进行说明了.

试用了一下 ConstraintLayout 感觉这个约束布局相当的不错甚至可以说比 RelativeLayout 要强的很多,在没有使用过约束布局的之前大部分的布局其实是由 XML 实现的,可视化布局虽然很早就支持但是一直不是十分的理想,因为之前的布局需要大量的嵌套一层套一层,拖拽有可能会造成失误.而有了约束布局之后会大幅增加拖拽布局的使用次数,甚至是改变以往的编码布局的方式(这估计也是 Google 想看到的结果).

简单总结一下

优点:
  - 使布局变得更简单
  - 控件与控件之间相互约束,统一改变更方便
  - 大幅度减少嵌套布局的使用

缺点:
  - 如果页面布局控件较多,可能会造成对应关系混乱
  - 如果页面控件的约束关系设计不合理可能会牵一发而动全身
  - 使你的布局 XML 变得更加烦琐

以上只是试用了不到 1 天的简单总结并不能说明什么,如果以后再使用过程中有任何的发现在记录下来吧.



以下为个人推荐学习文章,感谢那些分享知识的人.
> [最全面的 ConstraintLayout 教程](http://chuansong.me/n/1526028851022)

> [官方提供的 Codelab 项目](https://codelabs.developers.google.com/codelabs/constraint-layout/index.html#0) (英文,可能需要自备梯子)

> [Constraint 代码实验室 -- 带你一步步理解使用 ConstraintLayout](http://quanqi.org/2016/05/20/code-labs-constraint-layout/)(上文的中文翻译搬运,感谢该作者)
