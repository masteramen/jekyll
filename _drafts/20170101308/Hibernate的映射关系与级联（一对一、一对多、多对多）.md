---
layout: post
title:  "Hibernate的映射关系与级联（一对一、一对多、多对多）"
title2:  "Hibernate的映射关系与级联（一对一、一对多、多对多）"
date:   2017-01-01 23:56:48  +0800
source:  "http://www.jfox.info/hibernate%e7%9a%84%e6%98%a0%e5%b0%84%e5%85%b3%e7%b3%bb%e4%b8%8e%e7%ba%a7%e8%81%94%e4%b8%80%e5%af%b9%e4%b8%80%e4%b8%80%e5%af%b9%e5%a4%9a%e5%a4%9a%e5%af%b9%e5%a4%9a.html"
fileName:  "20170101308"
lang:  "zh_CN"
published: true
permalink: "hibernate%e7%9a%84%e6%98%a0%e5%b0%84%e5%85%b3%e7%b3%bb%e4%b8%8e%e7%ba%a7%e8%81%94%e4%b8%80%e5%af%b9%e4%b8%80%e4%b8%80%e5%af%b9%e5%a4%9a%e5%a4%9a%e5%af%b9%e5%a4%9a.html"
---
{% raw %}
长期专业踩坑……怪物猎人要登陆switch了

#### 1、外键注意：

- 被引用的列必须是其所在表的主键或者唯一列（此处的department表的dept_name)
- 引用列 和 被引用列应该数据类型一致，并且最好长度一致
- 如果存在数据，那么引用列中 不能 存在 被引用列中没有的数据

#### 2、配置注意：

- 一的那边配置了，多的那边不配置，叫单向一对多
- 一的那边配置了，多的那边也配置，叫双向一对多
- 一的那边不配置，多的那边配置了，报错

#### 3、字段重复注意：

- 因为是一给多加字段，所以在多的一边加的字段不要重复，会报错

#### 4、级联删除注意：

- 在数据库中直接删除级联的表，要先删除子表，再删除主表，一开始就删除主表是不行的，因为他被子表给引用着

#### 5、级联插入注意

- 
级联之后，从表插不进去，为什么？

- 增加了父亲的话，可以在这个父亲的名下增加相应的孩子
- 但是你随便增加孩子却不行，孩子必须有父亲，没有父亲的孩子哪里来的？石头蹦？孙悟空？
- 这就是级联，都是连在一起的，有父亲才有孩子

#### 6、测试的时候不要被之前的表数据给阻碍，所以每次测试前请删除相关的表

如果删除表的时候数据库工具一直在转圈，像死机了一样关闭不行，又不动，操作不了，其实是因为你的Eclipse还在开着刚才运行的代码，每一个都是独立的线程，数据库工具会因为等待其关闭而处于阻塞状态，在Eclipse的Console界面可以看到右上角有红点，表示在运行中，把所有的红点都关掉就可以了

    //删除
    DROP TABLE IF EXISTS `toy_son`;
    DROP TABLE IF EXISTS `son`;
    DROP TABLE IF EXISTS `toy`;
    DROP TABLE IF EXISTS `father`;
    DROP TABLE IF EXISTS `mother`;
    DROP TABLE IF EXISTS `father`;
    
    //查询
    select * from father;
    select * from mother;
    select * from son;
    select * from toy;
    select * from toy_son;

#### 7、其实cascade不是必须的，你使用了cascade就可以只保存主表，从表会跟着保存，你不设置cascade，就需要自己手动保存从表

#### 8、我在下面要用的表的表关系

-  一个父亲有多个孩子 

-  一个父亲有一个妻子 

-  多个孩子有多个玩具 

#### 9、先来个总结

-  1、主键一对多 

- 以一的那方主键作为来个表之间的桥梁，所以是将一那方的字段插到多那方

-  2、非主键一对多 

- 以一的那方的某个字段作为来个表之间的桥梁，所以是将一那方的字段插到多那方

-  3、主键多对多 

- 两个表都给出主键，插到一个第三方表，这样产生关系，在第三方表就可以通过我的主键查到与我相关的你的主键，再通过你的主键去查你表里的数据

-  4、非主键多对多 

- 两个表都给出某一个字段，插到一个第三方表，这样产生关系，在第三方表就可以通过我的字段查到与我相关的你的字段，再通过你的字段去查你表里的数据

-  5、主键一对一 

