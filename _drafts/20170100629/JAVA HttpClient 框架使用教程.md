---
layout: post
title:  "JAVA HttpClient 框架使用教程"
title2:  "JAVA HttpClient 框架使用教程"
date:   2017-01-01 23:45:29  +0800
source:  "http://www.jfox.info/java-httpclient-framework-tutorial.html"
fileName:  "20170100629"
lang:  "zh_CN"
published: true
permalink: "java-httpclient-framework-tutorial.html"
---
{% raw %}
前言

超文本传输协议（HTTP）也许是当今互联网上使用的最重要的协议了。Web服务，有网络功能的设备和网络计算的发展，都持续扩展了HTTP协议的角色，超越了用户使用的Web浏览器范畴，同时，也增加了需要HTTP协议支持的应用程序的数量。

尽管java.net包提供了基本通过HTTP访问资源的功能，但它没有提供全面的灵活性和其它很多应用程序需要的功能。HttpClient就是寻求弥补这项空白的组件，通过提供一个有效的，保持更新的，功能丰富的软件包来实现客户端最新的HTTP标准和建议。

为扩展而设计，同时为基本的HTTP协议提供强大的支持，HttpClient组件也许就是构建HTTP客户端应用程序，比如web浏览器，web服务端，利用或扩展HTTP协议进行分布式通信的系统的开发人员的关注点。

### 1. HttpClient的范围

