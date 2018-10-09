---
layout: post
title:  "译见｜构建用户管理微服务（五）：使用 JWT 令牌和 Spring Security 来实现身份验证"
title2:  "译见｜构建用户管理微服务（五）：使用 JWT 令牌和 Spring Security 来实现身份验证"
date:   2017-01-01 23:53:26  +0800
source:  "https://www.jfox.info/%e8%af%91%e8%a7%81%e6%9e%84%e5%bb%ba%e7%94%a8%e6%88%b7%e7%ae%a1%e7%90%86%e5%be%ae%e6%9c%8d%e5%8a%a1%e4%ba%94%e4%bd%bf%e7%94%a8jwt%e4%bb%a4%e7%89%8c%e5%92%8cspringsecurity%e6%9d%a5%e5%ae%9e%e7%8e%b0.html"
fileName:  "20170101106"
lang:  "zh_CN"
published: true
permalink: "2017/%e8%af%91%e8%a7%81%e6%9e%84%e5%bb%ba%e7%94%a8%e6%88%b7%e7%ae%a1%e7%90%86%e5%be%ae%e6%9c%8d%e5%8a%a1%e4%ba%94%e4%bd%bf%e7%94%a8jwt%e4%bb%a4%e7%89%8c%e5%92%8cspringsecurity%e6%9d%a5%e5%ae%9e%e7%8e%b0.html"
---
{% raw %}
本期的“译见”, 将带您探索 Spring Security 是如何同 JWT 令牌一起使用的。

![](/wp-content/uploads/2017/07/1499350548.gif)

在往期“译见”系列的文章中，我们已经创建了业务逻辑、数据访问层和前端控制器, 但是忽略了对身份进行验证。随着 Spring Security 成为实际意义上的标准, 将会在在构建 Java web 应用程序的身份验证和授权时使用到它。在构建用户管理微服务系列的第五部分中, 将带您探索 Spring Security 是如何同 JWT 令牌一起使用的。

### 有关 Token | 船长导语

诸如 Facebook，Github，Twitter 等大型网站都在使用基于 Token 的身份验证。相比传统的身份验证方法，Token 的扩展性更强，也更安全，非常适合用在 Web 应用或者移动应用上。我们将 Token 翻译成令牌，也就意味着，你能依靠这个令牌去通过一些关卡，来实现验证。实施 Token 验证的方法很多，JWT 就是相关标准方法中的一种。

### 关于 JWT 令牌

JSON Web TOKEN（JWT）是一个开放的标准 （RFC 7519）, 它定义了一种简洁且独立的方式, 让在各方之间的 JSON 对象安全地传输信息。而经过数字签名的信息也可以被验证和信任。

JWT 的应用越来越广泛, 而因为它是轻量级的，你也不需要有一个用来验证令牌的认证服务器。与 OAuth 相比, 这有利有弊。如果 JWT 令牌被截获，它可以用来模拟用户, 也无法防范使用这个被截获的令牌继续进行身份验证。

真正的 JWT 令牌看起来像下面这样：

    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
    eyJzdWIiOiJsYXN6bG9fQVRfc3ByaW5ndW5pX0RPVF9jb20iLCJuYW1lIjoiTMOhc3psw7MgQ3NvbnRvcyIsImFkbWluIjp0cnVlfQ.
    XEfFHwFGK0daC80EFZBB5ki2CwrOb7clGRGlzchAD84
    

JWT 令牌的第一部分是令牌的 header , 用于标识令牌的类型和对令牌进行签名的算法。

    { 
     "alg": "HS256", "typ": "JWT"
     
    }
    

第二部分是 JWT 令牌的 payload 或它的声明。这两者是有区别的。Payload 可以是任意一组数据, 它甚至可以是明文或其他 （嵌入 JWT）的数据。而声明则是一组标准的字段。

    { 
     "sub": "laszlo_AT_springuni_DOT_com", "name": "László Csontos", "admin": true
     
    }
    

第三部分是由算法产生的、由 JWT 的 header 表示的签名。

#### 创建和验证 JWT 令牌

