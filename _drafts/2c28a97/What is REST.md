---
layout: post
title:  "什么是REST？"
title2:  "What is REST?"
date:   2018-10-08 07:48:50  +0800
source:  "https://www.codecademy.com/articles/what-is-rest"
fileName:  "2c28a97"
lang:  "en"
published: false

---
{% raw %}
## REpresentational State Transfer
## 代表国家转移(zh_CN)

REST, or REpresentational State Transfer, is an architectural style for providing standards between computer systems on the web, making it easier for systems to communicate with each other. REST-compliant systems, often called RESTful systems, are characterized by how they are stateless and separate the concerns of client and server. We will go into what these terms mean and why they are beneficial characteristics for services on the Web. 
REST或REpresentational State Transfer是一种体系结构样式，用于在Web上的计算机系统之间提供标准，使系统更容易相互通信。符合REST的系统（通常称为RESTful系统）的特点是它们是无状态的，并将客户端和服务器的关注点分开。我们将讨论这些术语的含义以及它们为什么是Web上的服务的有益特征。(zh_CN)

### Separation of Client and Server
### 客户端和服务器的分离(zh_CN)

In the REST architectural style, the implementation of the client and the implementation of the server can be done independently without each knowing about the other. This means that the code on the client side can be changed at any time without affecting the operation of the server, and the code on the server side can be changed without affecting the operation of the client.
在REST架构风格中，客户端的实现和服务器的实现可以独立完成，而无需了解另一个。这意味着可以随时更改客户端上的代码而不影响服务器的操作，并且可以在不影响客户端操作的情况下更改服务器端的代码。(zh_CN)

As long as each side knows what format of messages to send to the other, they can be kept modular and separate. Separating the user interface concerns from the data storage concerns, we improve the flexibility of the interface across platforms and improve scalability by simplifying the server components. Additionally, the separation allows each component the ability to evolve independently.
只要每一方都知道要发送给另一方的消息格式，它们就可以保持模块化和分离。将用户界面问题与数据存储问题分开，我们通过简化服务器组件来提高跨平台的界面灵活性并提高可扩展性。此外，分离允许每个组件独立进化。(zh_CN)

By using a REST interface, different clients hit the same REST endpoints, perform the same actions, and receive the same responses. 
通过使用REST接口，不同的客户端可以访问相同的REST端点，执行相同的操作并接收相同的响应。(zh_CN)

### Statelessness
### 无国籍(zh_CN)

Systems that follow the REST paradigm are stateless, meaning that the server does not need to know anything about what state the client is in and vice versa. In this way, both the server and the client can understand any message received, even without seeing previous messages. This constraint of statelessness is enforced through the use of *resources*, rather than *commands*. Resources are the nouns of the Web - they describe any object, document, or  *thing* that you may need to store or send to other services.
遵循REST范例的系统是无状态的，这意味着服务器不需要知道客户端处于什么状态，反之亦然。通过这种方式，即使没有看到先前的消息，服务器和客户端也可以理解收到的任何消息。这种无状态约束是通过使用* resources *而不是* commands *来强制执行的。资源是Web的名词 - 它们描述了您可能需要存储或发送到其他服务的任何对象，文档或*事物*。(zh_CN)

Because REST systems interact through standard operations on resources, they do not rely on the implementation of interfaces.
由于REST系统通过资源上的标准操作进行交互，因此它们不依赖于接口的实现。(zh_CN)

These constraints help RESTful applications achieve reliability, quick performance, and scalability, as components that can be managed, updated, and reused without affecting the system as a whole, even during operation of the system.
这些约束有助于RESTful应用程序实现可靠性，快速性能和可伸缩性，作为可以在不影响整个系统的情况下进行管理，更新和重用的组件，即使在系统运行期间也是如此。(zh_CN)

Now, we’ll explore how the communication between the client and server actually happens when we are implementing a RESTful interface.
现在，我们将探讨在实现RESTful接口时，客户端和服务器之间的通信是如何实际发生的。(zh_CN)

## Communication between Client and Server
## 客户端和服务器之间的通信(zh_CN)

In the REST architecture, clients send requests to retrieve or modify resources, and servers send responses to these requests. Let’s take a look at the standard ways to make requests and send responses.
在REST体系结构中，客户端发送检索或修改资源的请求，服务器发送对这些请求的响应。让我们来看看发出请求和发送响应的标准方法。(zh_CN)

### Making Requests
### 发出请求(zh_CN)