- 基于HttpCore[http://hc.apache.org/httpcomponents-core/index.html]的客户端HTTP运输实现库
- 基于经典（阻塞）I/O
- 内容无关

### 2. 什么是HttpClient不能做的

- HttpClient不是一个浏览器。它是一个客户端的HTTP通信实现库。HttpClient的目标是发送和接收HTTP报文。HttpClient不会去缓存内容，执行嵌入在HTML页面中的javascript代码，猜测内容类型，重新格式化请求/重定向URI，或者其它和HTTP运输无关的功能。

### 1.1 执行请求

HttpClient最重要的功能是执行HTTP方法。一个HTTP方法的执行包含一个或多个HTTP请求/HTTP响应交换，通常由HttpClient的内部来处理。而期望用户提供一个要执行的请求对象，而HttpClient期望传输请求到目标服务器并返回对应的响应对象，或者当执行不成功时抛出异常。

很自然地，HttpClient API的主要切入点就是定义描述上述规约的HttpClient接口。

这里有一个很简单的请求执行过程的示例：

> HttpClient httpclient = new DefaultHttpClient();
> 
> HttpGet httpget = new HttpGet(“http://localhost/”);
> 
> HttpResponse response = httpclient.execute(httpget);
> 
> HttpEntity entity = response.getEntity();
> 
> if (entity != null) {
> 
> InputStream instream = entity.getContent();
> 
> int l;
> 
> byte[] tmp = new byte[2048];
> 
> while ((l = instream.read(tmp)) != -1) {
> 
> }
> 
> }

#### 1.1.1 HTTP请求

所有HTTP请求有一个组合了方法名，请求URI和HTTP协议版本的请求行。

HttpClient支持所有定义在HTTP/1.1版本中的HTTP方法：GET，HEAD，POST，PUT，DELETE，TRACE和OPTIONS。对于每个方法类型都有一个特殊的类：HttpGet，HttpHead，HttpPost，HttpPut，HttpDelete，HttpTrace和HttpOptions。

请求的URI是统一资源定位符，它标识了应用于哪个请求之上的资源。HTTP请求URI包含一个协议模式，主机名称，可选的端口，资源路径，可选的查询和可选的片段。

> HttpGet httpget = new HttpGet(
> 
> “http://www.google.com/search?hl=en&q=httpclient&btnG=Google+Search&aq=f&oq=”);

HttpClient提供很多工具方法来简化创建和修改执行URI。

URI也可以编程来拼装：

> URI uri = URIUtils.createURI(“http”, “www.google.com”, -1, “/search”,
> 
> “q=httpclient&btnG=Google+Search&aq=f&oq=”, null);
> 
> HttpGet httpget = new HttpGet(uri);
> 
> System.out.println(httpget.getURI());

输出内容为：

> http://www.google.com/search?q=httpclient&btnG=Google+Search&aq=f&oq=

查询字符串也可以从独立的参数中来生成：

> List qparams = new ArrayList();
> 
> qparams.add(new BasicNameValuePair(“q”, “httpclient”));
> 
> qparams.add(new BasicNameValuePair(“btnG”, “Google Search”));
> 
> qparams.add(new BasicNameValuePair(“aq”, “f”));
> 
> qparams.add(new BasicNameValuePair(“oq”, null));
> 
> URI uri = URIUtils.createURI(“http”, “www.google.com”, -1, “/search”,
> 
> URLEncodedUtils.format(qparams, “UTF-8”), null);
> 
> HttpGet httpget = new HttpGet(uri);
> 
> System.out.println(httpget.getURI());

输出内容为：

> http://www.google.com/search?q=httpclient&btnG=Google+Search&aq=f&oq=

#### 1.1.2 HTTP响应

HTTP响应是由服务器在接收和解释请求报文之后返回发送给客户端的报文。响应报文的第一行包含了协议版本，之后是数字状态码和相关联的文本段。

> HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1,
> 
> HttpStatus.SC_OK, “OK”);
> 
> System.out.println(response.getProtocolVersion());
> 
> System.out.println(response.getStatusLine().getStatusCode());
> 
> System.out.println(response.getStatusLine().getReasonPhrase());
> 
> System.out.println(response.getStatusLine().toString());

输出内容为：

> HTTP/1.1
> 
> 200
> 
> OK
> 
> HTTP/1.1 200 OK

#### 1.1.3 处理报文头部

一个HTTP报文可以包含很多描述如内容长度，内容类型等信息属性的头部信息。

HttpClient提供获取，添加，移除和枚举头部信息的方法。

> HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1,
> 
> HttpStatus.SC_OK, “OK”);
> 
> response.addHeader(“Set-Cookie”,
> 
> “c1=a; path=/; domain=localhost”);
> 
> response.addHeader(“Set-Cookie”,
> 
> “c2=b; path=\”/\”, c3=c; domain=\”localhost\””);
> 
> Header h1 = response.getFirstHeader(“Set-Cookie”);
> 
> System.out.println(h1);
> 
> Header h2 = response.getLastHeader(“Set-Cookie”);
> 
> System.out.println(h2);
> 
> Header[] hs = response.getHeaders(“Set-Cookie”);
> 
> System.out.println(hs.length);

输出内容为：

> Set-Cookie: c1=a; path=/; domain=localhost
> 
> Set-Cookie: c2=b; path=”/”, c3=c; domain=”localhost”

获得给定类型的所有头部信息最有效的方式是使用HeaderIterator接口。

> HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1,
> 
> HttpStatus.SC_OK, “OK”);
> 
> response.addHeader(“Set-Cookie”,
> 
> “c1=a; path=/; domain=localhost”);
> 
> response.addHeader(“Set-Cookie”,
> 
> “c2=b; path=\”/\”, c3=c; domain=\”localhost\””);
> 
> HeaderIterator it = response.headerIterator(“Set-Cookie”);
> 
> while (it.hasNext()) {
> 
> System.out.println(it.next());
> 
> }

输出内容为：

> Set-Cookie: c1=a; path=/; domain=localhost
> 
> Set-Cookie: c2=b; path=”/”, c3=c; domain=”localhost”

它也提供解析HTTP报文到独立头部信息元素的方法方法。

> HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1,
> HttpStatus.SC_OK, “OK”);
> response.addHeader(“Set-Cookie”,
> “c1=a; path=/; domain=localhost”);
> response.addHeader(“Set-Cookie”,
> “c2=b; path=\”/\”, c3=c; domain=\”localhost\””);
> HeaderElementIterator it = new BasicHeaderElementIterator(
> response.headerIterator(“Set-Cookie”));
> while (it.hasNext()) {
> HeaderElement elem = it.nextElement();
> System.out.println(elem.getName() + ” = ” + elem.getValue());
> NameValuePair[] params = elem.getParameters();
> for (int i = 0; i < params.length; i++) {
> System.out.println(” ” + params[i]);
> }
> }

输出内容为：