有相当多的第三方库可用于操作 JWT 令牌。而在本文中, 我使用了 JJWT。

    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt</artifactId>
        <version>0.7.0</version>
    </dependency>
    

采用 JwtTokenService 使 JWT 令牌从身份验证实例中创建, 并将 JWTs 解析回身份验证实例。

    public class JwtTokenServiceImpl implements JwtTokenService {  
     
    private static final String AUTHORITIES = "authorities";  
     
    static final String SECRET = "ThisIsASecret";
     
      @Override  
    public String createJwtToken(Authentication authentication, int minutes) {
        Claims claims = Jwts.claims()
            .setId(String.valueOf(IdentityGenerator.generate()))
            .setSubject(authentication.getName())
            .setExpiration(new Date(currentTimeMillis() + minutes * 60 * 1000))
            .setIssuedAt(new Date());
     
        String authorities = authentication.getAuthorities()
            .stream()
            .map(GrantedAuthority::getAuthority)
            .map(String::toUpperCase)
            .collect(Collectors.joining(","));
     
        claims.put(AUTHORITIES, authorities);    
     
    return Jwts.builder()
            .setClaims(claims)
            .signWith(HS512, SECRET)
            .compact();
      }
     
      @Override  
    public Authentication parseJwtToken(String jwtToken) throws AuthenticationException {    
    try {
          Claims claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(jwtToken)
                .getBody();      
    return JwtAuthenticationToken.of(claims);
        } catch (ExpiredJwtException | SignatureException e) {      
    throw new BadCredentialsException(e.getMessage(), e);
        } catch (UnsupportedJwtException | MalformedJwtException e) {      
    throw new AuthenticationServiceException(e.getMessage(), e);
        } catch (IllegalArgumentException e) {      
    throw new InternalAuthenticationServiceException(e.getMessage(), e);
        }
      }
     
    }
    

根据实际的验证，parseClaimsJws () 会引发各种异常。在 parseJwtToken () 中, 引发的异常被转换回 AuthenticationExceptions。虽然 JwtAuthenticationEntryPoint 能将这些异常转换为各种 HTTP 的响应代码, 但它也只是重复 DefaultAuthenticationFailureHandler 来以 http 401 (未经授权) 响应。

### 登录和身份验证过程

基本上, 认证过程有两个短语, 让后端将服务用于单页面 web 应用程序。

#### 登录时创建 JWT 令牌

第一次登录变完成启动, 且在这一过程中, 将创建一个 JWT 令牌并将其发送回客户端。这些是通过以下请求完成的：

    POST /session
    {   
      "username": "laszlo_AT_sprimguni_DOT_com",
       "password": "secret"
    }
    

成功登录后, 客户端会像往常一样向其他端点发送后续请求, 并在授权的 header 中提供本地缓存的 JWT 令牌。

    Authorization: Bearer <JWT token>
    

![](/wp-content/uploads/2017/07/1499350552.png)

