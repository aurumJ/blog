---
title: Android 开发中的 XML 的使用
date: 2017-03-15 10:00:33
tags:
  - Android
  - XML
  - 原创
thumbnail: /img/blog/XML_img_02.jpg
---

### 起因
最近因为一个测试性的项目中有一个页面需要使用九宫格的形式来展示一些按钮(展示些按钮?有点怪怪的),按钮的功能相似都是向服务器发送一个请求,但是请求的参数根据每个按钮的功能不同而不同,最开始的一个实验性版本我直接将这些请求及参数写成对象存入列表,之后就可以轻松展示了.但是随着时间推移以及项目进度进展,某一群人一直在对这些按钮的参数及按钮位置一类的值进行改变,这样直接硬编码在代码中的那些对象列表也需要不停的调整相当的麻烦,作为一个程序员(水平不高的程序员依旧是程序员~)我相当的讨厌麻烦,所以就要做一个便捷且可操作性强的配置文件来解决这个问题,既然是配置文件那么就需要一种格式来书写这种配置文件,那么最简单的当然是 Json 和 XML 但是为了更加直观且可直接编辑的这个需要我选择了 XML.

### XML 简介
>可扩展标记语言（英语：Extensible Markup Language，简称：XML），是一种标记语言。标记指计算机所能理解的信息符号，通过此种标记，计算机之间可以处理包含各种信息的文章等。如何定义这些标记，既可以选择国际通用的标记语言，比如 HTML，也可以使用像 XML 这样由相关人士自由决定的标记语言，这就是语言的可扩展性。XML 是从标准通用标记语言（SGML）中简化修改出来的。它主要用到的有可扩展标记语言、可扩展样式语言（XSL）、XBRL 和 XPath 等。   - 引自维基百科

 _为什么要把上面维基百科的内容复制进来呢?因为这也是我查找到的资料,记录下来方便以后查找,就当做学习笔记来看待,多阅读几次也能加深印象 _

 ### Pull解析
 这里不一一描述各种解析方式,而是直接将自己写的一段解析 XML 的代码贴到这里,方便以后查询学习

 ``` Android
 /**
 * 使用 PULL 方法解析指令集XML
 *
 * @param context        context
 * @param xmlResourcesId XML资源ID
 * @return 解析后的结果
 */
public Set<T> parserXML(Context context, int xmlResourcesId) {
    Set<T> mInstructions = new HashSet<>();
    try {
        //从xml资源文件夹加载 customizes.xml 文件
        XmlResourceParser XmlParser = context.getResources().getXml(xmlResourcesId);
        int type = XmlParser.getEventType();
        T newObject = getNewObject();
        while (type != XmlResourceParser.END_DOCUMENT) {
            switch (type) {
                case XmlResourceParser.START_DOCUMENT:
                    mInstructions = new HashSet<>();
                    break;
                case XmlResourceParser.START_TAG:
                    if (root.equals(XmlParser.getName())) {
                        //如果读取到根节点则跳过
                        break;
                    }
                    if (elementRoot.equals(XmlParser.getName())) {
                        //如果读取到开始指令节点则创建指令对象
                        newObject = getNewObject();
                    } else {
                        assert newObject != null;
                        //使用反射获取指令
                        setInstructionValueByName(newObject, XmlParser.getName(), XmlParser.nextText());
                    }
                    break;
                case XmlResourceParser.END_TAG:
                    if (elementRoot.equals(XmlParser.getName())) {
                        //添加指令到指令集合
                        mInstructions.add(newObject);
                        //指令对象清空,预备下次使用
                        newObject = null;
                    }
                    break;
                default:
                    break;
            }
            //读取下一个节点状态
            type = XmlParser.next();
        }
    } catch (XmlPullParserException e) {
        Logger.e(e, "指令集配置文件解析异常");
    } catch (IOException e) {
        Logger.e(e, "指令集配置文件读取异常");
    }
    return mInstructions;
}

/**
 * 通过反射读取出指令
 *
 * @param instruction 指令对象
 * @param name        节点名字
 * @param value       节点值
 */
private void setInstructionValueByName(@NonNull T instruction, @NonNull String name, @NonNull String value) {
    try {
        Class clazz = getObjectClass();
        Method declaredMethod = clazz.getDeclaredMethod("set" + name, String.class);
        declaredMethod.invoke(instruction, value);
    } catch (Exception e) {
        Logger.e(e, "反射解析错误");
    }
}
 ```
 _以上代码仅为个人使用记录_

 ### 总结
 程序还是相当灵活的,有很多的方法能实现同一个目的,至于怎么选择,怎么应用就完全靠自己的抉择,学习的越多可选择的解决方式也就越多,努力学习吧~
