---
layout: post
title:  "慕课网_《Hibernate初探之多对多映射》学习总结"
title2:  "慕课网_《Hibernate初探之多对多映射》学习总结"
date:   2017-01-01 23:56:12  +0800
source:  "https://www.jfox.info/%e6%85%95%e8%af%be%e7%bd%91hibernate%e5%88%9d%e6%8e%a2%e4%b9%8b%e5%a4%9a%e5%af%b9%e5%a4%9a%e6%98%a0%e5%b0%84%e5%ad%a6%e4%b9%a0%e6%80%bb%e7%bb%93.html"
fileName:  "20170101272"
lang:  "zh_CN"
published: true
permalink: "2017/%e6%85%95%e8%af%be%e7%bd%91hibernate%e5%88%9d%e6%8e%a2%e4%b9%8b%e5%a4%9a%e5%af%b9%e5%a4%9a%e6%98%a0%e5%b0%84%e5%ad%a6%e4%b9%a0%e6%80%bb%e7%bb%93.html"
---
{% raw %}
# 慕课网_《Hibernate初探之多对多映射》学习总结 


## 1-1 多对多的应用场景

案例分析：企业项目开发过程中

    一个项目可由多个员工参与开发
    一个员工可同时参与开发多个项目

示意图

![](/wp-content/uploads/2017/07/1500042442.png)

多对多关联

    多对多关联关系也是常见的一种关联关系，如项目和员工之间就是典型的多对多关系
    多对多关联关系一般采用中间表的形式来实现，即新增一张包含关联双方主键的关联表
    多对多关联可以使用<set>元素和<many-to-many>元素进行配置
    

# 第二章：配置案例

## 2-1 创建项目和表

创建一个maven项目，名为hibernatemtm，POM文件如下

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <groupId>com.myimooc</groupId>
        <artifactId>hibernatemtm</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>jar</packaging>
    
        <name>hibernatemtm</name>
        <url>http://maven.apache.org</url>
    
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        </properties>
    
        <dependencies>
            <!-- https://mvnrepository.com/artifact/org.hibernate/hibernate-core -->
            <dependency>
                <groupId>org.hibernate</groupId>
                <artifactId>hibernate-core</artifactId>
                <version>4.3.0.Final</version>
            </dependency>
    
            <!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>5.1.38</version>
            </dependency>
            
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>3.8.1</version>
                <scope>test</scope>
            </dependency>
        </dependencies>
    
        <build>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <configuration>
                        <source>1.8</source>
                        <target>1.8</target>
                    </configuration>
                </plugin>
            </plugins>
        </build>
        
    </project>
    

创建表

    create table project
    (
        proid int primary key,
        proname varchar(20) not null
    );
    
    create table employee
    (
        empid int primary key,
        empname varchar(20)
    );
    
    create table proemp
    (
        rproid int,
        rempid int
    );
    
    alter table proemp add constraint fk_rproid 
        foreign key (rproid) references project(proid);
    alter table proemp add constraint fk_rempid
        foreign key (rempid) references employee(empid);    
        
     

## 2-2 持久化类

代码演示

1.编写Project类

    package com.myimooc.hibernatemtm.entity;
    
    import java.io.Serializable;
    import java.util.HashSet;
    import java.util.Set;
    
    /**
     * project 实体类
     * @author ZhangCheng on 2017-07-11
     *
     */
    public class Project implements Serializable{
        
        private static final long serialVersionUID = 1L;
    
        private int proid;
        
        private String proname;
        
        // 添加一个员工的集合
        private Set<Employee> employees = new HashSet<Employee>();
    
        public Project() {
        }
    
        public Project(int proid, String proname) {
            this.proid = proid;
            this.proname = proname;
        }
    
        public Project(int proid, String proname, Set<Employee> employees) {
            this.proid = proid;
            this.proname = proname;
            this.employees = employees;
        }
    
        @Override
        public String toString() {
            return "Project [proid=" + proid + ", proname=" + proname + ", employees=" + employees + "]";
        }
    
        public int getProid() {
            return proid;
        }
    
        public void setProid(int proid) {
            this.proid = proid;
        }
    
        public String getproname() {
            return proname;
        }
    
        public void setproname(String proname) {
            this.proname = proname;
        }
    
        public Set<Employee> getEmployees() {
            return employees;
        }
    
        public void setEmployees(Set<Employee> employees) {
            this.employees = employees;
        }
        
        
    }
    

2.编写Employee类

    package com.myimooc.hibernatemtm.entity;
    
    import java.io.Serializable;
    import java.util.HashSet;
    import java.util.Set;
    
    /**
     * employee 实体类
     * @author ZhangCheng on 2017-07-11
     *
     */
    public class Employee implements Serializable{
        
        private static final long serialVersionUID = 1L;
    
        private int empid;
        
        private String empname;
        
        // 添加一个项目的集合
        private Set<Project> projects = new HashSet<Project>();
    
        public Employee() {
        }
    
        public Employee(int empid, String empname) {
            this.empid = empid;
            this.empname = empname;
        }
    
        public Employee(int empid, String empname, Set<Project> projects) {
            this.empid = empid;
            this.empname = empname;
            this.projects = projects;
        }
    
        @Override
        public String toString() {
            return "Employee [empid=" + empid + ", empname=" + empname + ", projects=" + projects + "]";
        }
    
        public int getEmpid() {
            return empid;
        }
    
        public void setEmpid(int empid) {
            this.empid = empid;
        }
    
        public String getEmpname() {
            return empname;
        }
    
        public void setEmpname(String empname) {
            this.empname = empname;
        }
    
        public Set<Project> getProjects() {
            return projects;
        }
    
        public void setProjects(Set<Project> projects) {
            this.projects = projects;
        }
    
    }
    