正如上面的步骤所讲, LoginFilter 开始进行登录过程。而Spring Security 的内置 UsernamePasswordAuthenticationFilter 被延长, 来让这种情况发生。这两者之间的唯一的区别是, UsernamePasswordAuthenticationFilter 使用表单参数来捕获用户名和密码, 相比之下, LoginFilter 将它们视做 JSON 对象。

    import org.springframework.security.authentication.*;
    import org.springframework.security.core.*;
    import org.springframework.security.web.authentication.*;
     
    public class LoginFilter extends UsernamePasswordAuthenticationFilter {  
    private static final String LOGIN_REQUEST_ATTRIBUTE = "login_request";
     
      ...
     
      @Override  
    public Authentication attemptAuthentication(
          HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {    
    try {
          LoginRequest loginRequest =
              objectMapper.readValue(request.getInputStream(), LoginRequest.class);
     
          request.setAttribute(LOGIN_REQUEST_ATTRIBUTE, loginRequest);      
    return super.attemptAuthentication(request, response);
        } catch (IOException ioe) {      
    throw new InternalAuthenticationServiceException(ioe.getMessage(), ioe);
        } finally {
          request.removeAttribute(LOGIN_REQUEST_ATTRIBUTE);
        }
      }
     
      @Override  
    protected String obtainUsername(HttpServletRequest request) {    
    return toLoginRequest(request).getUsername();
      }
     
      @Override  
    protected String obtainPassword(HttpServletRequest request) {    
    return toLoginRequest(request).getPassword();
      }  
    private LoginRequest toLoginRequest(HttpServletRequest request) {    return (LoginRequest)request.getAttribute(LOGIN_REQUEST_ATTRIBUTE);
      }
     
    }
    

处理登陆过程的结果将在之后分派给一个 AuthenticationSuccessHandler 和 AuthenticationFailureHandler。

两者都相当简单。DefaultAuthenticationSuccessHandler 调用 JwtTokenService 发出一个新的令牌, 然后将其发送回客户端。

    public class DefaultAuthenticationSuccessHandler implements AuthenticationSuccessHandler {  
     
    private static final int ONE_DAY_MINUTES = 24 * 60;  
     
    private final JwtTokenService jwtTokenService;  
    private final ObjectMapper objectMapper;  
     
    public DefaultAuthenticationSuccessHandler(
          JwtTokenService jwtTokenService, ObjectMapper objectMapper) {    
    this.jwtTokenService = jwtTokenService;    
    this.objectMapper = objectMapper;
      }
     
      @Override  
    public void onAuthenticationSuccess(
          HttpServletRequest request, HttpServletResponse response, Authentication authentication)      
    throws IOException {
     
        response.setContentType(APPLICATION_JSON_VALUE);
     
        String jwtToken = jwtTokenService.createJwtToken(authentication, ONE_DAY_MINUTES);
        objectMapper.writeValue(response.getWriter(), jwtToken);
      }
     
    }
    

以下是它的对应, DefaultAuthenticationFailureHandler, 只是发送回一个 http 401 错误消息。

    public class DefaultAuthenticationFailureHandler implements AuthenticationFailureHandler {  
     
    private static final Logger LOGGER =
          LoggerFactory.getLogger(DefaultAuthenticationFailureHandler.class);  
     
    private final ObjectMapper objectMapper;  
     
    public DefaultAuthenticationFailureHandler(ObjectMapper objectMapper) {    
    this.objectMapper = objectMapper;
      }
     
      @Override  
    public void onAuthenticationFailure(
          HttpServletRequest request, HttpServletResponse response, AuthenticationException exception)      
    throws IOException {
     
        LOGGER.warn(exception.getMessage());
     
        HttpStatus httpStatus = translateAuthenticationException(exception);
     
        response.setStatus(httpStatus.value());
        response.setContentType(APPLICATION_JSON_VALUE);
     
        writeResponse(response.getWriter(), httpStatus, exception);
      }  
    protected HttpStatus translateAuthenticationException(AuthenticationException exception) {    
    return UNAUTHORIZED;
      }  
    protected void writeResponse(
          Writer writer, HttpStatus httpStatus, AuthenticationException exception) throws IOException {
     
        RestErrorResponse restErrorResponse = RestErrorResponse.of(httpStatus, exception);
        objectMapper.writeValue(writer, restErrorResponse);
      }
     
    }
    

#### 处理后续请求

在客户端登陆后, 它将在本地缓存 JWT 令牌, 并在前面讨论的后续请求中发送反回。

![](/wp-content/uploads/2017/07/1499350553.png)

对于每个请求, JwtAuthenticationFilter 通过 JwtTokenService 验证接收到的 JWT令牌。

    public class JwtAuthenticationFilter extends OncePerRequestFilter {  
     
    private static final Logger LOGGER =
          LoggerFactory.getLogger(JwtAuthenticationFilter.class);  
     
    private static final String AUTHORIZATION_HEADER = "Authorization";  
    private static final String TOKEN_PREFIX = "Bearer";  
     
    private final JwtTokenService jwtTokenService;  
     
    public JwtAuthenticationFilter(JwtTokenService jwtTokenService) {    
    this.jwtTokenService = jwtTokenService;
      }
     
      @Override  
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
          FilterChain filterChain) throws ServletException, IOException {
     
        Authentication authentication = getAuthentication(request);    
    if (authentication == null) {
          SecurityContextHolder.clearContext();
          filterChain.doFilter(request, response);     
     return;
        }    
     
     try {
          SecurityContextHolder.getContext().setAuthentication(authentication);
          filterChain.doFilter(request, response);
        } finally {
          SecurityContextHolder.clearContext();
        }
      }  private Authentication getAuthentication(HttpServletRequest request) {
        String authorizationHeader = request.getHeader(AUTHORIZATION_HEADER);    if (StringUtils.isEmpty(authorizationHeader)) {
          LOGGER.debug("Authorization header is empty.");      
    return null;
        }    if (StringUtils.substringMatch(authorizationHeader, 0, TOKEN_PREFIX)) {
          LOGGER.debug("Token prefix {} in Authorization header was not found.", TOKEN_PREFIX);      
                return null;
        }
     
        String jwtToken = authorizationHeader.substring(TOKEN_PREFIX.length() + 1);    try {      
          return jwtTokenService.parseJwtToken(jwtToken);
        } catch (AuthenticationException e) {
          LOGGER.warn(e.getMessage());      
          return null;
        }
      }
     
    }
    

