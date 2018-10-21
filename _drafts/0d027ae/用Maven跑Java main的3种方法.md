---
layout: post
title:  "用Maven跑Java main的3种方法"
title2:  "用Maven跑Java main的3种方法"
date:   2018-10-18 04:03:29  +0800
source:  "https://blog.csdn.net/qiyueqinglian/article/details/50595989"
fileName:  "0d027ae"
lang:  "zh_CN"
published: false

---
{% raw %}
## 概述

Maven exec plugin可以使我们运行自己工程的Java类的main方法，并在classpath里自动包含工程的dependencies。本文用示例代码展示了使用maven exec plugin来运行java main方法的3种方法。

## 1) 在命令行（Command line）运行

用这种方式运行的话，并没有在某个maven phase中，所以你首先需要compile（编译）一下代码。 
请记住exec:java不会自动编译代码，需要先编译才行。

    mvn compile

编译完成后，用以下命令运行java main方法

### 不带参数跑：

    mvn exec:java -Dexec.mainClass="com.vineetmanohar.module.Main"

### 带参数跑：

    mvn exec:java -Dexec.mainClass="com.vineetmanohar.module.Main" -Dexec.args="arg0 arg1 arg2"

    mvn exec:java -Dexec.mainClass="com.vineetmanohar.module.Main" -Dexec.classpathScope=runtime

## 2) 在pom.xml文件的某个phase里运行

也可以在maven的某个phase里运行main方法。比如，作为test phase的一部分运行CodeGenerator.main()方法

    <build><plugins><plugin><groupId>org.codehaus.mojo</groupId><artifactId>exec-maven-plugin</artifactId><version>1.1.1</version><executions><execution><phase>test</phase><goals><goal>java</goal></goals><configuration><mainClass>com.vineetmanohar.module.CodeGenerator</mainClass><arguments><argument>arg0</argument><argument>arg1</argument></arguments></configuration></execution></executions></plugin></plugins></build>

用以上配置运行exec plugin，运行相应的phase就行了。

    mvn test

## 3) 在pom.xml文件的某个profile运行

也可以用不同的profile运行main方法。只要用`<profile>`标签包裹住以上配置就行。

    <profiles><profile><id>code-generator</id><build><plugins><plugin><groupId>org.codehaus.mojo</groupId><artifactId>exec-maven-plugin</artifactId><version>1.1.1</version><executions><execution><phase>test</phase><goals><goal>java</goal></goals><configuration><mainClass>com.vineetmanohar.module.CodeGenerator</mainClass><arguments><argument>arg0</argument><argument>arg1</argument></arguments></configuration></execution></executions></plugin></plugins></build></profile></profiles>

调用以上profile，运行以下命令就行：

    mvn test -Pcode-generator

## 高级选项

你可以通过以下命令来查看所有参数的列表：

    mvn exec:help -Ddetail=true -Dgoal=java 

### arguments (exec.arguments)

The class arguments.(类参数) 

### classpathScope (exec.classpathScope, Default: compile)

  Defines the scope of the classpath passed to the plugin. Set to 

  compile, test, runtime or system depending on your needs 
  定义传递给plugin的classpath的scope。根据需要设置为 compile, test, runtime 或system。
### cleanupDaemonThreads (exec.cleanupDaemonThreads)

Wether to interrupt/join and possibly stop the daemon threads upon 
quitting.  If this is false, maven does nothing about the daemon threads. 
When maven has no more work to do, the VM will normally terminate any 
remaining daemon threads. 
In certain cases (in particular if maven is embedded), you might need to 
keep this enabled to make sure threads are properly cleaned up to ensure 
they don’t interfere with subsequent activity. In that case, see 
daemonThreadJoinTimeout and stopUnresponsiveDaemonThreads for further 
tuning.

### commandlineArgs (exec.args)

Arguments for the executed program 

  This defines the number of milliseconds to wait for daemon threads to quit 

  following their interruption. This is only taken into account if 

  cleanupDaemonThreads is true. A value <=0 means to not timeout (i.e. wait 

  indefinitely for threads to finish). Following a timeout, a warning will 

  be logged. Note: properly coded threads should terminate upon interruption 

  but some threads may prove problematic: as the VM does interrupt daemon 

  threads, some code may not have been written to handle interruption 

  properly. For example java.util.Timer is known to not handle interruptions 

  in JDK <= 1.6. So it is not possible for us to infinitely wait by default 

  otherwise maven could hang. A sensible default value has been chosen, but 
  this default value may change in the future based on user feedback.