- 不需要在对方的表里插字段，因为是一一对应的，所以我的主键的值就是你主键的值

-  6、非主键一对一 

-  7、双向 

- 你的表里有与我相关的字段可以查到我，我的表里也有你的字段可以查到你对应的数据

-  8、单向 

- 你的表里没有与我相关的字段，在你的表里查不到我，但是我的表里有你的字段，可以查到你对应的数据

## 二、示例

- 1、主键一对多示例
- 2、非主键一对多示例
- 3、主键多对多示例
- 4、非主键多对多示例
- 5、主键一对一示例
- 6、非主键一对一示例
- 7、双向示例
- 8、单向示例

#### 下面的xml示例都会省略头部声明，完整的xx.hbm.xml参考如下：

    <?xml version="1.0"?>
    <!DOCTYPE hibernate-mapping PUBLIC
            "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
            "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
    
    <hibernate-mapping package="com.iamzhuwh.more2more">
        <class name="Father" table="FATHER">
             <id name="f_id" column="F_ID">
                 <generator class="native"/>
             </id>
             <property name="f_name" type="string" column="F_NAME"/>
        </class>
    </hibernate-mapping>

## 1、主键一对多示例

#### 儿子与父亲的联系在于父亲的f_id，因为f_id是唯一可以识别父亲的标识，所以将父亲的主键f_id作为外键给儿子，以后凭f_id就可以找到父亲对应的儿子啦

    /** 父亲 */
    public class Father {
        /** 父亲的id，主键 */
        private int f_id;
        /** 父亲的名字 */
        private String f_name;
        /** 可能有多个儿子，所以是集合,对应配置文件的<set one-to-many>*/
        private Set son = new HashSet();
    }
    
    /** 儿子 */
    public class Son {
        /** 儿子的id，主键 */
        private int s_id;
        /** 儿子的名字 */
        private String s_name;
        /** 只有一个父亲,对应配置文件的<many-to-one>*/
        private Father father;
    }
    
    /** 父亲配置文件，Father.hbm.xml */
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 
            对应的实体类：com.iamzhuwh.one2more.Father
            定义class标签，  <class name="Father" table="FATHER">
                name是实体类名字，
                table是你要创建的表名
            包名：package="com.iamzhuwh.one2more"
        -->
        <class name="Father" table="FATHER">
            <!-- id是主键，自增 -->
             <id name="f_id" column="F_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="f_name" type="string" column="F_NAME"/>
             <set name="son" inverse="false" cascade="all" >
                <!-- 
                    一的一方的外键column="f_id" 
                    儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
                -->
                <key column="f_id"></key>
                <one-to-many class="com.iamzhuwh.one2more.Son"/>
             </set>
        </class>
    </hibernate-mapping>
    
    <!-- 儿子配置文件，Son.hbm.xml -->
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Son" table="SON">
            <!-- id是主键，自增 -->
             <id name="s_id" column="S_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="s_name" type="string" column="S_NAME"/>
             <property name="s_f_id" type="int" column="S_F_ID"/>
             <!-- 
                一的一方的外键column="f_id"
                儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
              -->
             <many-to-one name="father" column="f_id" class="com.iamzhuwh.one2more.Father">
             </many-to-one>
        </class>
    </hibernate-mapping>
    
    /** 测试代码 */
    public class Test {
        @SuppressWarnings("unchecked")
        public static void main(String[] args) {
            /** 父亲 */
            Father father = new Father();
            father.setF_name("f1");
            /** 儿子 */
            Son son = new Son();
            son.setS_name("s1");
            /** 
                级联  
                增加了父亲的话，可以在这个父亲的名下增加相应的孩子
                但是你随便增加孩子却不行，孩子必须有父亲，没有父亲的孩子哪里来的？石头蹦？孙悟空？
                这就是级联，都是连在一起的
             */
            father.getSon().add(son);
            /** 获取连接 */
            SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            /** 因为是连在一起的，所以保存了父亲，父亲名下的孩子也会被保存 */
            System.out.println("Father:"+session.save(father));
            /** 提交事务 */
            session.getTransaction().commit();
        }

## 2、非主键一对多示例

#### 以上面的代码为基础，上面提到了父亲的主键f_id作为外键给儿子，以后凭f_id就可以找到父亲对应的儿子，那么如果父亲给的外键不是主键呢？比如f_name，父亲的名字

- 使用非主键作为外键，这个外键必须是唯一不可重复的，所以要设置unique=”true”
- 在一的那边使用属性property-ref，即是

    /** 父亲配置 */
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Father" table="FATHER">
            <!-- id是主键，自增 -->
             <id name="f_id" column="F_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 
                    这里变一下
                    unique="true"
             -->
             <property name="f_name" type="string" column="F_NAME" unique="true"/>
             <set name="son" inverse="false" cascade="all" >
                <!-- 
                    **** 重要 ****
                    这里变一下 property-ref="f_name"
                    用父亲表的父亲名字f_name作为外键，赋予给儿子
                    key column="s_f_name"，这句话只是给加在儿子表的那个字段起个名字叫s_f_name而已
                    使用property-ref="f_name"才是真正将f_name的值赋予给s_f_name
                -->
                <key column="s_f_name" property-ref="f_name"></key>
                <one-to-many class="com.iamzhuwh.one2more.Son"/>
             </set>
        </class>
    </hibernate-mapping>
    <!-- 儿子配置 -->
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Son" table="SON">
            <!-- id是主键，自增 -->
             <id name="s_id" column="S_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="s_name" type="string" column="S_NAME"/>
             <property name="s_f_id" type="int" column="S_F_ID"/>
             <!-- 
                    这里变一下，column="s_f_name"
              -->
             <many-to-one name="father" column="s_f_name" class="com.iamzhuwh.one2more.Father">
             </many-to-one>
        </class>
    </hibernate-mapping>

## 3、主键多对多示例

- 多对多的时候，要记住，不是简单给个字段对方而已，要建一个中间表，将双方的外键放上去

    /** 儿子表的实体 */
    public class Son {
        /** 儿子的id，主键 */
        private int s_id;
        /** 儿子的名字 */
        private String s_name;
        /** 儿子的玩具,一个儿子可以拥有多个玩具 */
        private Set toys = new HashSet();
    }
    
    /** 玩具表的实体 */
    public class Toy {
        /** 玩具的id，主键 */
        private int t_id;
        /** 玩具的名字 */
        private String t_name;
        /** 每个玩具可以被多个人拥有*/
        private Set sons = new HashSet();
    }
    
    
    <!-- 儿子表的配置 -->
    <hibernate-mapping package="com.iamzhuwh.more2more">
        <!-- SON表 -->
        <class name="Son" table="SON">
            <!-- 主键，自增 -->
             <id name="s_id" column="S_ID">
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="s_name" type="string" column="S_NAME"/>
            <!-- 
                儿子可以有多个玩具，所以将儿子的s_id作为外键，<key column="S_ID"></key>
                玩具可以有多个主人，所以将玩具的t_id作为外键，<many-to-many column="T_ID"
                如果让玩具表来处理级联的增删改，需要在玩具的Set标签中配置inverse与cascade
                **** 重点 ****
                    这个table填的是TOY_SON！！！<set name="toys" table="TOY_SON"
                    根据上面一对多的经验，我们是要外键给对方，所以这里填的应该是对方的表名才对吧？
                    但是这里为啥填的是TOY_SON？为啥不是TOY或者SON？
    
                因为要新建一张第三方叫TOY_SON的表，来存放儿子与玩具的外键
    
                <set name="toys"，这里填的是你在Son.java中配置的Set集合的名字：
                private Set toys = new HashSet();/** 儿子的玩具,一个儿子可以拥有多个玩具*/
             -->
            <set name="toys" table="TOY_SON" inverse="true" cascade="all">
                <!-- column="S_ID"，代表是Son给出的外键是S_ID -->
                <key column="S_ID"></key>
                <many-to-many column="T_ID" class="com.iamzhuwh.more2more.Toy"></many-to-many>
                 <!-- column="T_ID"，代表是com.iamzhuwh.more2more.Toy给出的外键是T_ID -->
            </set>
        </class>
    </hibernate-mapping>
    
    <!-- 玩具表的配置 -->
    <hibernate-mapping package="com.iamzhuwh.more2more">
        <!-- TOY表 -->
        <class name="Toy" table="TOY">
            <!-- id是主键，自增 -->
             <id name="t_id" column="T_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="t_name" type="string" column="T_NAME"/>
            <!-- 
                玩具可以有多个主人，所以将玩具的t_id作为外键，<key column="T_ID"></key>
                儿子可以有多个玩具，所以将儿子的s_id作为外键，<many-to-many column="S_ID"
                **** 注意 ****
                如果让玩具表来处理级联的增删改，需要在玩具的Set标签中配置inverse与cascade
                但是上面已经让儿子来处理了，所以在玩具这里不用配置inverse与cascade
                **** 重点 ****
                    这个table填的是TOY_SON！！！<set name="sons" table="TOY_SON">
                    根据上面一对多的经验，我们是要外键给对方，所以这里填的应该是对方的表名才对吧？
                    但是这里为啥填的是TOY_SON？为啥不是TOY或者SON？
    
                因为要新建一张第三方叫TOY_SON的表，来存放儿子与玩具的外键
    
                <set name="sons"，这里填的是你在Toy.java中配置的Set集合的名字：
                private Set sons = new HashSet();/** 每个玩具可以被多个人拥有*/
             -->
            <set name="sons" table="TOY_SON">
                <!-- column="T_ID"，代表Toy给出的外键是T_ID -->
                <key column="T_ID"></key>
                <many-to-many column="S_ID" class="com.iamzhuwh.more2more.Son"></many-to-many>
                 <!-- column="S_ID"，代表是Son给出的外键是S_ID -->
            </set>
        </class>
    </hibernate-mapping>
    
    /** 测试代码 */
    public class Test {
        @SuppressWarnings("unchecked")
        public static void main(String[] args) {
            /** 玩具 */
            Toy toy = new Toy();
            toy.setT_name("t1");
            /** 儿子 */
            Son son = new Son();
            son.setS_name("s1");
            /** 级联  
                因为在Son配置表中配置了<set name="toys" table="TOY_SON" inverse="true" cascade="all">
                所以级联让Toy来处理，增加了Toy的话，可以把玩具赋给相应的孩子
             */
            toy.getSons().add(son);
            son.getToys().add(toy);
            /** 获取连接 */
            SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            /** 因为是连在一起的，所以保存了儿子，儿子名下的玩具也会被保存 */
            System.out.println("Son:"+session.save(son));
            /** 提交事务 */
            session.getTransaction().commit();
        }
    }

## 4、非主键多对多示例

上面是主键多对多示例，所以使用主键id作为外键，这次是非主键作为外键，所以我们使用名字name作为外键

    <hibernate-mapping package="com.iamzhuwh.more2more">
        <class name="Son" table="SON">
             <id name="s_id" column="S_ID">
                 <generator class="native"/>
             </id>
             <!-- 
                 这次要用这个s_name作为外键，所以要加一个unique="true"
                 让其变为唯一可以代表这个儿子的标识
             -->
             <property name="s_name" type="string" column="S_NAME" unique="true"/>
    
            <!-- 
                <key column="S_NAME" property-ref="s_name"></key>
                解析：
                column="S_NAME"：
                    在TOY_SON表中创建一个字段名字叫S_NAME
                property-ref="s_name"：
                    这个字段的类型或者值请参考Son配置表的property name="s_name"
                ————————————————————————————————————————————————————
                <many-to-many column="T_NAME" property-ref="t_name"
                解析：
                column="T_NAME"：
                    在TOY_SON表中创建一个字段名字叫T_NAME
                property-ref="t_name"：
                    这个字段的类型或者值请参考Toy配置表的property name="t_name"
             -->
            <set name="toys" table="TOY_SON" inverse="true" cascade="all" >
                <key column="S_NAME" property-ref="s_name"></key>
                <many-to-many column="T_NAME" property-ref="t_name" class="com.iamzhuwh.more2more.Toy"></many-to-many>
            </set>
        </class>
    </hibernate-mapping>
    
    
    <hibernate-mapping package="com.iamzhuwh.more2more">
        <class name="Toy" table="TOY">
             <id name="t_id" column="T_ID">
                 <generator class="native"/>
             </id>
             <!-- 
                 这次要用这个t_name作为外键，所以要加一个unique="true"
                 让其变为唯一可以代表这个玩具的标识
             -->
             <property name="t_name" type="string" column="T_NAME" unique="true"/>
             <!-- 
                <key column="T_NAME" property-ref="t_name"></key>
                解析：
                column="T_NAME"：
                    在TOY_SON表中创建一个字段名字叫T_NAME
                property-ref="t_name"：
                    这个字段的类型或者值请参考Toy配置表的property name="t_name"
                ————————————————————————————————————————————————————
                <many-to-many column="S_NAME" property-ref="s_name"
                解析：
                column="S_NAME"：
                    在TOY_SON表中创建一个字段名字叫S_NAME
                property-ref="s_name"：
                    这个字段的类型或者值请参考Son配置表的property name="s_name"
             -->
            <set name="sons" table="TOY_SON">
                <key column="T_NAME" property-ref="t_name"></key>
                <many-to-many column="S_NAME" property-ref="s_name" class="com.iamzhuwh.more2more.Son"></many-to-many>
            </set>
    
        </class>
    </hibernate-mapping>

## 5、主键一对一示例

这个一对一，你查看数据库表，是没有多出字段的，为什么？因为是一一对应的，比如我用我的id就可以找到你的id，因为是一一对应，所以不需要在你的表里插一个我的id

对比一堆多，一的那边会在多的那边插入一个字段，比如id，来表示两者之间存在关系，通过这个id我就可以查找到跟我关联的你的表的数据

#### 使用one to one 的方式展示主键一对一示例

    /** 孩子他爸 */
    public class Father {
        /** 丈夫的id，主键 */
        private int f_id;
        /** 丈夫的名字 */
        private String f_name;
        /** 只有一个妻子*/
        private Mother mother;
    }
    
    /** 孩子他妈 */
    public class Mother {
        /** 妻子的id，主键 */
        private int m_id;
        /** 妻子的名字 */
        private String m_name;
        /** 只有一个丈夫 */
        private Father father;
    }
    
    <!-- 孩子他爸的配置 -->
    <hibernate-mapping package="com.iamzhuwh.one2one">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Father" table="FATHER">
            <!-- id是主键，自增 -->
             <id name="f_id" column="F_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="f_name" type="string" column="F_NAME"/>
             <!-- 
                父母是一对一的，一个丈夫对应一个妻子,所以在丈夫中引入妻子
                <one-to-one name="mother"
                这里就是配置了妻子的信息
                name="mother"代表在Father.java中创建了一个叫mother的变量
                    参考Father.java：
                    /** 只有一个妻子*/
                    private Mother mother;
                property-ref="m_id"代表引用Mother中的m_id作为外键
                    参考Mother.hbm.xml：
                    <id name="m_id" column="M_ID">
             -->
             <one-to-one name="mother" property-ref="m_id" cascade="all" class="com.iamzhuwh.one2one.Mother"></one-to-one>
        </class>
    </hibernate-mapping>
    
    <!-- 孩子他妈的配置 -->
    <hibernate-mapping package="com.iamzhuwh.one2one">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Mother" table="MOTHER">
            <!-- id是主键，自增 -->
             <id name="m_id" column="M_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="m_name" type="string" column="M_NAME"/>
             <!-- 
                父母是一对一的，一个丈夫对应一个妻子,所以在妻子中引入丈夫
                <one-to-one name="father"
                这里就是配置了丈夫的信息
                name="father"代表在Mother.java中创建了一个叫father的变量
                    参考Mother.java：
                    /** 只有一个丈夫 */
                    private Father father;
               property-ref="f_id"代表引用Father中的f_id作为外键
                    参考Father.hbm.xml：
                    <id name="f_id" column="F_ID">
             -->
             <one-to-one name="father" property-ref="f_id" class="com.iamzhuwh.one2one.Father"></one-to-one>
        </class>
    </hibernate-mapping>
    
    /** 测试代码 */
    public class Test {
        @SuppressWarnings("unchecked")
        public static void main(String[] args) {
            /** 孩子爸 */
            Father father = new Father();
            father.setF_name("f1");
            /** 孩子妈 */
            Mother mother = new Mother();
            mother.setM_name("m1");
            /** 级联  
                增加丈夫，也可以增加妻子
             */
            father.setMother(mother);
            mother.setFather(father);
            /** 获取连接 */
            SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            /** 
                因为在孩子他爸的配置表里面配置了cascade="all"，
                所以这里只需要保存孩子爸，孩子妈就会因为级联而被保存
                如果没有cascade，则孩子妈需要手动保存
            */
            System.out.println("Father:"+session.save(father));
            /** 提交事务 */
            session.getTransaction().commit();
        }
    }

#### 使用many to one 的方式展示主键一对一示例

还是在上面的基础上改，改父亲配置表里面的孩子妈配置，将one to one改为more to one，给more to one的字段配置唯一约束unique，它的效果就相当于变成one to one了

    <!-- 修改孩子妈配置表 -->
    <many-to-one name="father" column="F_ID" class="com.iamzhuwh.one2one.Father" unique="true"></many-to-one>
    <!-- 孩子爸配置表还是不变 -->
     <one-to-one name="mother" cascade="all" class="com.iamzhuwh.one2one.Mother"></one-to-one>

## 6、非主键一对一示例

按上面的经验，在使用one to one的基础上，修改为非主键一对一，以名字作为外键，设置名字唯一的约束unique，其他不变

#### 使用one to one 的方式展示非主键一对一示例

    <!-- 孩子爸配置表 -->
    <property name="f_name" type="string" column="F_NAME" unique="true"/>
    <!--引用孩子妈的名字作为外键， property-ref="m_name" -->
    <one-to-one name="mother" property-ref="m_name" cascade="all" class="com.iamzhuwh.one2one.Mother"></one-to-one>
    
    <!-- 孩子妈配置表 -->      
    <property name="m_name" type="string" column="M_NAME" unique="true"/>
    <!--引用孩子爸的名字作为外键， property-ref="f_name" -->
    <one-to-one name="father" property-ref="f_name" class="com.iamzhuwh.one2one.Father"></one-to-one>

#### 使用many to one 的方式展示非主键一对一示例

    <!-- 在上面的进程上修改孩子妈配置表 <one-to-one变<many-to-one -->   
    <many-to-one name="father" property-ref="f_name" class="com.iamzhuwh.one2one.Father" unique="true"></many-to-one>

## 7、双向示例

这个是一对多的双向示例，双向就是说通过我可以查到你，通过你可以查到我

    /** 父亲 */
    public class Father {
        /** 父亲的id，主键 */
        private int f_id;
        /** 父亲的名字 */
        private String f_name;
        /** 可能有多个儿子，所以是集合,对应配置文件的<set one-to-many>*/
        private Set son = new HashSet();
    }
    
    /** 儿子 */
    public class Son {
        /** 儿子的id，主键 */
        private int s_id;
        /** 儿子的名字 */
        private String s_name;
        /** 只有一个父亲,对应配置文件的<many-to-one>*/
        private Father father;
    }
    
    /** 父亲配置文件，Father.hbm.xml */
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 
            对应的实体类：com.iamzhuwh.one2more.Father
            定义class标签，  <class name="Father" table="FATHER">
                name是实体类名字，
                table是你要创建的表名
            包名：package="com.iamzhuwh.one2more"
        -->
        <class name="Father" table="FATHER">
            <!-- id是主键，自增 -->
             <id name="f_id" column="F_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="f_name" type="string" column="F_NAME"/>
             <set name="son" inverse="false" cascade="all" >
                <!-- 
                    一的一方的外键column="f_id" 
                    儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
                -->
                <key column="f_id"></key>
                <one-to-many class="com.iamzhuwh.one2more.Son"/>
             </set>
        </class>
    </hibernate-mapping>
    
    <!-- 儿子配置文件，Son.hbm.xml -->
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Son" table="SON">
            <!-- id是主键，自增 -->
             <id name="s_id" column="S_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="s_name" type="string" column="S_NAME"/>
             <property name="s_f_id" type="int" column="S_F_ID"/>
             <!-- 
                一的一方的外键column="f_id"
                儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
              -->
             <many-to-one name="father" column="f_id" class="com.iamzhuwh.one2more.Father">
             </many-to-one>
        </class>
    </hibernate-mapping>
    
    /** 测试代码 */
    public class Test {
        @SuppressWarnings("unchecked")
        public static void main(String[] args) {
            /** 父亲 */
            Father father = new Father();
            father.setF_name("f1");
            /** 儿子 */
            Son son = new Son();
            son.setS_name("s1");
            /** 
                级联  
                增加了父亲的话，可以在这个父亲的名下增加相应的孩子
                但是你随便增加孩子却不行，孩子必须有父亲，没有父亲的孩子哪里来的？石头蹦？孙悟空？
                这就是级联，都是连在一起的
             */
            father.getSon().add(son);
            /** 获取连接 */
            SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            /** 因为是连在一起的，所以保存了父亲，父亲名下的孩子也会被保存 */
            System.out.println("Father:"+session.save(father));
            /** 提交事务 */
            session.getTransaction().commit();
        }

## 8、单向示例

这个是一对多的单向示例，单向就是说通过我可以查到你，你却查不到我

    /** 父亲 */
    public class Father {
        /** 父亲的id，主键 */
        private int f_id;
        /** 父亲的名字 */
        private String f_name;
        /** 可能有多个儿子，所以是集合,对应配置文件的<set one-to-many>*/
        private Set son = new HashSet();
    }
    
    /** 儿子 */
    public class Son {
        /** 儿子的id，主键 */
        private int s_id;
        /** 儿子的名字 */
        private String s_name;
        /** 只有一个父亲,对应配置文件的<many-to-one>*/
        private Father father;
    }
    
    /** 父亲配置文件，Father.hbm.xml */
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 
            对应的实体类：com.iamzhuwh.one2more.Father
            定义class标签，  <class name="Father" table="FATHER">
                name是实体类名字，
                table是你要创建的表名
            包名：package="com.iamzhuwh.one2more"
        -->
        <class name="Father" table="FATHER">
            <!-- id是主键，自增 -->
             <id name="f_id" column="F_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="f_name" type="string" column="F_NAME"/>
             <set name="son" inverse="false" cascade="all" >
                <!-- 
                    一的一方的外键column="f_id" 
                    儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
                -->
                <key column="f_id"></key>
                <one-to-many class="com.iamzhuwh.one2more.Son"/>
             </set>
        </class>
    </hibernate-mapping>
    
    <!-- 儿子配置文件，Son.hbm.xml -->
    <hibernate-mapping package="com.iamzhuwh.one2more">
        <!-- 对应的实体类，name是实体类名字，table是你要创建的表名 -->
        <class name="Son" table="SON">
            <!-- id是主键，自增 -->
             <id name="s_id" column="S_ID">
                 <!-- 主键配置 -->
                 <generator class="native"/>
             </id>
             <!-- 其他字段 -->
             <property name="s_name" type="string" column="S_NAME"/>
             <!-- 
                    一的一方的外键column="f_id"
                    儿子与父亲的联系在于父亲的f_id，因为主键f_id是唯一可以识别父亲的标识
                    因为现在是单向，所以直接把这里给去掉，这样在父亲表就找不到儿子的踪影了，但是在儿子表可以找到父亲的id
                    <many-to-one name="father" column="f_id" class="com.iamzhuwh.one2more.Father">
                    </many-to-one>
             -->
        </class>
    </hibernate-mapping>
    
    /** 测试代码 */
    public class Test {
        @SuppressWarnings("unchecked")
        public static void main(String[] args) {
            /** 父亲 */
            Father father = new Father();
            father.setF_name("f1");
            /** 儿子 */
            Son son = new Son();
            son.setS_name("s1");
            /** 
                级联  
                增加了父亲的话，可以在这个父亲的名下增加相应的孩子
                但是你随便增加孩子却不行，孩子必须有父亲，没有父亲的孩子哪里来的？石头蹦？孙悟空？
                这就是级联，都是连在一起的
             */
            father.getSon().add(son);
            /** 获取连接 */
            SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
            Session session = sessionFactory.getCurrentSession();
            session.beginTransaction();
            /** 因为是连在一起的，所以保存了父亲，父亲名下的孩子也会被保存 */
            System.out.println("Father:"+session.save(father));
            /** 提交事务 */
            session.getTransaction().commit();
        }

## 三、踩坑

#### 问题1

- Foreign key (FK_9jbtfsoc50vbxnpaladvwbd50:SON [s_id])) must have same number of columns as the referenced primary key (SON [t_id,s_id])
-  添加property-ref即可，如： 
`<key column="S_ID" property-ref="s_id"></key>`

#### 问题2

- 
Field ‘S_ID’ doesn’t have a default value 或者 Field ‘T_ID’ doesn’t have a default value

- 
我的原因是跟inverse相关，也有人说是在数据库给字段加默认值，或者是主键不要native，但是我的主键本来就是非空且自增，不可能是默认值或者native的问题

#### 问题3

- object references an unsaved transient instance – save the transient instance before flushing: com.iamzhuwh.more2more.Son
- son做级联，却保存toy，所以报错，应该是save（son），然后根据级联，son会将里面的toy拿出来保存

#### 问题4

注意两个事情：(以下面代码为例)

-  首先这里定义了一个字段： 

- `<property name="t_name" type="string" column="T_NAME" unique="true"/>`
- name=”t_name”是用来在这个配置表中代表这个字段的
- column=”T_NAME”是用来代表在数据库中要展示的字段名

-  所以这里要这样引用： 

- `<key column="T_NAME" property-ref="t_name"></key>`
- 在数据库定义一个字段叫T_NAME
- 这个字段的值引用在本配置文件中配置的t_name的信息

    <class name="Toy" table="TOY">
             <id name="t_id" column="T_ID">
                 <generator class="native"/>
             </id>
             <property name="t_name" type="string" column="T_NAME" unique="true"/>
            <set name="sons" table="TOY_SON">
                <key column="T_NAME" property-ref="t_name"></key>
                <many-to-many column="S_NAME" class="com.iamzhuwh.more2more.Son"></many-to-many>
            </set>

## 四、课外知识

## 1、为什么会有怎么多种关系？

一对多、多对一、单向、双向是针对不同的情况和业务需求已定的，其实本质是一样的，只是操作的方式不同

-  1、什么是单向与双向？ 

- 
例如：领导叫我查用户与包裹的信息

-  单向一对多： 

- 用户A对于多个包裹，领导叫我在用户表查找用户A的地址，我就查呗
- 其实我查询包裹上的信息也可以查到用户A的地址，但是没必要，因为领导说了，到用户表去查
- 又或者我没有查询包裹信息的权限，所以只有从用户表查

-  单向多对一： 

- 多个包裹对于用户A，领导叫我在包裹信息表里面查用户A的地址，我就查呗
- 其实我查询用户表上的信息也可以查到用户A的地址，但是没必要，因为领导说了，到包裹信息表去查
- 又或者我没有查询用户表的权限，所以只有从包裹信息表查

-  双向一对多/双向多对一： 

- 领导又来了，叫我查用户A的地址，不管我怎么查，我从用户表可以查到，从包裹信息表也可以查到

-  懂了么？ 

- 这就是针对不同的业务需求决定使用哪种映射关系，但是本质都是可以查到目标信息

-  2、什么是一对多与多对一？ 

- 
例如：用户与包裹

- 用户A买了一堆的东西，那就是一个用户对应多个包裹，也就是一对多
- 一堆的包裹的收件人都是用户A，那就是多个包裹对应一个用户，也就是多对一

- 
3、主键与外键

-  a、什么是主键 

-  解释： 

- 一张表中的一条数据，可能会包含多个属性，比如姓名、性别
- 已知一张表有多条数据，用什么来区分每条数据？就是用主键了
- 不为空的，不重复的，能代表一条数据的，叫主键
-  什么东西可以作为主键？ 

- 一般是XX_id，从1开始自动递增，保证不重复
- 也可以是一组属性，比如姓名、年龄、性别加起来作为一个主键

-  例子： 

- 例如一个人，身份证号码可以作为他的唯一标示，也就是主键
- 例如一台电视，品牌、型号、序列号加起来可以作为它的唯一标示，也就是主键

-  b、什么是外键 

-  解释： 

- 在自己的表中，有一个字段，可以确定另一张表的数据的唯一性，叫外键
- 这个字段，对另一张表来说，叫主键，对自己的这张表来说，叫外键
- a表与b表，a表中的某一个字段可以区分b表的每一条数据，这个字段就是a表的外键，是b表的主键

-  例子： 

- 比如一件快递包裹
- 在天猫商家的系统里，有这个包裹的购买人id、订单号、电话、快递单号等信息，主键是订单号，通过订单号区分每一个订单
- 在快递公司的系统里，有这个包裹的快递单号、收件人、电话、地址等信息，主键是快递单号，通过快递单号区分每一个包裹
- 对快递公司来说，这个快递单号是主键
- 对天猫商家来说，这个快递单号是外键
- 我通过订单号可以查到所有订单信息，然后从中找到快递单号，然后在快递表里查快递单号，就可以查到包裹的物流信息

-  c、区别 

-  主键 

- 唯一标识一条记录，不能有重复的，不允许为空
- 用来保证数据完整性
- 一张表主键只能有一个

-  外键 

- 表的外键是给另一张表使用的，这个外键在另一张表里可以重复,可以是空值。但是在自己表里必须是唯一的，不然你怎么么代表自己表里的一条数据
- 用来和其他表创建联系用的
- 一个表可以有多个外键

- 
4、一对一

- 
a、单向一对一主键关联

- 简单来说，我的主键，就是我的外键，也就是你的主键，一样的值
- 单向的意思就是，只可以我用我的外键查你，你不查我

- 
b、双向一对一主键关联

- 简单来说，我的主键，就是我的外键，也就是你的主键，一样的值
- 双向的意思就是，我可以查你，你可以查我

- 
c、单向一对一外键关联
{% endraw %}