如果令牌是有效的, 则会实例化 JwtAuthenticationToken, 并执行线程的 SecurityContext。而由于恢复的 JWT 令牌包含唯一的 ID 和经过身份验证的用户的权限, 因此无需与数据库联系以再次获取此信息。

    public class JwtAuthenticationToken extends AbstractAuthenticationToken {  
     
    private static final String AUTHORITIES = "authorities"; 
     
    private final long userId;  
     
    private JwtAuthenticationToken(long userId, Collection<? extends GrantedAuthority> authorities) {    
    super(authorities);    
    this.userId = userId;
      }
     
      @Override  
    public Object getCredentials() {    
    return null;
      }
     
      @Override  
    public Long getPrincipal() {    
    return userId;
      }  /**   * Factory method for creating a new {@code {@link JwtAuthenticationToken}}.   * @param claims JWT claims   * @return a JwtAuthenticationToken   */
      
    public static JwtAuthenticationToken of(Claims claims) {    
    long userId = Long.valueOf(claims.getSubject());
     
        Collection<GrantedAuthority> authorities =
            Arrays.stream(String.valueOf(claims.get(AUTHORITIES)).split(","))
                .map(String::trim)
                .map(String::toUpperCase)
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toSet());
     
        JwtAuthenticationToken jwtAuthenticationToken = new JwtAuthenticationToken(userId, authorities);
     
        Date now = new Date();
        Date expiration = claims.getExpiration();
        Date notBefore = claims.getNotBefore();
        jwtAuthenticationToken.setAuthenticated(now.after(notBefore) && now.before(expiration));    return jwtAuthenticationToken;
      }
     
    }
    

在这之后, 它由安全框架决定是否允许或拒绝请求。

### Spring Security 在 Java EE 世界中有竞争者吗？

虽然这不是这篇文章的主题, 但我想花一分钟的时间来谈谈。如果我不得不在一个 JAVA EE 应用程序中完成所有这些？Spring Security 真的是在 JAVA 中实现身份验证和授权的黄金标准吗？

#### 让我们做个小小的研究！

JAVA EE 8 指日可待，他将在 2017 年年底发布，我想看看它是否会是 Spring Security 一个强大的竞争者。我发现 JAVA EE 8 将提供 JSR-375 , 这应该会缓解 JAVA EE 应用程序的安全措施的发展。它的参考实施被称为 Soteira, 是一个相对新的 github 项目。那就是说, 现在的答案是真的没有这样的一个竞争者。

但这项研究是不完整的，并没有提到 Apache Shiro。虽然我从未使用过，但我听说这算是更为简单的 Spring Security。让它更 JWT 令牌 一起使用也不是不可能。从这个角度来看，Apache Shiro 是算 Spring Security 的一个的有可比性的替代品

下期预告：构建用户管理微服务（六）：添加持久 JWT 令牌的身份验证

原文链接：https://www.springuni.com/user-management-microservice-part-5
{% endraw %}
