---
layout: post
title:  "solr6.6搜索环境搭建、IK中文分词、同义词、拼音、solrj的使用"
title2:  "solr6.6搜索环境搭建、IK中文分词、同义词、拼音、solrj的使用"
date:   2017-01-01 23:53:58  +0800
source:  "http://www.jfox.info/solr66%e6%90%9c%e7%b4%a2%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%baik%e4%b8%ad%e6%96%87%e5%88%86%e8%af%8d%e5%90%8c%e4%b9%89%e8%af%8d%e6%8b%bc%e9%9f%b3solrj%e7%9a%84%e4%bd%bf%e7%94%a8.html"
fileName:  "20170101138"
lang:  "zh_CN"
published: true
permalink: "solr66%e6%90%9c%e7%b4%a2%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%baik%e4%b8%ad%e6%96%87%e5%88%86%e8%af%8d%e5%90%8c%e4%b9%89%e8%af%8d%e6%8b%bc%e9%9f%b3solrj%e7%9a%84%e4%bd%bf%e7%94%a8.html"
---
{% raw %}
2017-06-20 Apache官网发布了solr6.6版本下载地址
    下载地址:[https://mirrors.tuna.tsinghua.edu.cn/apache/lucene/solr/6.6.0/](http://www.jfox.info/go.php?url=https://mirrors.tuna.tsinghua.edu.cn/apache/lucene/solr/6.6.0/)

**solr6.6搜索环境搭建、IK中文分词同义词拼音solrj的使用
**
**部署环境**:Tomcat8

**solr版本**:6.6

**jdk**:1.8

solr配置:

    解压solr,将目录solr-6.6.0serversolr-webapp下了webapp文件夹拷贝至
    Tomcat的webapp目录下.改名为solr

    将olr-6.6.0/server/lib/ext中所有jar包拷贝至webappssolrWEB-INFlib下,
    将solr-6.6.0distsolrj-lib下的noggit-0.6.jar拷贝至webappssolrWEB-INFlib下,
    将olr-6.6.0/server/lib/中所有以metrics-开头jar包拷贝至webappssolrWEB-INF lib下, 在WEB-INF下件新建classes文件夹,然后将solr-6.6.0serverresources中 log4j.properties拷贝至classes下.

![](/wp-content/uploads/2017/07/1499354921.png)  
 
 
 
    将solr-6.6.0server目录下solr文件拷贝至任意位置.(我这里是G:solrhome)改名
    为solrhome.作为索引存放位置

    在solr目录下,新建collection1文件夹,并将 /solr-6.6.0/server/solr/configsets/basic_configs
    中conf文件夹复制到新建的collection1文件夹中.在collection1目录下新建data文件夹.
    创建文件core.properties,写入内容

    name=collection1
    config=solrconfig.xml
    schema=schema.xml
    dataDir=data

 
![](/wp-content/uploads/2017/07/14993549211.png)

    回到Tomcat目录下,打开webappssolrWEB-INFweb.xml文件.打开被注释的<env-entry>,
    修改路径为solrhome的路径

        <env-entry>
           <env-entry-name>solr/home</env-entry-name>
           <env-entry-value>G:solrhome</env-entry-value>
           <env-entry-type>java.lang.String</env-entry-type>
        </env-entry>
    

 
 

   将底部注释掉; 
 
![](/wp-content/uploads/2017/07/1499354922.png)  
 

访问[ localhost:8080/solr/index.html]( localhost:8080/solr/index.html)
![](/wp-content/uploads/2017/07/1499354923.png)  
 

  接下来就是配置 
 IK中文分析器:
solr本身带有中文分词器,不过其不支持自己添加词汇,选用IK分词器,不过IK在2012年已经停止更新了,

但是这里附件提供了最新的IK支持.

将两个jar包复制到solrWEB-INFlib下,将IKAnalyzer.cfg.xml、ext.dic、stopword.dic

三个文件复制到solrWEB-INFclasses下ext.dic文件里为自定义的扩展词汇,

stopword为自定义的停用词

    接下来开始定义fieldType和field将下面代码复制到solrhome的olrhomecollection1conf目录下
    managed-schema文件里.这里配置包含了后面的近义词,(近义词后面说)

    <fieldType name="text_ik" class="solr.TextField">
        <analyzer type="index">
    	<tokenizer class="org.wltea.analyzer.lucene.IKTokenizerFactory" isMaxWordLength="false" useSmart="false" />
    	<filter class="solr.LowerCaseFilterFactory" />
        </analyzer>
    	<analyzer type="query">
    		<tokenizer class="org.wltea.analyzer.lucene.IKTokenizerFactory"
     isMaxWordLength="false" useSmart="false" />
    		<filter class="solr.SynonymFilterFactory" synonyms="synonyms.txt"
     ignoreCase="true" expand="true" />
    		<filter class="solr.LowerCaseFilterFactory" />
    	</analyzer>
    </fieldType>

 这个时候就可以测试一下是否成功了.

 
![](/wp-content/uploads/2017/07/1499354924.png)
已经成功分词了..

针对企业级应用就要配置自定义的Field.此处不做详细描述.在managed-schema文件中添加就是.

这里提供一个示例,一般情况是根据实际情况分配.此示例仅供参考.

注意:需要对其中文分词提供搜索type属性必须为前面配置的IK名一样.

唯一索引id在solr中就叫ID并且是必须字段,所以不需单独配置

    <!--product-->
       <field name="product_name" type="text_ik" indexed="true" stored="true"/>
       <field name="product_price"  type="float" indexed="true" stored="true"/>
       <field name="product_description" type="text_ik" indexed="true" stored="false" />
       <field name="product_picture" type="string" indexed="false" stored="true" />
       <field name="product_catalog_name" type="string" indexed="true" stored="true" />
       <field name="product_keywords" type="text_ik" indexed="true" stored="false" multiValued="true"/>
       <copyField source="product_name" dest="product_keywords"/>
       <copyField source="product_description" dest="product_keywords"/>
    

 用product_keywords作为默认的搜索域,搜索时联合product_name和product_description进行搜索
 

    
 

  利用 
 solr提供的客户端开始关联数据库.实现批量数据的导入. 
 
 
 
    <requestHandler name="/dataimport" 
    class="org.apache.solr.handler.dataimport.DataImportHandler">
        <lst name="defaults">
          <str name="config">data-config.xml</str>
         </lst>
      </requestHandler> 

 在同级目录下创建data-config.xml文件,我这里用的mysql,field为配置field的映射,column为数据库字段名.name为前面自定义field的name注意:根据实际情况配置
    <?xml version="1.0" encoding="UTF-8" ?>  
    <dataConfig>   
    <dataSource type="JdbcDataSource"   
    		  driver="com.mysql.jdbc.Driver"   
    		  url="jdbc:mysql://localhost:3306/solrDemo"   
    		  user="root"   
    		  password="root"/>   
    <document>   
    	<entity name="product" query="SELECT pid,name,catalog_name,price,description,picture FROM products ">
    		 <field column="pid" name="id"/> 
    		 <field column="name" name="product_name"/> 
    		 <field column="catalog_name" name="product_catalog_name"/> 
    		 <field column="price" name="product_price"/> 
    		 <field column="description" name="product_description"/> 
    		 <field column="picture" name="product_picture"/> 
    	</entity>   
    </document>   
    </dataConfig>
    

 将solr-6.6.0dist目录下的solr-dataimporthandler-6.6.0.jar和solr-dataimporthandler-extras-6.6.0.jar复制到solr/WEB-INF/lib下,在solrhomecollection1confsolrconfig.mxl配置<lib dir=”solr的lib路径>原先为相对路径在solr6.6文件里寻找,这样方便管理,并且不会因为路径更换十取包的依赖.
![](/wp-content/uploads/2017/07/1499354926.png)
然后打开客户端,点击Execute,如下:
注意:如果不勾选 Auto-Refresh Status 不会提示是否全部创建索引成功,点击右边Refresh 刷新
entity是data-config.xml里面的entity
![](/wp-content/uploads/2017/07/1499354927.png)
接下来就可以点击 Query 进行查询了.这里不做演示.
注意:因为中文分词缘故,已经被分为词语储存,进行单个字查询的时候会出现查不到的结果.

解决方案一(不推荐):将所有单个字作为扩展词,缺点:分的过于细,会影响搜索结果.出现不愿出现的结果

解决方案二:使用通配符 *. 

近义词配置:前面配置IK已经配置了近义词了,前面配置的是在查询时

会使用近义词查询,并没有配置创建索引时创建近义词索引.那么现在就开始

添加近义词了.在managed-schema同级目录下的synonyms.txt里,

 如图,搜索房产,地产,不动产任意一个,则三个结果都会出现.
![](/wp-content/uploads/2017/07/14993549271.png)

拼音配置:

方案一:直接使用solr分词实现.就在原先IK配置上加上

    <filter class="com.shentong.search.analyzers.PinyinTransformTokenFilterFactory" minTermLenght="2" />
    <filter class="com.shentong.search.analyzers.PinyinNGramTokenFilterFactory" minGram="1" maxGram="20" />

具体属性意义不做讲解.不过此种方式有弊端.就是多音字.

例如:重庆 默认为zhongqing所以如果要使用的,最好修改它的源码了,这里

提供了修改好的jar包 pinyinTokenFilter-1.1.0-RELEASE.jar 支持依赖solr6.6,

主要是针对多音字被舍去的问题,以及简拼和全拼不能兼得的问题.

具体修改步骤就不阐述了,因为做的不够完善.当然也可以自己修改制定.

将pinyinTokenFilter-1.1.0-RELEASE.jar和pinyinAnalyzer4.3.1.jar和pinyin4j-2.5.0.jar

复制到solr/WEB-INF/lib目录下

修改后的属性介绍:

pinyin:属性是指全拼音,如重庆:chognqing,zhongqing默认为true,

isFirstChar:属性�
{% endraw %}
