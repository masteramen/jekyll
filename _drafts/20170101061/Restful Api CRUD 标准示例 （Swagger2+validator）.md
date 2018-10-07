---
layout: post
title:  "Restful Api CRUD 标准示例 （Swagger2+validator）"
title2:  "Restful Api CRUD 标准示例 （Swagger2+validator）"
date:   2017-01-01 23:52:41  +0800
source:  "http://www.jfox.info/restfulapicrud%e6%a0%87%e5%87%86%e7%a4%ba%e4%be%8bswagger2validator.html"
fileName:  "20170101061"
lang:  "zh_CN"
published: true
permalink: "restfulapicrud%e6%a0%87%e5%87%86%e7%a4%ba%e4%be%8bswagger2validator.html"
---
{% raw %}
为什么要写这篇贴？

　　要写一个最简单的CRUD 符合 Restful Api    规范的  一个Controller， 想百度搜索一下 直接复制拷贝 简单修改一下 方法内代码。

　　然而， 搜索结果让我无语到家。 没一个是正在符合 Restful Api 规范的实例。 最无语的是 你呀直接 JSP 页面了，还说什么  Restful Api 啊！！！

　　为方便以后自己复制拷贝使用，我把自己刚写的贴出来。

    **Swagger2：**

    @Configuration
    @EnableSwagger2
    publicclass Swagger2
    {
        @Bean
        public Docket createRestApi() {
            returnnew Docket(DocumentationType.SWAGGER_2)
                    .apiInfo(apiInfo())
                    .select()
                    .apis(RequestHandlerSelectors.basePackage("com.dj.edi.web"))
                    .paths(PathSelectors.any())
                    .build();
        }
    
        private ApiInfo apiInfo() {
            returnnew ApiInfoBuilder()
                    .title("EID 用户 CRUD")
                    .description("EID 用户 CRUD")
                    .version("1.0")
                    .build();
        }
    
    }

    **Application：
    **

    @SpringBootApplication
    @Import(springfox.bean.validators.configuration.BeanValidatorPluginsConfiguration.class)
    publicclass ComEdiOrderUserApplication
    {
        publicstaticvoid main(String[] args) {SpringApplication.run(ComEdiOrderUserApplication.class, args);}
    
    }

    **UserApiController:**

    @RestController
    @RequestMapping("/v1/user")
    publicclass UserApiController
    {
        privatestaticfinal Logger LOGGER = LoggerFactory.getLogger(UserApiController.class);
    
        @Autowired
        private ClientUsersRepository repository;
    
        @ApiOperation(value = "获取所有用户数据")
        @RequestMapping(value = "/list", method = RequestMethod.GET)
        public ResponseEntity<List<ClientUsers>> getClientUsersList() {
            try {
                return ResponseEntity.ok(repository.findAll());
            } catch (Exception e) {
                LOGGER.info(" 获取所有用户数据异常 " + e.getMessage(), e);
                return ResponseEntity.status(500).body(null);
            }
        }
    
        @ApiOperation(value = "获取用户数据")
        @ApiImplicitParam(name = "id", value = "用户ID", required = true, dataType = "String", paramType = "path")
        @RequestMapping(value = "/{id}", method = RequestMethod.GET)
        public ResponseEntity<ClientUsers> getClientUsers(@PathVariable String id) {
            try {
                return ResponseEntity.ok(repository.findOne(id));
            } catch (Exception e) {
                LOGGER.info(" 获取用户数据  " + id + "  数据异常 " + e.getMessage(), e);
                return ResponseEntity.status(500).body(null);
            }
        }
    
        @ApiOperation(value = "创建用户", notes = "根据User对象创建用户")
        @ApiImplicitParam(name = "users", value = "用户详细实体user", required = true, dataType = "ClientUsers", paramType = "body")
        @RequestMapping(method = RequestMethod.POST)
        public ResponseEntity<ClientUsers> createUser(@Valid @RequestBody ClientUsers users) {
            try {
    
                users.setId(ObjectId.get().toString());
                return ResponseEntity.ok(repository.save(users));
    
            } catch (Exception e) {
                LOGGER.info(" 创建用户  " + users + "  数据异常 " + e.getMessage(), e);
                return ResponseEntity.status(500).body(null);
            }
        }
    
        @ApiOperation(value = "更新用户详细信息", notes = "根据url的id来指定更新对象，并根据传过来的user信息来更新用户详细信息")
        @ApiImplicitParams({
                @ApiImplicitParam(name = "id", value = "用户ID", required = true, dataType = "String", paramType = "path"),
                @ApiImplicitParam(name = "user", value = "用户详细实体user", required = true, dataType = "ClientUsers", paramType = "body")
        })
        @RequestMapping(value = "{id}", method = RequestMethod.PUT)
        public ResponseEntity<ClientUsers> updateUser(@PathVariable("id") String id,@Valid @RequestBody ClientUsers user) {
            try {
                user.setId(id);
                return ResponseEntity.ok(repository.save(user));
            } catch (Exception e) {
                LOGGER.info(" 更新用户  " + user + "  数据异常 " + e.getMessage(), e);
                return ResponseEntity.status(500).body(null);
            }
        }
    
        @ApiOperation(value = "删除用户", notes = "根据url的id来指定删除对象")
        @ApiImplicitParam(name = "id", value = "用户ID", required = true, dataType = "String", paramType = "path")
        @RequestMapping(value = "{id}", method = RequestMethod.DELETE)
        public ResponseEntity<String> deleteUser(@PathVariable String id) {
            try {
                repository.delete(id);
                return ResponseEntity.ok("ok");
            } catch (Exception e) {
                LOGGER.info(" 删除用户  " + id + "  数据异常 " + e.getMessage(), e);
                return ResponseEntity.status(500).body(null);
            }
        }
    }

    **ClientUsersRepository:
    **

    @Component
    publicinterface ClientUsersRepository extends MongoRepository<ClientUsers, String>
    {
        ClientUsers findByips(String ip);
        ClientUsers findByclientFlag(String clientFlag);
    }

    **ClientUsers:
    **

    @Data
    publicclass ClientUsers implements Serializable
    {
    
        @Id
        private String id;
    
        /**
         * 用户名称
         */
        @NotBlank(message = "用户名称 不能为空")
        @Pattern(regexp = "^(?!string)",message = "不能是 stirng")
        private String userName;
    
        /**
         * ip
         */
        @NotNull(message = "ip 至少需要个")
        private List<String> ips;
    
        /**
         * 标识
         */
        @NotBlank(message = " 标识 不能为空")
        @Pattern(regexp = "^(?!string)",message = "不能是 stirng")
        private String clientFlag;
    
        /**
         * 客户服务ID
         */
        @NotBlank(message = "客户服务ID 不能为空")
        @Pattern(regexp = "^(?!string)",message = "不能是 stirng")
        private String checkID;
    }

    **有哪里不好的希望指正**

    ** **
{% endraw %}