> c1 = a
> 
> path=/
> 
> domain=localhost
> 
> c2 = b
> 
> path=/
> 
> c3 = c
> 
> domain=localhost

#### 1.1.4 HTTP实体

HTTP报文可以携带和请求或响应相关的内容实体。实体可以在一些请求和响应中找到，因为它们也是可选的。使用了实体的请求被称为封闭实体请求。HTTP规范定义了两种封闭实体的方法：POST和PUT。响应通常期望包含一个内容实体。这个规则也有特例，比如HEAD方法的响应和204 No Content，304 Not Modified和205 Reset Content响应。

HttpClient根据其内容出自何处区分三种类型的实体：

- streamed流式：内容从流中获得，或者在运行中产生。特别是这种分类包含从HTTP响应中获取的实体。流式实体是不可重复生成的。
- self-contained自我包含式：内容在内存中或通过独立的连接或其它实体中获得。自我包含式的实体是可以重复生成的。这种类型的实体会经常用于封闭HTTP请求的实体。
- wrapping包装式：内容从另外一个实体中获得。

当从一个HTTP响应中获取流式内容时，这个区别对于连接管理很重要。对于由应用程序创建而且只使用HttpClient发送的请求实体，流式和自我包含式的不同就不那么重要了。这种情况下，建议考虑如流式这种不能重复的实体，和可以重复的自我包含式实体。

##### 1.1.4.1 重复实体

实体可以重复，意味着它的内容可以被多次读取。这就仅仅是自我包含式的实体了（像ByteArrayEntity或StringEntity）。

##### 1.1.4.2 使用HTTP实体

因为一个实体既可以代表二进制内容又可以代表字符内容，它也支持字符编码（支持后者也就是字符内容）。

实体是当使用封闭内容执行请求，或当请求已经成功执行，或当响应体结果发功到客户端时创建的。

要从实体中读取内容，可以通过HttpEntity#getContent()方法从输入流中获取，这会返回一个java.io.InputStream对象，或者提供一个输出流到HttpEntity#writeTo(OutputStream)方法中，这会一次返回所有写入到给定流中的内容。

当实体通过一个收到的报文获取时，HttpEntity#getContentType()方法和HttpEntity#getContentLength()方法可以用来读取通用的元数据，如Content-Type和Content-Length头部信息（如果它们是可用的）。因为头部信息Content-Type可以包含对文本MIME类型的字符编码，比如text/plain或text/html，HttpEntity#getContentEncoding()方法用来读取这个信息。如果头部信息不可用，那么就返回长度-1，而对于内容类型返回NULL。如果头部信息Content-Type是可用的，那么就会返回一个Header对象。

当为一个传出报文创建实体时，这个元数据不得不通过实体创建器来提供。

> StringEntity myEntity = new StringEntity(“important message”,
> 
> “UTF-8”);
> 
> System.out.println(myEntity.getContentType());
> 
> System.out.println(myEntity.getContentLength());
> 
> System.out.println(EntityUtils.getContentCharSet(myEntity));
> 
> System.out.println(EntityUtils.toString(myEntity));
> 
> System.out.println(EntityUtils.toByteArray(myEntity).length);

输出内容为

Content-Type: text/plain; charset=UTF-8

17

UTF-8

important message

17

#### 1.1.5 确保低级别资源释放

当完成一个响应实体，那么保证所有实体内容已经被完全消耗是很重要的，所以连接可以安全的放回到连接池中，而且可以通过连接管理器对后续的请求重用连接。处理这个操作的最方便的方法是调用HttpEntity#consumeContent()方法来消耗流中的任意可用内容。HttpClient探测到内容流尾部已经到达后，会立即会自动释放低层连接，并放回到连接管理器。HttpEntity#consumeContent()方法调用多次也是安全的。

也可能会有特殊情况，当整个响应内容的一小部分需要获取，消耗剩余内容而损失性能，还有重用连接的代价太高，则可以仅仅通过调用HttpUriRequest#abort()方法来中止请求。

