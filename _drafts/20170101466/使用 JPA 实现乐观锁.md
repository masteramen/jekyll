---
layout: post
title:  "使用 JPA 实现乐观锁"
title2:  "使用 JPA 实现乐观锁"
date:   2017-01-01 23:59:26  +0800
source:  "http://www.jfox.info/%e4%bd%bf%e7%94%a8jpa%e5%ae%9e%e7%8e%b0%e4%b9%90%e8%a7%82%e9%94%81.html"
fileName:  "20170101466"
lang:  "zh_CN"
published: true
permalink: "%e4%bd%bf%e7%94%a8jpa%e5%ae%9e%e7%8e%b0%e4%b9%90%e8%a7%82%e9%94%81.html"
---
{% raw %}
乐观锁的概念就不再赘述了，不了解的朋友请自行百度谷歌之，今天主要说的是在项目中如何使用乐观锁，做成一个小demo。

持久层使用jpa时，默认提供了一个注解@Version先看看源码怎么描述这个注解的。

    /**
     * Specifies the version field or property of an entity class that
     * serves as its optimistic lock value.  The version is used to ensure
     * integrity when performing the merge operation and for optimistic
     * concurrency control.
     *
     * <p> Only a single <code>Version</code> property or field
     * should be used per class; applications that use more than one
     * <code>Version</code> property or field will not be portable.
     *
     * <p> The <code>Version</code> property should be mapped to
     * the primary table for the entity class; applications that
     * map the <code>Version</code> property to a table other than
     * the primary table will not be portable.
     *
     * <p> The following types are supported for version properties:
     * <code>int</code>, <code>Integer</code>, <code>short</code>,
     * <code>Short</code>, <code>long</code>, <code>Long</code>,
     * <code>java.sql.Timestamp</code>.
     *
     * <pre>
     *    Example:
     *
     *    @Version
     *    @Column(name="OPTLOCK")
     *    protected int getVersionNum() { return versionNum; }
     * </pre>
     *
     * @since Java Persistence 1.0
     */
    @Target({ METHOD, FIELD })
    @Retention(RUNTIME)
    public @interface Version {
    }

简单来说就是用一个version字段来充当乐观锁的作用。
先来设计实体类

    /**
     * Created by xujingfeng on 2017/1/30.
     */
    @Entity
    @Table(name = "t_student")
    public class Student {
    
        @Id
        @GenericGenerator(name = "PKUUID", strategy = "uuid2")
        @GeneratedValue(generator = "PKUUID")
        @Column(length = 36)
        private String id;
    
        @Version
        private int version;
    
        private String name;
    
        //getter()...
        //setter()...
    }

Dao层

    /**
     * Created by xujingfeng on 2017/1/30.
     */
    public interface StudentDao extends JpaRepository<Student,String>{
    
        @Query("update Student set name=?1 where id=?2")
        @Modifying
        @Transactional
        int updateNameById(String name,String id);
    }

Controller层充当单元测试的作用，通过访问一个requestMapping来触发我们想要测试的方法。

    /**
     * Created by xujingfeng on 2017/1/30.
     */
    @Controller
    public class StudentController {
    
        @Autowire
{% endraw %}