### executableDependency

If provided the ExecutableDependency identifies which of the plugin 
dependencies contains the executable class. This will have the affect of 
only including plugin dependencies required by the identified 
ExecutableDependency. 
If includeProjectDependencies is set to true, all of the project 
dependencies will be included on the executable’s classpath. Whether a 
particular project dependency is a dependency of the identified 
ExecutableDependency will be irrelevant to its inclusion in the classpath.

### includePluginDependencies (exec.includePluginDependencies, Default: false)

Indicates if this plugin’s dependencies should be used when executing the 
main class. This is useful when project dependencies are not appropriate. Using 
only the plugin dependencies can be particularly useful when the project is not 
a java project. For example a mvn project using the csharp plugins only expects 
to see dotnet libraries as dependencies.

### includeProjectDependencies (exec.includeProjectDependencies, Default: true)

Indicates if the project dependencies should be used when executing the 
main class.

### mainClass (exec.mainClass)

The main class to execute.

### sourceRoot (sourceRoot)

This folder is added to the list of those folders containing source to be 
compiled. Use this if your plugin generates source code.

### stopUnresponsiveDaemonThreads (exec.stopUnresponsiveDaemonThreads)

Wether to call Thread.stop() following a timing out of waiting for an 
interrupted thread to finish. This is only taken into account if 
cleanupDaemonThreads is true and the daemonThreadJoinTimeout threshold has 
been reached for an uncooperative thread. If this is false, or if 
Thread.stop() fails to get the thread to stop, then a warning is logged 
and Maven will continue on while the affected threads (and related objects 
in memory) linger on. Consider setting this to true if you are invoking 
problematic code that you can’t fix. An example is Timer which doesn’t 
respond to interruption. To have Timer fixed, vote for this bug.

### systemProperties

A list of system properties to be passed. Note: as the execution is not 
forked, some system properties required by the JVM cannot be passed here. 
Use MAVEN_OPTS or the exec:exec instead. See the user guide for more 
information.

### testSourceRoot (testSourceRoot)

This folder is added to the list of those folders containing source to be 
compiled for testing. Use this if your plugin generates test source code.

## 问题和错误

为什么在给main方法指定arguments时遇到以下错误呢？

    [ERROR] BUILD ERROR   [INFO]  [INFO] Failed to configure plugin parameters for: org.codehaus.mojo:exec-maven-plugin:1.1.1onthe command line, specify: '-Dexec.arguments=VALUE'   Cause: Cannot assign configuration entry 'arguments' to 'class [Ljava.lang.String;' from '${exec.arguments}',    which isof type class java.lang.String   [INFO]  [INFO] Trace   org.apache.maven.lifecycle.LifecycleExecutionException: Error configuring: org.codehaus.mojo:exec-maven-plugin.    Reason: Unable to parse the created DOM for plugin configuration    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.executeGoals(DefaultLifecycleExecutor.java:588)    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.executeStandaloneGoal(DefaultLifecycleExecutor.java:513)    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.executeGoal(DefaultLifecycleExecutor.java:483)    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.executeGoalAndHandleFailures(DefaultLifecycleExecutor.java:331)    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.executeTaskSegments(DefaultLifecycleExecutor.java:292)    at org.apache.maven.lifecycle.DefaultLifecycleExecutor.execute(DefaultLifecycleExecutor.java:142)    at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:336)    at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:129)    at org.apache.maven.cli.MavenCli.main(MavenCli.java:301)  

### 解决办法：

exec.arguments在exec plugin的1.1版本之前使用，它不支持命令行String到String[] array的转换

1. 如果可以，升级该插件到1.1或更高，使用exec.args而不是exec.arguments
2. 如果你不能升级插件，你依然可以通过profile和在pom文件里使用多个`<argument>`便签来使用命令行参数。（If you can’t upgrade the plugin version, you can still use command line arguments with a profile and use multiple  tags associated in the pom.xml）

翻译来源： 
[http://www.vineetmanohar.com/2009/11/3-ways-to-run-java-main-from-maven/](http://www.vineetmanohar.com/2009/11/3-ways-to-run-java-main-from-maven/)
{% endraw %}
