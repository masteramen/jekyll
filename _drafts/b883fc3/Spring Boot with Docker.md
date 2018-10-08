---
layout: post
title:  "带Docker的Spring Boot"
title2:  "Spring Boot with Docker"
date:   2018-10-08 04:19:58  +0800
source:  "https://spring.io/guides/gs/spring-boot-docker/"
fileName:  "b883fc3"
lang:  "en"
published: false

---
{% raw %}
Docker has a simple [Dockerfile](https://docs.docker.com/reference/builder/) file format that it uses to specify the "layers" of an image. So let’s go ahead and create a Dockerfile in our Spring Boot project:
Docker有一个简单的[Dockerfile]（https://docs.docker.com/reference/builder/）文件格式，用于指定图像的“图层”。那么让我们继续在Spring Boot项目中创建一个Dockerfile：(zh_CN)

    FROM openjdk:8-jdk-alpine
    VOLUME /tmp
    ARG JAR_FILE
    COPY ${JAR_FILE} app.jar
    ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

This Dockerfile is very simple, but that’s all you need to run a Spring Boot app with no frills: just Java and a JAR file. The project JAR file is `ADDed` to the container as "app.jar" and then executed in the `ENTRYPOINT`.
这个Dockerfile非常简单，但是你需要运行一个没有多余装饰的Spring Boot应用程序：只需要Java和一个JAR文件。项目JAR文件是`ADDed` 将容器作为“app.jar”然后在中执行`ENTRYPOINT`.(zh_CN)

 We added a `VOLUME` pointing to "/tmp" because that is where a Spring Boot application creates working directories for Tomcat by default. The effect is to create a temporary file on your host under "/var/lib/docker" and link it to the container under "/tmp". This step is optional for the simple app that we wrote here, but can be necessary for other Spring Boot applications if they need to actually write in the filesystem. 
 我们添加了一个`VOLUME` 指向“/ tmp”，因为这是Spring Boot应用程序默认为Tomcat创建工作目录的地方。效果是在主机“/ var / lib / docker”下创建一个临时文件，并将其链接到“/ tmp”下的容器。对于我们在此处编写的简单应用程序，此步骤是可选的，但如果需要在文件系统中实际编写，则对于其他Spring Boot应用程序可能是必需的。(zh_CN)

 To reduce [Tomcat startup time](https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source) we added a system property pointing to "/dev/urandom" as a source of entropy. This is not necessary with more recent versions of Spring Boot, if you use the "standard" version of Tomcat (or any other web server). 
 为了减少[Tomcat启动时间]（https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source），我们添加了一个指向“/ dev / urandom”的系统属性作为熵源。如果您使用Tomcat（或任何其他Web服务器）的“标准”版本，则对于更新版本的Spring Boot，这不是必需的。(zh_CN)

To take advantage of the clean separation between dependencies and application resources in a Spring Boot fat jar file, we will use a slightly different implementation of the Dockerfile:
为了利用Spring Boot胖jar文件中依赖项和应用程序资源之间的清晰分离，我们将使用稍微不同的Dockerfile实现：(zh_CN)

    FROM openjdk:8-jdk-alpine
    VOLUME /tmp
    ARG DEPENDENCY
    COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
    COPY ${DEPENDENCY}/META-INF /app/META-INF
    COPY ${DEPENDENCY}/BOOT-INF/classes /app
    ENTRYPOINT ["java","-cp","app:app/lib/*","hello.Application"]

This Dockerfile has a `DEPENDENCY` parameter pointing to a directory where we have unpacked the fat jar. If we get that right, it already contains a `BOOT-INF/lib` directory with the dependency jars in it, and a `BOOT-INF/classes` directory with the application classes in it. Notice that we are using the application’s own main class `hello.Application` (this is faster than using the indirection provided by the fat jar launcher).
这个Dockerfile有一个`DEPENDENCY` 指向我们已解压胖jar的目录的参数。如果我们做对了，它已经包含了`BOOT-INF/lib` 目录中包含依赖项jars，以及a`BOOT-INF/classes` 目录中包含应用程序类。请注意，我们正在使用应用程序自己的主类`hello.Application` (这比使用胖罐启动器提供的间接更快。(zh_CN)

 if you are using boot2docker you need to run it **first** before you do anything with the Docker command line or with the build tools (it runs a daemon process that handles the work for you in a virtual machine). 
 如果您正在使用boot2docker，则需要先使用Docker命令行或使用构建工具执行任何操作** **（它运行一个守护进程来处理虚拟机中的工作）。(zh_CN)

To build the image you can use some tooling for Maven or Gradle from the community (big thanks to [Palantir](https://github.com/palantir/gradle-docker) and [Spotify](https://github.com/spotify/dockerfile-maven) for making those tools available).
要构建映像，您可以从社区使用Maven或Gradle的一些工具（非常感谢[Palantir]（https://github.com/palantir/gradle-docker）和[Spotify]（https://github.com） / spotify / dockerfile-maven）使这些工具可用）。(zh_CN)

### Build a Docker Image with Maven
### 使用Maven构建Docker镜像(zh_CN)

    <properties>
       <docker.image.prefix>springio</docker.image.prefix>
    </properties>
    <build>
        <plugins>
            <plugin>
                <groupId>com.spotify</groupId>
                <artifactId>dockerfile-maven-plugin</artifactId>
                <version>1.3.6</version>
                <configuration>
                    <repository>${docker.image.prefix}/${project.artifactId}</repository>
                    <buildArgs>
                        <DEPENDENCY>target/dependency</DEPENDENCY>
                    </buildArgs>
                </configuration>
            </plugin>
        </plugins>
    </build>

The configuration specifies 3 things:
配置指定了3件事：(zh_CN)

- 
The repository with the image name, which will end up here as `springio/gs-spring-boot-docker`
具有图像名称的存储库，最终将在此处作为`springio/gs-spring-boot-docker`(zh_CN)

- 
The name of the directory where the fat jar is going to be unpacked, exposing the Maven configuration as a build argument for docker.
胖jar将要解压缩的目录的名称，将Maven配置公开为docker的构建参数。(zh_CN)

- 
Optionally, the image tag, which ends up as latest if not specified. It can be set to the artifact id if desired.
（可选）图像标记，如果未指定则最终为最新版本。如果需要，可以将其设置为工件ID。(zh_CN)

 Before proceeding with the following steps (which use Docker’s CLI tools), make sure Docker is properly running by typing `docker ps`. If you get an error message, something may not be set up correctly. Using a Mac? Add `$(boot2docker shellinit 2> /dev/null)` to the bottom of your `.bash_profile` (or similar env-setting configuration file) and refresh your shell to ensure proper environment variables are configured. 
 在继续执行以下步骤（使用Docker的CLI工具）之前，请确保通过键入正确运行Docker`docker ps`. 如果收到错误消息，可能无法正确设置某些内容。用Mac？加`$(boot2docker shellinit 2> /dev/null)` 在你的底部`.bash_profile` (或类似的env-setting配置文件）并刷新shell以确保配置适当的环境变量。(zh_CN)

To ensure the jar is unpacked before the docker image is created we add some configuration for the dependency plugin:
为确保在创建docker镜像之前解压缩jar，我们为依赖项插件添加一些配置：(zh_CN)

    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
            <execution>
                <id>unpack</id>
                <phase>package</phase>
                <goals>
                    <goal>unpack</goal>
                </goals>
                <configuration>
                    <artifactItems>
                        <artifactItem>
                            <groupId>${project.groupId}</groupId>
                            <artifactId>${project.artifactId}</artifactId>
                            <version>${project.version}</version>
                        </artifactItem>
                    </artifactItems>
                </configuration>
            </execution>
        </executions>
    </plugin>

You can build a tagged docker image using the command line like this:
您可以使用命令行构建标记的docker镜像，如下所示：(zh_CN)

    $ ./mvnw install dockerfile:build

And you can push the image to dockerhub with `./mvnw dockerfile:push`.
你可以将图像推送到dockerhub`./mvnw dockerfile:push`.(zh_CN)

 You don’t have to push your newly minted Docker image to actually run it. Moreover the "push" command will fail if you aren’t a member of the "springio" organization on Dockerhub. Change the build configuration and the command line to your own username instead of "springio" to make it actually work. 
 您不必将新创建的Docker镜像推送到实际运行它。此外，如果您不是Dockerhub上“springio”组织的成员，“push”命令将失败。将构建配置和命令行更改为您自己的用户名而不是“springio”，以使其实际工作。(zh_CN)

 you can make `dockerfile:push` automatically run in the install or deploy lifecycle phases by adding it to the plugin configuration. 
 你（们）能做到`dockerfile:push` 通过将其添加到插件配置中，自动在安装或部署生命周期阶段中运行。(zh_CN)

    <executions>
    	<execution>
    		<id>default</id>
    		<phase>install</phase>
    		<goals>
    			<goal>build</goal>
    			<goal>push</goal>
    		</goals>
    	</execution>
    </executions>

### Build a Docker Image with Gradle
### 使用Gradle构建Docker镜像(zh_CN)

If you are using Gradle you need to add a new plugin like this:
如果您使用的是Gradle，则需要添加如下新插件：(zh_CN)

    buildscript {
        ...
        dependencies {
            ...
            classpath('gradle.plugin.com.palantir.gradle.docker:gradle-docker:0.13.0')
        }
    }
    
    group = 'springio'
    
    ...
    apply plugin: 'com.palantir.docker'
    
    task unpack(type: Copy) {
        dependsOn bootJar
        from(zipTree("build/libs/${bootJar.archiveName}"))
        into("build/dependency")
    }
    docker {
        name "${project.group}/${bootJar.baseName}"
        copySpec.from(tasks.unpack.outputs).into("dependency")
        buildArgs(['DEPENDENCY': "dependency"])
    }

The configuration specifies 4 things:
配置指定了4件事：(zh_CN)

- 
a task to unpack the fat jar file
解压胖jar文件的任务(zh_CN)

- 
the image name (or tag) is set up from the jar file properties, which will end up here as `springio/gs-spring-boot-docker`
图像名称（或标记）是从jar文件属性设置的，最终将在此处作为`springio/gs-spring-boot-docker`(zh_CN)

- 
the location of the unpacked jarfile
解压缩的jar文件的位置(zh_CN)

- 
a build argument for docker pointing to the jar file
docker指向jar文件的构建参数(zh_CN)

You can build a tagged docker image and then push it to a remote repository with Gradle in one command:
您可以构建标记的docker镜像，然后使用Gradle将其推送到远程存储库：(zh_CN)

### After the Push
### 推后(zh_CN)

A "docker push" will fail for you (unless you are part of the "springio" organization at Dockerhub), but if you change the configuration to match your own docker ID then it should succeed, and you will have a new tagged, deployed image.
“docker push”将失败（除非您是Dockerhub中“springio”组织的一部分），但是如果您更改配置以匹配您自己的docker ID，那么它应该会成功，并且您将有一个新的标记，部署图片。(zh_CN)

You do NOT have to register with docker or publish anything to run a docker image. You still have a locally tagged image, and you can run it like this:
您不必注册docker或发布任何东西来运行docker镜像。您仍然拥有本地标记的图像，您可以像这样运行它：(zh_CN)

    $ docker run -p 8080:8080 -t springio/gs-spring-boot-docker
    ....
    2015-03-31 13:25:48.035  INFO 1 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080 (http)
    2015-03-31 13:25:48.037  INFO 1 --- [           main] hello.Application                        : Started Application in 5.613 seconds (JVM running for 7.293)

The application is then available on [http://localhost:8080](http://localhost:8080/) (visit that and it says "Hello Docker World"). To make sure the whole process is really working, change the prefix from "springio" to something else (e.g. `${env.USER}`) and go through it again from the build through to the docker run.
然后可以在[http：// localhost：8080]（http：// localhost：8080 /）上找到该应用程序（访问它并显示“Hello Docker World”）。要确保整个过程真正有效，请将前缀从“springio”更改为其他内容（例如`${env.USER}`) 并从构建到码头运行再次通过它。(zh_CN)

When using a Mac with boot2docker, you typically see things like this at startup:
将Mac与boot2docker一起使用时，通常会在启动时看到类似的内容：(zh_CN)

    Docker client to the Docker daemon, please set:
        export DOCKER_CERT_PATH=/Users/gturnquist/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1
        export DOCKER_HOST=tcp://192.168.59.103:2376

To see the app, you must visit the IP address in DOCKER_HOST instead of localhost. In this case, [http://192.168.59.103:8080](http://192.168.59.103:8080/), the public facing IP of the VM.
要查看应用程序，您必须访问DOCKER_HOST中的IP地址而不是localhost。在这种情况下，[http://192.168.59.103:8080 ](http://192.168.59.103:8080/），面向VM的公共IP。(zh_CN)

When it is running you can see in the list of containers, e.g:
当它运行时，您可以在容器列表中看到，例如：(zh_CN)

    $ docker ps
    CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
    81c723d22865        springio/gs-spring-boot-docker:latest   "java -Djava.secur..."   34 seconds ago      Up 33 seconds       0.0.0.0:8080->8080/tcp   goofy_brown

and to shut it down again you can `docker stop` with the container ID from the listing above (yours will be different):
并且可以再次关闭它`docker stop` 使用上面列表中的容器ID（您的容器ID将不同）：(zh_CN)

    $ docker stop 81c723d22865
    81c723d22865

If you like you can also delete the container (it is persisted in your filesystem under `/var/lib/docker` somewhere) when you are finished with it:
如果您愿意，也可以删除容器（它保存在您的文件系统下）`/var/lib/docker` 在某处）当你完成它：(zh_CN)

### Using Spring Profiles
### 使用Spring配置文件(zh_CN)

Running your freshly minted Docker image with Spring profiles is as easy as passing an environment variable to the Docker run command
使用Spring配置文件运行刚刚创建的Docker镜像就像将环境变量传递给Docker run命令一样简单(zh_CN)

    $ docker run -e "SPRING_PROFILES_ACTIVE=prod" -p 8080:8080 -t springio/gs-spring-boot-docker

    $ docker run -e "SPRING_PROFILES_ACTIVE=dev" -p 8080:8080 -t springio/gs-spring-boot-docker

### Debugging the application in a Docker container
### 在Docker容器中调试应用程序(zh_CN)

To debug the application [JPDA Transport](https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/conninv.html#Invocation) can be used. So we’ll treat the container like a remote server. To enable this feature pass a java agent settings in JAVA_OPTS variable and map agent’s port to localhost during a container run. With the [Docker for Mac](https://www.docker.com/products/docker#/mac) there is limitation due to that we can’t access container by IP without [black magic usage](https://github.com/docker/for-mac/issues/171).
要调试应用程序，可以使用[JPDA Transport]（https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/conninv.html#Invocation）。所以我们将容器视为远程服务器。要启用此功能，请在JAVA_OPTS变量中传递Java代理设置，并在容器运行期间将代理程序的端口映射到localhost。使用[Docker for Mac]（https://www.docker.com/products/docker#/mac），由于我们无法通过IP访问容器而没有[黑魔法使用]（https：// github.com/docker/for-mac/issues/171）。(zh_CN)

    $ docker run -e "JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n" -p 8080:8080 -p 5005:5005 -t springio/gs-spring-boot-docker
{% endraw %}