REST requires that a client make a request to the server in order to retrieve or modify data on the server. A request generally consists of:
REST要求客户端向服务器发出请求，以便检索或修改服务器上的数据。请求通常包括：(zh_CN)

- an HTTP verb, which defines what kind of operation to perform
- HTTP谓词，定义要执行的操作类型(zh_CN)
- a *header*, which allows the client to pass along information about the request 
- a * header *，允许客户端传递有关请求的信息(zh_CN)
- a path to a resource
- 资源的路径(zh_CN)
- an optional message body containing data
- 包含数据的可选消息体(zh_CN)

#### HTTP Verbs
#### HTTP动词(zh_CN)

There are 4 basic HTTP verbs we use in requests to interact with resources in a REST system:
我们在请求与REST系统中的资源交互时使用了4个基本HTTP谓词：(zh_CN)

- GET — retrieve a specific resource (by id) or a collection of resources
- GET  - 检索特定资源（通过id）或资源集合(zh_CN)
- POST — create a new resource
- POST  - 创建一个新资源(zh_CN)
- PUT  — update a specific resource (by id)
- PUT  - 更新特定资源（按ID）(zh_CN)
- DELETE  — remove a specific resource by id
- 删除 - 按ID删除特定资源(zh_CN)

You can learn more about these HTTP verbs in the following Codecademy article: 
您可以在以下Codecademy文章中了解有关这些HTTP谓词的更多信息：(zh_CN)

#### Headers and Accept parameters
#### 标题和接受参数(zh_CN)

