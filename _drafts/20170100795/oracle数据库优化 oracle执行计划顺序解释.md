---
layout: post
title:  "oracle数据库优化 oracle执行计划顺序解释"
title2:  "oracle数据库优化 oracle执行计划顺序解释"
date:   2017-01-01 23:48:15  +0800
source:  "http://www.jfox.info/oracle-shu-ju-ku-you-hua-oracle-zhi-xing-ji-hua-shun-xu-jie-shi.html"
fileName:  "20170100795"
lang:  "zh_CN"
published: true
permalink: "oracle-shu-ju-ku-you-hua-oracle-zhi-xing-ji-hua-shun-xu-jie-shi.html"
---
{% raw %}
关于oracle执行计划，网上很多说法都是，先执行最大缩进的行，如果缩进相同，就先执行上面的行，也就是最右最上原则。

按照这个原则，下面最先执行的是这一行

**INDEX FULL SCAN INDEX (UNIQUE) **SYS.I_USER2 Cost: 1 Bytes: 735 Cardinality: 35

 **Plan**
 
**SELECT STATEMENT **ALL_ROWS Cost: 49 Bytes: 194,769 Cardinality: 11,457
 
** ****VIEW VIEW **SYS.DBA_OBJECTS Cost: 49 Bytes: 194,769 Cardinality: 11,457
  
** ****UNION-ALL**
   
**FILTER **
    
** ****HASH JOIN **Cost: 48 Bytes: 1,486,192 Cardinality: 12,812
     
** ****TABLE ACCESS FULL ****CLUSTER **SYS.USER$ Cost: 2 Bytes: 630 Cardinality: 35
     
** ****HASH JOIN **Cost: 45 Bytes: 1,255,576 Cardinality: 12,812
      
*** ******INDEX FULL SCAN INDEX (UNIQUE) ******SYS.I_USER2 ******Cost: 1 Bytes: 735 Cardinality: 35 ***
      
** ****TABLE ACCESS FULL ****TABLE **SYS.OBJ$ Cost: 44 Bytes: 986,524 Cardinality: 12,812
    
** ****TABLE ACCESS BY INDEX ROWID CLUSTER **SYS.IND$ Cost: 2 Bytes: 8 Cardinality: 1
     
** ****INDEX UNIQUE SCAN INDEX (UNIQUE) **SYS.I_IND1 Cost: 1 Cardinality: 1
    
** ****NESTED LOOPS **Cost: 2 Bytes: 28 Cardinality: 1
     
** ****INDEX FULL SCAN INDEX (UNIQUE) **SYS.I_USER2 Cost: 1 Bytes: 19 Cardinality: 1
     
** ****INDEX RANGE SCAN INDEX **SYS.I_OBJ4 Cost: 1 Bytes: 9 Cardinality: 1
   
** ****NESTED LOOPS **Cost: 1 Bytes: 31 Cardinality: 1
    
** ****INDEX FULL SCAN INDEX **SYS.I_LINK1 Cost: 0 Bytes: 13 Cardinality: 1
    
** ****TABLE ACCESS CLUSTER CLUSTER **SYS.USER$ Cost: 1 Bytes: 18 Cardinality: 1
     
** ****INDEX UNIQUE SCAN INDEX (CLUSTER) **SYS.I_USER# Cost: 0 Cardinality: 1

那么实际的执行计划是什么？通过toad来看下，实际最先执行的是

***1 ******TABLE ACCESS FULL ******CLUSTER ******SYS.USER$ ******Cost: 2 Bytes: 630 Cardinality: 35 ***

**Plan**

**SELECT STATEMENT **ALL_ROWS Cost: 49 Bytes: 194,769 Cardinality: 11,457
 
**17 ****VIEW VIEW **SYS.DBA_OBJECTS Cost: 49 Bytes: 194,769 Cardinality: 11,457
  
**16 ****UNION-ALL **
   
**11 ****FILTER **
    
**5 ****HASH JOIN **Cost: 48 Bytes: 1,486,192 Cardinality: 12,812
     
***1 ******TABLE ACCESS FULL ******CLUSTER ******SYS.USER$ ******Cost: 2 Bytes: 630 Cardinality: 35 ***
     
**4 ****HASH JOIN **Cost: 45 Bytes: 1,255,576 Cardinality: 12,812
      
**2 ****INDEX FULL SCAN INDEX (UNIQUE) **SYS.I_USER2 Cost: 1 Bytes: 735 Cardinality: 35
      
**3 ****TABLE ACCESS FULL ****TABLE **SYS.OBJ$ Cost: 44 Bytes: 986,524 Cardinality: 12,812
    
**7 ****TABLE ACCESS BY INDEX ROWID CLUSTER **SYS.IND$ Cost: 2 Bytes: 8 Cardinality: 1
     
**6 ****INDEX UNIQUE SCAN INDEX (UNIQUE) **SYS.I_IND1 Cost: 1 Cardinality: 1
    
**10 ****NESTED LOOPS **Cost: 2 Bytes: 28 Cardinality: 1
     
**8 ****INDEX FULL SCAN INDEX (UNIQUE) **SYS.I_USER2 Cost: 1 Bytes: 19 Cardinality: 1
     
**9 ****INDEX RANGE SCAN INDEX **SYS.I_OBJ4 Cost: 1 Bytes: 9 Cardinality: 1
   
**15 ****NESTED LOOPS **Cost: 1 Bytes: 31 Cardinality: 1
    
**12 ****INDEX FULL SCAN INDEX **SYS.I_LINK1 Cost: 0 Bytes: 13 Cardinality: 1
    
**14 ****TABLE ACCESS CLUSTER CLUSTER **SYS.USER$ Cost: 1 Bytes: 18 Cardinality: 1
     
**13 ****INDEX UNIQUE SCAN INDEX (CLUSTER) **SYS.I_USER# Cost: 0 Cardinality: 1

在执行过程中，先要执行子步骤，子步骤执行完成之后再执行父步骤

如下面：

**5 ****HASH JOIN **Cost: 48 Bytes: 1,486,192 Cardinality: 12,812

***1 ******TABLE ACCESS FULL ******CLUSTER ******SYS.USER$ ******Cost: 2 Bytes: 630 Cardinality: 35 ***

**4 ****HASH JOIN **Cost: 45 Bytes: 1,255,576 Cardinality: 12,812
 
**2 ****INDEX FULL SCAN INDEX (UNIQUE) **SYS.I_USER2 Cost: 1 Bytes: 735 Cardinality: 35
{% endraw %}
