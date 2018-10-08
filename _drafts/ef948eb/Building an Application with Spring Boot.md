---
layout: post
title:  "使用Spring Boot构建应用程序"
title2:  "Building an Application with Spring Boot"
date:   2018-10-08 10:06:45  +0800
source:  "https://spring.io/guides/gs/spring-boot/"
fileName:  "ef948eb"
lang:  "en"
published: false

---
{% raw %}
You will want to add a test for the endpoint you added, and Spring Test already provides some machinery for that, and it’s easy to include in your project.
您将需要为添加的端点添加测试，Spring Test已经为此提供了一些机制，并且很容易包含在您的项目中。(zh_CN)

Add this to your build file’s list of dependencies:
将其添加到构建文件的依赖项列表中：(zh_CN)

        testCompile("org.springframework.boot:spring-boot-starter-test")

If you are using Maven, add this to your list of dependencies:
如果您使用的是Maven，请将其添加到依赖项列表中：(zh_CN)

            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
            </dependency>

Now write a simple unit test that mocks the servlet request and response through your endpoint:
现在编写一个简单的单元测试，通过端点模拟servlet请求和响应：(zh_CN)

`src/test/java/hello/HelloControllerTest.java`

    package hello;
    
    import static org.hamcrest.Matchers.equalTo;
    import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
    import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
    
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.http.MediaType;
    import org.springframework.test.context.junit4.SpringRunner;
    import org.springframework.test.web.servlet.MockMvc;
    import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
    
    @RunWith(SpringRunner.class)
    @SpringBootTest
    @AutoConfigureMockMvc
    public class HelloControllerTest {
    
        @Autowired
        private MockMvc mvc;
    
        @Test
        public void getHello() throws Exception {
            mvc.perform(MockMvcRequestBuilders.get("/").accept(MediaType.APPLICATION_JSON))
                    .andExpect(status().isOk())
                    .andExpect(content().string(equalTo("Greetings from Spring Boot!")));
        }
    }

The `MockMvc` comes from Spring Test and allows you, via a set of convenient builder classes, to send HTTP requests into the `DispatcherServlet` and make assertions about the result. Note the use of the `@AutoConfigureMockMvc` together with `@SpringBootTest` to inject a `MockMvc` instance. Having used `@SpringBootTest` we are asking for the whole application context to be created. An alternative would be to ask Spring Boot to create only the web layers of the context using the `@WebMvcTest`. Spring Boot automatically tries to locate the main application class of your application in either case, but you can override it, or narrow it down, if you want to build something different.
该`MockMvc` 来自Spring Test，它允许您通过一组方便的构建器类将HTTP请求发送到`DispatcherServlet` 并对结果做出断言。注意使用`@AutoConfigureMockMvc` 和...一起`@SpringBootTest` 注射一个`MockMvc` 实例。使用过`@SpringBootTest` 我们要求创建整个应用程序上下文。另一种方法是让Spring Boot使用。仅创建上下文的Web层`@WebMvcTest`. 在任何一种情况下，Spring Boot都会自动尝试查找应用程序的主应用程序类，但是如果要构建不同的东西，可以覆盖它，或缩小范围。(zh_CN)

As well as mocking the HTTP request cycle we can also use Spring Boot to write a very simple full-stack integration test. For example, instead of (or as well as) the mock test above we could do this:
除了模拟HTTP请求周期之外，我们还可以使用Spring Boot编写一个非常简单的全栈集成测试。例如，代替（或以及）上面的模拟测试，我们可以这样做：(zh_CN)

`src/test/java/hello/HelloControllerIT.java`

    package hello;
    
    import static org.hamcrest.Matchers.*;
    import static org.junit.Assert.*;
    
    import java.net.URL;
    
    import org.junit.Before;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.boot.test.web.client.TestRestTemplate;
    import org.springframework.boot.web.server.LocalServerPort;
    import org.springframework.http.ResponseEntity;
    import org.springframework.test.context.junit4.SpringRunner;
    
    @RunWith(SpringRunner.class)
    @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
    public class HelloControllerIT {
    
        @LocalServerPort
        private int port;
    
        private URL base;
    
        @Autowired
        private TestRestTemplate template;
    
        @Before
        public void setUp() throws Exception {
            this.base = new URL("http://localhost:" + port + "/");
        }
    
        @Test
        public void getHello() throws Exception {
            ResponseEntity<String> response = template.getForEntity(base.toString(),
                    String.class);
            assertThat(response.getBody(), equalTo("Greetings from Spring Boot!"));
        }
    }

The embedded server is started up on a random port by virtue of the `webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT` and the actual port is discovered at runtime with the `@LocalServerPort`.
嵌入式服务器是通过随机端口启动的`webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT` 并在运行时发现实际的端口`@LocalServerPort`.(zh_CN)
{% endraw %}
