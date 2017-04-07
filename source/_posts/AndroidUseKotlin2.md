---
title: 使用 Kotlin 开发 Android 应用(2)
date: 2017-04-05 10:51:11
tags:
  - Android
  - Kotlin
  - 原创
  - 学习笔记
thumbnail: /img/blog/kotlin.jpg
---
### Kotlin 用于 Android 开发的分析

Kotlin 是一种十分适合替代 Java 进行 Android 开发的一种语言,同样可以在 Java 虚拟机上运行,并且与 Java 之间可以进行混合使用,这样就使得现存的大部分 Android 的第三方工具都可以无条件使用, 并且 Kotlin 在 IDE 兼容方面做得十分优秀使得配置起来十分简单方便甚至可以一键进行配置,这进一步降低了使用门槛

Kotlin 还提供了一个能将现有的 Java 代码转换为 Kotlin 代码的工具,可以在 IDE 中将 Java 代码转换为 Kotlin 代码并且转换的相当不错,甚至可以利用这个工具来熟悉使用 Kotlin 语言, 当使用 Kotlin 语言遇到了代码方面的问题,可以用 Java 现将功能实现在一键转换为 Kotlin 语言之后参考学习,这也降低了学习成本


### Kotlin 应用方面与 Java 的对比
1. 类型检查和自动转换
``` Java
fun getStringLength(obj: Any): Int? {
  // && 右边 obj 已经自动转换为 String 类型
  if (obj is String && obj.length > 0)
    return obj.length

  return null
}
```
上方的例子 obj 的类型在传入方法时为 Any (相当于 Java 中的 Object) 但在执行了类型检查 obj is String 之后如果返回值为 true obj 就已经自动转换为了 String 类型, 所以之后的 obj 就可以当做一个 String 来使用.

2. when 表达式

  这是一个 Java 中没有的表达式,功能十分强大便捷
  ```Java
  fun cases(obj: Any) {
    when (obj) {
        1 -> print("One") // 当 obj == 1 时
        "Hello" -> print("Greeting") // 当 obj == "Hello"时
        is Long -> print("Long") //当 obj 是 Long 类型时
        !is String -> print("Not a string") // 当 obj 不是字符串时
        else -> print("Unknown")
    }
}
  ```
  上方例子中的 when 表达式非常实用,最直观的一点可以解决过多 if 的问题,为了更加直观写一个上方例子相对的 Java 版本
  ```Java
  public static void cases(Object obj) {
        if (obj instanceof Integer) {
            Logger.i("One");
        } else if (obj instanceof String && obj.equals("Hello")) {
            Logger.i("Greeting");
        } else if (obj instanceof Long) {
            Logger.i("Long");
        } else if (!(obj instanceof String)) {
            Logger.i("Not a string");
        } else {
            Logger.i("Unknown");
        }
    }
  ```
3. 给已有类型扩展函数
  ```Java
  fun Int.biggerThanTen(): Boolean {
    return this > 10
  }

  // 测试一下扩展函数
  fun extensions() {
    100.biggerThanTen()
    5.biggerThanTen()
  }
  ```

  这种特性简直是太方便了,甚至能节省大部分的工具类,直接就可以给已有的类添加新的方法
4. 数据类型

  数据类是一种非常强大的类,它可以让你避免创建 Java 中的用于保存状态但又操作非常简单的模版代码
  ```Java
public class TestEntity {
    String name;
    String age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "TestEntity{" +
                "name='" + name + '\'' +
                ", age='" + age + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TestEntity that = (TestEntity) o;

        if (name != null ? !name.equals(that.name) : that.name != null) return false;
        return age != null ? age.equals(that.age) : that.age == null;

    }

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + (age != null ? age.hashCode() : 0);
        return result;
    }
}

  ```
  以上代码是一个拥有两个属性的一个数据实体类,是 Java 中较为常见的写法,而在 Kotlin 中就相对简单的多

  ```Kotlin
  data class TestEntityKT(val name: String, val age: String)
  ```

  仅以上的一行代码即可实现与 Java 中相同的功能, 其中的大部分的重复代码全部交由 Kotlin 来处理,大大节约了代码量

5. 关于循环

  Kotlin 对于循环也有很多相当方便的功能,能使代码更加简洁,可读性也更高,以下将和 Java 代码做一下简单的对比

  Java 代码
  ```Java
  List<CarMonitor> tempMonitor = new ArrayList<>();
  for (CarMonitor monitor : monitors) {
     for (String code : codes) {
        if (monitor.equalsCode(code)) {
              tempMonitor.add(monitor);
        }
     }
   }
  ```

  Kotlin 代码
  ```Java
  val tempMonitor = ArrayList<CarMonitor>()
  codes.forEach { code ->
      monitors.asSequence()
              .filter { it.code == code }
              .forEach { tempMonitor.add(it) }
  }
  ```