## 2-3 配置映射文件

代码演示

1.编写Project.hbm.xml文件

    <?xml version="1.0"?>
    <!DOCTYPE hibernate-mapping PUBLIC 
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
    <hibernate-mapping>
        <class name="com.myimooc.hibernatemtm.entity.Project" table="project">
            <id name="proid" column="proid" type="java.lang.Integer">
                <generator class="assigned"></generator>
            </id>
            <property name="proname" type="java.lang.String">
                <column name="proname" length="20" not-null="true"></column>
            </property>
            <!-- 配置多对多关联关系 -->
            <set name="employees" table="proemp" cascade="all">
                <key column="rproid"></key>
                <many-to-many class="com.myimooc.hibernatemtm.entity.Employee" column="rempid"></many-to-many>
            </set>
        </class>
        
    </hibernate-mapping>
    

2.编写Employee.hbm.xml文件

    <?xml version="1.0"?>
    <!DOCTYPE hibernate-mapping PUBLIC 
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
    <hibernate-mapping>
        <class name="com.myimooc.hibernatemtm.entity.Employee" table="employee">
            <id name="empid" column="empid" type="java.lang.Integer">
                <generator class="assigned"></generator>
            </id>
            <property name="empname" type="java.lang.String">
                <column name="empname" length="20" not-null="true"></column>
            </property>
            <!-- 配置多对多关联关系 -->
            <set name="projects" table="proemp" inverse="true">
                <key column="rempid"></key>
                <many-to-many class="com.myimooc.hibernatemtm.entity.Project" column="rproid"></many-to-many>
            </set>
        </class>
    </hibernate-mapping>
    

3.编写hibernate.cfg.xml文件

    <!DOCTYPE hibernate-configuration PUBLIC
            "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
            "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
    
    <hibernate-configuration>
        <session-factory>
            <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
            <property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
            <property name="hibernate.connection.username">root</property>
            <property name="hibernate.connection.password">root</property>
            <property name="hibernate.connection.url">
                <![CDATA[
                    jdbc:mysql://localhost:3306/hibernatemtm?useUnicode=true&characterEncoding=utf8
                ]]>
            </property>
            <property name="show_sql">true</property>
            <property name="hbm2ddl.auto">update</property>
            
            <!-- 指定映射文件的路径 -->
            <mapping resource="com/myimooc/hibernatemtm/entity/Project.hbm.xml"/> 
            <mapping resource="com/myimooc/hibernatemtm/entity/Employee.hbm.xml"/>
            
        </session-factory>
    </hibernate-configuration>

## 2-4 测试

代码演示

1.编写HibernateUtil类

    package com.myimooc.hibernatemtm.util;
    
    /**
     * session会话工具类
     * @author ZhangCheng on 2017-07-11
     *
     */
    import org.hibernate.Session;
    import org.hibernate.SessionFactory;
    import org.hibernate.boot.registry.StandardServiceRegistry;
    import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
    import org.hibernate.cfg.Configuration;
    
    public class HibernateUtil {
        
        private static SessionFactory sessionFactory;
        
        private static Session session;
    
        static {
            // 创建Configuration对象，读取hibernate.cfg.xml文件，完成初始化
            Configuration config = new Configuration().configure();
            StandardServiceRegistryBuilder ssrb = new StandardServiceRegistryBuilder()
                    .applySettings(config.getProperties());
            StandardServiceRegistry ssr=ssrb.build();
            sessionFactory=config.buildSessionFactory(ssr);
        }
        
        /**
         * 获取SessionFactory
         * @return
         */
        public static SessionFactory getSessionFactory(){
            return sessionFactory;
        }
        
        /**
         * 获取Session
         * @return
         */
        public static Session getSession(){
            session=sessionFactory.openSession();
            return session;
        }
        
        /**
         * 关闭Session
         * @param session
         */
        public static void closeSession(Session session){
            if(session!=null){
                session.close();
            }
        }
    }
    

2.编写Test类

    package com.myimooc.hibernatemtm.test;
    
    import org.hibernate.Session;
    import org.hibernate.Transaction;
    
    import com.myimooc.hibernatemtm.entity.Employee;
    import com.myimooc.hibernatemtm.entity.Project;
    import com.myimooc.hibernatemtm.util.HibernateUtil;
    
    /**
     * 多对多关联关系的配置
     * 同时创建了Project和Employee之间的双向多对多关联关系
     * 关联关系的维护交由Project方来处理，并且在保存Project对象时会一并保存Employee对象
     * @author ZhangCheng on 2017-07-11
     */
    public class Test {
        public static void main(String[] args) {
            Project project1=new Project(1001,"项目一");
            Project project2=new Project(1002,"项目二");
            Employee employee1=new Employee(1,"慕女神");
            Employee employee2=new Employee(2,"imooc");
            
            //参加项目1的员工有慕女神和imooc
            project1.getEmployees().add(employee1);
            project1.getEmployees().add(employee2);
            // 参加项目2的员工有慕女神
            project2.getEmployees().add(employee1);
            
            Session session=HibernateUtil.getSession();
            Transaction tx=session.beginTransaction();
            session.save(project1);
            session.save(project2);
            tx.commit();
            HibernateUtil.closeSession(session);
        }
    }
    

# 第三章：课程总结

## 3-1 多对多总结

课程总结

    实现多对多关联关系
    在数据库底通过添加中间表来指定关联关系
        在双方的实体中添加一个保存对方的集合
        在双方的映射文件中使用<set>元素和<many-to-many>元素进行关联关系的配置
{% endraw %}