In the header of the request, the client sends the type of content that it is able to receive from the server. This is called the `Accept` field, and it ensures that the server does not send data that cannot be understood or processed by the client. The options for types of content are MIME Types (or Multipurpose Internet Mail Extensions, which you can read more about in the [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types).
在请求的标头中，客户端发送它能够从服务器接收的内容类型。这被称为`Accept` 字段，它确保服务器不发送客户端无法理解或处理的数据。内容类型的选项是MIME类型（或多用途Internet邮件扩展，您可以在[MDN Web Docs]中了解更多信息（https://developer.mozilla.org/en-US/docs/Web/HTTP/） Basics_of_HTTP / MIME_types）。(zh_CN)

MIME Types, used to specify the content types in the `Accept` field, consist of a `type` and a `subtype`. They are separated by a slash (/). 
MIME类型，用于指定内容类型`Accept` 字段，由a组成`type` 和a`subtype`. 它们用斜杠（/）分隔。(zh_CN)

For example, a text file containing HTML would be specified with the type `text/html`. If this text file contained CSS instead, it would be specified as `text/css`. A generic text file would be denoted as `text/plain`. This default value, `text/plain`, is not a catch-all, however. If a client is expecting `text/css` and receives `text/plain`, it will not be able to recognize the content.
例如，将使用类型指定包含HTML的文本文件`text/html`. 如果此文本文件包含CSS，则将其指定为`text/css`. 通用文本文件将表示为`text/plain`. 这个默认值，`text/plain`, 然而，并非一帆风顺。如果客户期待`text/css` 并收到`text/plain`, 它将无法识别内容。(zh_CN)

Other types and commonly used subtypes:
其他类型和常用的子类型：(zh_CN)

- `image` — `image/png`, `image/jpeg`, `image/gif`
- `audio`  — `audio/wav`, `image/mpeg`
- `video` — `video/mp4`, `video/ogg`
- `application`  — `application/json`, `application/pdf`, `application/xml`, `application/octet-stream`

For example, a client accessing a resource with `id` 23 in an `articles` resource on a server might send a GET request like this:
例如，访问资源的客户端`id` 23 在一个`articles` 服务器上的资源可能会发送如下的GET请求：(zh_CN)

    GET /articles/23
    Accept: text/html, application/xhtml
    

The `Accept` header field in this case is saying that the client will accept the content in `text/html` or `application/xhtml`.
该`Accept` 在这种情况下，标题字段表示客户端将接受内容`text/html` 要么`application/xhtml`.(zh_CN)

#### Paths
#### 路径(zh_CN)

Requests must contain a path to a resource that the operation should be performed on. In RESTful APIs, paths should be designed to help the client know what is going on. 
请求必须包含应在其上执行操作的资源的路径。在RESTful API中，路径应设计为帮助客户知道发生了什么。(zh_CN)

Conventionally, the first part of the path should be the plural form of the resource. This keeps nested paths simple to read and easy to understand.
传统上，路径的第一部分应该是资源的复数形式。这使嵌套路径易于阅读且易于理解。(zh_CN)

A path like `fashionboutique.com/customers/223/orders/12` is clear in what it points to, even if you’ve never seen this specific path before, because it is hierarchical and descriptive. We can see that we are accessing the order with `id` 12 for the customer with `id` 223.
像这样的道路`fashionboutique.com/customers/223/orders/12` 即使您之前从未见过这条特定的路径，因为它具有层次性和描述性，因此它的含义是明确的。我们可以看到我们正在访问订单`id` 12 为客户提供`id` 223.(zh_CN)

Paths should contain the information necessary to locate a resource with the degree of specificity needed. When referring to a list or collection of resources, it is unnecessary to add an `id` to a POST request to a `fashionboutique.com/customers` path would not need an extra identifier, as the server will generate an `id` for the new object. 
路径应包含查找具有所需特异性程度的资源所需的信息。在引用列表或资源集合时，不必添加`id` 到一个POST请求`fashionboutique.com/customers` path不需要额外的标识符，因为服务器将生成一个`id` 对于新对象。(zh_CN)

If we are trying to access a single resource, we would need to append an `id` to the path.
如果我们试图访问单个资源，我们需要附加一个`id` 到了路上。(zh_CN)
For example:
例如：(zh_CN)
`GET fashionboutique.com/customers/:id` — retrieves the item in the `customers` resource with the `id` specified.
`GET fashionboutique.com/customers/:id` — 检索中的项目`customers` 资源与`id` 指定。(zh_CN)
`DELETE fashionboutique.com/customers/:id` — deletes the item in the `customers` resource with the `id` specified.
`DELETE fashionboutique.com/customers/:id` — 删除中的项目`customers` 资源与`id` 指定。(zh_CN)

### Sending Responses
### 发送回复(zh_CN)

#### Content Types
#### 内容类型(zh_CN)

In cases where the server is sending a data payload to the client, the server must include a `content-type` in the header of the response. This `content-type` header field alerts the client to the type of data it is sending in the response body. These content types are MIME Types, just as they are in the `accept` field of the request header. The `content-type` that the server sends back in the response should be one of the options that the client specified in the `accept` field of the request. 
在服务器向客户端发送数据有效负载的情况下，服务器必须包含a`content-type` 在响应的标题中。这个`content-type` 标题字段警告客户端它在响应正文中发送的数据类型。这些内容类型是MIME类型，就像它们一样`accept` 请求标头的字段。该`content-type` 服务器在响应中发回的应该是客户端在其中指定的选项之一`accept` 请求的字段。(zh_CN)

For example, when a client is accessing a resource with `id` 23 in an `articles` resource with this GET Request:
例如，当客户端正在访问资源时`id` 23 在一个`articles` 此GET请求的资源：(zh_CN)

    GET /articles/23 HTTP/1.1
    Accept: text/html, application/xhtml
    

The server might send back the content with the response header:
服务器可能会使用响应标头发回内容：(zh_CN)

    HTTP/1.1 200 (OK)
    Content-Type: text/html
    

This would signify that the content requested is being returning in the response body with a `content-type` of `text/html`, which the client said it would be able to accept.
这表示请求的内容正在响应正文中返回`content-type` 的`text/html`, 客户表示可以接受。(zh_CN)

#### Response Codes
#### 响应代码(zh_CN)

Responses from the server contain status codes to alert the client to information about the success of the operation. As a developer, you do not need to know every status code (there are [many](http://www.restapitutorial.com/httpstatuscodes.html) of them), but you should know the most common ones and how they are used:
来自服务器的响应包含状态代码，以警告客户端有关操作成功的信息。作为开发人员，您不需要知道每个状态代码（[很多]（http://www.restapitutorial.com/httpstatuscodes.html）），但您应该知道最常见的代码以及它们是如何用过的：(zh_CN)
Status codeMeaning200 (OK)This is the standard response for successful HTTP requests.201 (CREATED)This is the standard response for an HTTP request that resulted in an item being successfully created.204 (NO CONTENT)This is the standard response for successful HTTP requests, where nothing is being returned in the response body.400 (BAD REQUEST)The request cannot be processed because of bad request syntax, excessive size, or another client error.403 (FORBIDDEN)The client does not have permission to access this resource.404 (NOT FOUND)The resource could not be found at this time. It is possible it was deleted, or does not exist yet.500 (INTERNAL SERVER ERROR)The generic answer for an unexpected failure if there is no more specific information available.
状态codeMeaning200（OK）这是成功HTTP请求的标准响应.201（CREATED）这是导致项目成功创建的HTTP请求的标准响应.204（NO CONTENT）这是成功HTTP的标准响应请求，在响应正文中没有返回任何内容.400（BAD REQUEST）由于请求语法错误，大小过大或其他客户端错误，无法处理请求.403（FORBIDDEN）客户端无权访问此资源.404（未找到）此时无法找到资源。它可能已被删除，或者现在还不存在.500（内部服务器错误）如果没有更多特定信息，则意外失败的通用答案。(zh_CN)
For each HTTP verb, there are expected status codes a server should return upon success:
对于每个HTTP谓词，服务器应在成功时返回预期的状态代码：(zh_CN)

- GET — return 200 (OK)
- GET  - 返回200（OK）(zh_CN)
- POST — return 201 (CREATED)
- POST  - 返回201（已创建）(zh_CN)
- PUT  — return 200 (OK)
- PUT  - 返回200（OK）(zh_CN)
- DELETE  — return 204 (NO CONTENT)
- 删除 - 返回204（无内容）(zh_CN)
If the operation fails, return the most specific status code possible corresponding to the problem that was encountered.   
如果操作失败，则返回与遇到的问题相对应的最具体的状态代码。(zh_CN)

#### Examples of Requests and Responses
#### 请求和响应的示例(zh_CN)

Let's say we have an application that allows you to view, create, edit, and delete customers and orders for a small clothing store hosted at `fashionboutique.com`. We could create an HTTP API that allows a client to perform these functions:
假设我们有一个应用程序，允许您查看，创建，编辑和删除托管在其中的小型服装店的客户和订单`fashionboutique.com`. 我们可以创建一个允许客户端执行这些功能的HTTP API：(zh_CN)

If we wanted to view all customers, the request would look like this:
如果我们想要查看所有客户，请求将如下所示：(zh_CN)

    GET http://fashionboutique.com/customers
    Accept: application/json
    

A possible response header would look like:
可能的响应标头如下所示：(zh_CN)

    Status Code: 200 (OK)
    Content-type: application/json
    

followed by the `customers` data requested in `application/json` format.
其次是`customers` 请求的数据`application/json` 格式。(zh_CN)

Create a new customer by posting the data:
通过发布数据创建新客户：(zh_CN)

    POST http://fashionboutique.com/customers
    Body:
    {
      “customer”: {
        “name” = “Scylla Buss”
        “email” = “[[email protected]](https://www.codecademy.com/cdn-cgi/l/email-protection)”
      }
    }
    

The server then generates an `id` for that object and returns it back to the client, with a header like:
然后服务器生成一个`id` 对于该对象并将其返回给客户端，标题如下：(zh_CN)

    201 (CREATED)
    Content-type: application/json
    

To view a single customer we *GET* it by specifying that customer’s id:
要查看单个客户，我们*通过指定客户的ID来获取*：(zh_CN)

    GET http://fashionboutique.com/customers/123
    Accept: application/json
    

A possible response header would look like:
可能的响应标头如下所示：(zh_CN)

    Status Code: 200 (OK)
    Content-type: application/json
    

followed by the data for the `customer` resource with `id` 23 in `application/json` format.
其次是数据`customer` 资源与`id` 23 在`application/json` 格式。(zh_CN)

We can update that customer by _PUT_ting the new data:
我们可以通过_PUT_ting新数据来更新该客户：(zh_CN)

    PUT http://fashionboutique.com/customers/123
    Body:
    {
      “customer”: {
        “name” = “Scylla Buss”
        “email” = “[[email protected]](https://www.codecademy.com/cdn-cgi/l/email-protection)”
      }
    }
    

A possible response header would have `Status Code: 200 (OK)`, to notify the client that the item with `id` 123 has been modified.
一个可能的响应头将有`Status Code: 200 (OK)`, 通知客户端该项目`id` 123 已被修改。(zh_CN)

We can also *DELETE* that customer by specifying its `id`:
我们也可以通过指定客户*删除*该客户`id`:(zh_CN)

    DELETE http://fashionboutique.com/customers/123
    

The response would have a header containing `Status Code: 204 (NO CONTENT)`, notifying the client that the item with `id` 123 has been deleted, and nothing in the body.
响应将包含标题`Status Code: 204 (NO CONTENT)`, 通知客户端该项目`id` 123 已被删除，身体中没有任何内容。(zh_CN)

## Practice with REST
## 用REST练习(zh_CN)

Let’s imagine we are building a photo-collection site for a different want to make an API to keep track of users, venues, and photos of those venues. This site has an `index.html` and a `style.css`. Each user has a username and a password. Each photo has a venue and an owner (i.e. the user who took the picture). Each venue has a name and street address.
让我们假设我们正在构建一个照片收集网站，以便制作一个API来跟踪这些场地的用户，场地和照片。这个网站有一个`index.html` 和a`style.css`. 每个用户都有一个用户名和密码。每张照片都有一个场地和一个所有者（即拍摄照片的用户）。每个场地都有一个名称和街道地址。(zh_CN)
Can you design a REST system that would accommodate:
你能设计一个适合的系统：(zh_CN)

- storing users, photos, and venues
- 存储用户，照片和场所(zh_CN)
- accessing venues and accessing certain photos of a certain venue 
- 访问场地和访问某个场地的某些照片(zh_CN)

Start by writing out:
从写出开始：(zh_CN)

- what kinds of requests we would want to make
- 我们想要提出什么样的要求(zh_CN)
- what responses the server should return
- 服务器应该返回什么响应(zh_CN)
- what the `content-type` of each response should be
- 是什么`content-type` 每个回应应该是(zh_CN)

## Possible Solution - Models
## 可能的解决方案 - 模型(zh_CN)

    {
      “user”: {
        "id": <Integer>,
        “username”: <String>,
        “password”:  <String>
      }
    }
    

    {
      “photo”: {
        "id": <Integer>,
        “venue_id”: <Integer>,
        “author_id”: <Integer>
      }
    }
    

    {
      “venue”: {
        "id": <Integer>,
        “name”: <String>,
        “address”: <String>
      }
    }
    

## Possible Solution - Requests/Responses
## 可能的解决方案 - 请求/响应(zh_CN)

#### GET Requests
#### 获取请求(zh_CN)

Request-
请求-(zh_CN)
`GET /index.html`
Accept: `text/html`
接受：`text/html`(zh_CN)
Response-
响应-(zh_CN)
200 (OK)
Content-type: `text/html`
内容类型：`text/html`(zh_CN)

Request-
请求-(zh_CN)
`GET /style.css`
Accept: `text/css`
接受：`text/css`(zh_CN)
Response-
响应-(zh_CN)
200 (OK)
Content-type: `text/css`
内容类型：`text/css`(zh_CN)

Request-
请求-(zh_CN)
`GET /venues`
Accept:`application/json`
接受：`application/json`(zh_CN)
Response-
响应-(zh_CN)
200 (OK)
Content-type: `application/json`
内容类型：`application/json`(zh_CN)

Request-
请求-(zh_CN)
`GET /venues/:id`
Accept: `application/json`
接受：`application/json`(zh_CN)
Response-
响应-(zh_CN)
200 (OK)
Content-type: `application/json`
内容类型：`application/json`(zh_CN)

Request-
请求-(zh_CN)
`GET /venues/:id/photos/:id`
Accept: `application/json`
接受：`application/json`(zh_CN)
Response-
响应-(zh_CN)
200 (OK)
Content-type: `image/png`
内容类型：`image/png`(zh_CN)

#### POST Requests
#### POST请求(zh_CN)

Request-
请求-(zh_CN)
`POST /users`
Response-
响应-(zh_CN)
201 (CREATED)
201 (创建）(zh_CN)
Content-type: `application/json`
内容类型：`application/json`(zh_CN)

Request-
请求-(zh_CN)
`POST /venues`
Response-
响应-(zh_CN)
201 (CREATED)
201 (创建）(zh_CN)
Content-type: `application/json`
内容类型：`application/json`(zh_CN)

Request-
请求-(zh_CN)
`POST /venues/:id/photos`
Response-
响应-(zh_CN)
201 (CREATED)
201 (创建）(zh_CN)
Content-type: `application/json`
内容类型：`application/json`(zh_CN)

#### PUT Requests
#### PUT请求(zh_CN)

Request-
请求-(zh_CN)
`PUT /users/:id`
Response-
响应-(zh_CN)
200 (OK)

Request-
请求-(zh_CN)
`PUT /venues/:id`
Response-
响应-(zh_CN)
200 (OK)

Request-
请求-(zh_CN)
`PUT /venues/:id/photos/:id`
Response-
响应-(zh_CN)
200 (OK)

#### DELETE Requests
#### 删除请求(zh_CN)

Request-
请求-(zh_CN)
`DELETE /venues/:id`
Response-
响应-(zh_CN)
204 (NO CONTENT)
204 (无内容）(zh_CN)

Request-
请求-(zh_CN)
`DELETE /venues/:id/photos/:id`
Response-
响应-(zh_CN)
204 (NO CONTENT)
204 (无内容）(zh_CN)
{% endraw %}
