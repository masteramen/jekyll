---
layout: post
title:  "Java集合的交集,并集和差集"
title2:  "Java集合的交集,并集和差集"
date:   2017-01-01 23:57:31  +0800
source:  "http://www.jfox.info/java%e9%9b%86%e5%90%88%e7%9a%84%e4%ba%a4%e9%9b%86%e5%b9%b6%e9%9b%86%e5%92%8c%e5%b7%ae%e9%9b%86.html"
fileName:  "20170101351"
lang:  "zh_CN"
published: true
permalink: "java%e9%9b%86%e5%90%88%e7%9a%84%e4%ba%a4%e9%9b%86%e5%b9%b6%e9%9b%86%e5%92%8c%e5%b7%ae%e9%9b%86.html"
---
{% raw %}
项目中有时会遇到计算集合的交集, 差集和并集的操作.现写个Demo作为笔记.

#### Demo前提条件

1. `Person` 为集合中的对象,且有唯一id 
2. `listA` 包含 `1,2,3,6` 四个对象 
3. `listB` 包含 `1,2,4,7` 四个对象 
4. `listC` 包含 `1,3,4,5` 四个对象 

Demo包含两个和三个集合的交集, 差集和并集:

1. `listA` 与 `listB` 的交集 
2. `listA` 与 `listB, listC` 的交集 
3. `listA` 与 `listB` 的差集 
4. `listA` 与 `listB, listC` 的差集 
5. `listA` 与 `listB` 的并集 
6. `listA` 与 `listB, listC` 的并集 

人工计算的结果应为:

1. `listA` 与 `listB` 的交集为 `1,2`
2. `listA` 与 `listB, listC` 的交集为 `1`
3. `listA` 与 `listB` 的差集为 `3,6`
4. `listA` 与 `listB, listC` 的差集为 `6`
5. `listA` 与 `listB` 的并集为 `1,2,3,4,6,7`
6. `listA` 与 `listB, listC` 的并集 `1,2,3,4,5,6,7`

## 0x02 准备代码

###  1. `Person` 对象代码 

 对象 `Person` 的代码如下: 

    public class Person {
    
        /**
         * 性别:男
         */
        public static final int SEX_MALE = 0;
        /**
         * 性别:女
         */
        public static final int SEX_FEMALE = 1;
    
        private String id;   //身份id
        private String name; //名字
        private int age;     //年龄
        private int sex = SEX_MALE; //性别
    
        public String getId() {
            return id;
        }
    
        public void setId(String id) {
            this.id = id;
        }
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public int getAge() {
            return age;
        }
    
        public void setAge(int age) {
            this.age = age;
        }
    
        public int getSex() {
            return sex;
        }
    
        public void setSex(int sex) {
            this.sex = sex;
        }
    
        @Override
        public String toString() {
            return "Person{" +
                    "id='" + id + ''' +
                    ", name='" + name + ''' +
                    ", age=" + age +
                    ", sex=" + sex +
                    '}';
        }
    
        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
    
            Person person = (Person) o;
    
            if (age != person.age) return false;
            if (sex != person.sex) return false;
            if (id != null ? !id.equals(person.id) : person.id != null) return false;
            return name != null ? name.equals(person.name) : person.name == null;
        }
    
        @Override
        public int hashCode() {
            int result = id != null ? id.hashCode() : 0;
            result = 31 * result + (name != null ? name.hashCode() : 0);
            result = 31 * result + age;
            result = 31 * result + sex;
            return result;
        }
    }

### 2. 三个集合代码

三个集合代码分别如下:

    private List<Person> getListC(BeanServer server) {
        List<Person> listC = new ArrayList<>();
        listC.add(server.getPerson1());
        listC.add(server.getPerson3());
        listC.add(server.getPerson4());
        listC.add(server.getPerson5());
        return listC;
    }
    
    private List<Person> getListB(BeanServer server) {
        List<Person> listB = new ArrayList<>();
        listB.add(server.getPerson1());
        listB.add(server.getPerson2());
        listB.add(server.getPerson4());
        listB.add(server.getPerson7());
        return listB;
    }
    
    private List<Person> getListA(BeanServer server) {
        List<Person> listA = new ArrayList<>();
        listA.add(server.getPerson1());
        listA.add(server.getPerson2());
        listA.add(server.getPerson3());
        listA.add(server.getPerson6());
        return listA;
    }