> HttpGet httpget = new HttpGet(“http://localhost/”);
> 
> HttpResponse response = httpclient.execute(httpget);
> 
> HttpEntity entity = response.getEntity();
> 
> if (entity != null) {
> 
> InputStream instream = entity.getContent();
> 
> int byteOne = instream.read();
> 
> int byteTwo = instream.read();
> 
> // Do not need the rest
> 
> httpget.abort();
> 
> }

连接不会被重用，但是由它持有的所有级别的资源将会被正确释放。

#### 1.1.6 消耗实体内容

推荐消耗实体内容的方式是使用它的HttpEntity#getContent()或HttpEntity#writeTo(OutputStream)方法。HttpClient也自带EntityUtils类，这会暴露出一些静态方法，这些方法可以更加容易地从实体中读取内容或信息。代替直接读取java.io.InputStream，也可以使用这个类中的方法以字符串/字节数组的形式获取整个内容体。然而，EntityUtils的使用是强烈不鼓励的，除非响应实体源自可靠的HTTP服务器和已知的长度限制。

> HttpGet httpget = new HttpGet(“http://localhost/”);
> 
> HttpResponse response = httpclient.execute(httpget);
> 
> HttpEntity entity = response.getEntity();
> 
> if (entity != null) {
> 
> long len = entity.getContentLength();
> 
> if (len != -1 && len < 2048) {
> 
> System.out.println(EntityUtils.toString(entity));
> 
> } else {
> 
> // Stream content out
> 
> }
> 
> }

在一些情况下可能会不止一次的读取实体。此时实体内容必须以某种方式在内存或磁盘上被缓冲起来。最简单的方法是通过使用BufferedHttpEntity类来包装源实体完成。这会引起源实体内容被读取到内存的缓冲区中。在其它所有方式中，实体包装器将会得到源实体。

> HttpGet httpget = new HttpGet(“http://localhost/”);
> 
> HttpResponse response = httpclient.execute(httpget);
> 
> HttpEntity entity = response.getEntity();
> 
> if (entity != null) {
> 
> entity = new BufferedHttpEntity(entity);
> 
> }

#### 1.1.7 生成实体内容

HttpClient提供一些类，它们可以用于生成通过HTTP连接获得内容的有效输出流。为了封闭实体从HTTP请求中获得的输出内容，那些类的实例可以和封闭如POST和PUT请求的实体相关联。HttpClient为很多公用的数据容器，比如字符串，字节数组，输入流和文件提供了一些类：StringEntity，ByteArrayEntity，InputStreamEntity和FileEntity。

> File file = new File(“somefile.txt”);
> 
> FileEntity entity = new FileEntity(file, “text/plain; charset=\”UTF-8\””);
> 
> HttpPost httppost = new HttpPost(“http://localhost/action.do”);
> 
> httppost.setEntity(entity);

请注意InputStreamEntity是不可重复的，因为它仅仅能从低层数据流中读取一次内容。通常来说，我们推荐实现一个定制的HttpEntity类，这是自我包含式的，用来代替使用通用的InputStreamEntity。FileEntity也是一个很好的起点。

##### 1.1.7.1 动态内容实体

通常来说，HTTP实体需要基于特定的执行上下文来动态地生成。通过使用EntityTemplate实体类和ContentProducer接口，HttpClient提供了动态实体的支持。内容生成器是按照需求生成它们内容的对象，将它们写入到一个输出流中。它们是每次被请求时来生成内容。所以用EntityTemplate创建的实体通常是自我包含而且可以重复的。

> ContentProducer cp = new ContentProducer() {
> 
> public void writeTo(OutputStream outstream) throws IOException {
> 
> Writer writer = new OutputStreamWriter(outstream, “UTF-8”);
> 
> writer.write(““);
> 
> writer.write(” “);
> 
> writer.write(” important stuff”);
> 
> writer.write(” “);
> 
> writer.write(““);
> 
> writer.flush();
> 
> }
> 
> };
> 
> HttpEntity entity = new EntityTemplate(cp);
> 
> HttpPost httppost = new HttpPost(“http://localhost/handler.do”);
> 
> httppost.setEntity(entity);

##### 1.1.7.2 HTML表单

许多应用程序需要频繁模拟提交一个HTML表单的过程，比如，为了来记录一个Web应用程序或提交输出数据。HttpClient提供了特殊的实体类UrlEncodedFormEntity来这个满足过程。

> List
{% endraw %}