### 3. 求交集的方法

计算交集的代码如下:

    @SafeVarargs
    private final void retain(List<Person> source, List<Person>... targets) {
        List<Person> result = new ArrayList<>();
        result.addAll(source);
        if (targets != null && targets.length > 0) {
            for (List<Person> target : targets) {
                result.retainAll(target);
            }
        }
        for (Person person : result) {
            System.out.println(person);
        }
    }

### 4. 求差集的方法

计算差集的代码如下:

    @SafeVarargs
    private final void remove(List<Person> source, List<Person>... targets) {
        List<Person> result = new ArrayList<>();
        result.addAll(source);
        if (targets != null && targets.length > 0) {
            for (List<Person> target : targets) {
                result.removeAll(target);
            }
        }
        for (Person person : result) {
            System.out.println(person);
        }
    }

### 5. 求并集的方法

计算交集的代码如下:

    @SafeVarargs
    private final void add(List<Person> source, List<Person>... targets) {
        Set<Person> result = new HashSet<>();
        result.addAll(source);
        if (targets != null && targets.length > 0) {
            for (List<Person> target : targets) {
                result.addAll(target);
            }
        }
        for (Person person : result) {
            System.out.println(person);
        }
    }

## 0x03 开始计算

分别计算两个和三个集合的交集,差集和并集

    /**
     * 交集
     */
    public void retain() {
        System.out.println("===============listA retain listB===============");
        retain(listA, listB);
        System.out.println("===============listA retain listB, listC===============");
        retain(listA, listB, listC);
    }
    
    /**
     * 差集
     */
    public void remove() {
        System.out.println("===============listA remove listB===============");
        remove(listA, listB);
        System.out.println("===============listA remove listB, listC===============");
        remove(listA, listB, listC);
    }
    
    /**
     * 并集
     */
    public void add() {
        System.out.println("===============listA add listB===============");
        add(listA, listB);
        System.out.println("===============listA add listB, listC===============");
        add(listA, listB, listC);
    }

## 0x04 计算结果

计算结果如下:

    ===============listA===============
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='002', name='小绿', age=19, sex=1}
    Person{id='003', name='小明', age=16, sex=0}
    Person{id='006', name='小白', age=16, sex=0}
    ===============listB===============
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='002', name='小绿', age=19, sex=1}
    Person{id='004', name='小蓝', age=18, sex=0}
    Person{id='007', name='小黑', age=20, sex=0}
    ===============listC===============
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='003', name='小明', age=16, sex=0}
    Person{id='004', name='小蓝', age=18, sex=0}
    Person{id='005', name='小黄', age=19, sex=1}
    ===============listA retain listB===============
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='002', name='小绿', age=19, sex=1}
    ===============listA retain listB, listC===============
    Person{id='001', name='小红', age=18, sex=1}
    ===============listA add listB===============
    Person{id='003', name='小明', age=16, sex=0}
    Person{id='006', name='小白', age=16, sex=0}
    Person{id='007', name='小黑', age=20, sex=0}
    Person{id='002', name='小绿', age=19, sex=1}
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='004', name='小蓝', age=18, sex=0}
    ===============listA add listB, listC===============
    Person{id='003', name='小明', age=16, sex=0}
    Person{id='006', name='小白', age=16, sex=0}
    Person{id='007', name='小黑', age=20, sex=0}
    Person{id='002', name='小绿', age=19, sex=1}
    Person{id='001', name='小红', age=18, sex=1}
    Person{id='004', name='小蓝', age=18, sex=0}
    Person{id='005', name='小黄', age=19, sex=1}
    ===============listA remove listB===============
    Person{id='003', name='小明', age=16, sex=0}
    Person{id='006', name='小白', age=16, sex=0}
    ===============listA remove listB, listC===============
    Person{id='006', name='小白', age=16, sex=0}

输出结果与人工计算结果一致.

## 0x05 项目代码
{% endraw %}
