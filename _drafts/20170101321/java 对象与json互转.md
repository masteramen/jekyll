---
layout: post
title:  "java 对象与json互转"
title2:  "java 对象与json互转"
date:   2017-01-01 23:57:01  +0800
source:  "https://www.jfox.info/java%e5%af%b9%e8%b1%a1%e4%b8%8ejson%e4%ba%92%e8%bd%ac.html"
fileName:  "20170101321"
lang:  "zh_CN"
published: true
permalink: "2017/java%e5%af%b9%e8%b1%a1%e4%b8%8ejson%e4%ba%92%e8%bd%ac.html"
---
{% raw %}
有时为了项目需求，会将对象数据转换成json数据，以下是个人根据项目需求实现的方法。

   项目中需要将数据格式：

    [{
        "node": "0",   
        "index": null,
        "status": null,
        "preNode": null,
        "postNode": [{
            "node": "xxx_4"
        },
        {
            "node": "xxx_3"
        },
        {
            "node": "xxx_2"
        },
        {
            "node": "xxx_14"
        }]
    },
    {
        "node": "xxx_2",
        "index": "index_1",
        "status": "表达式1",
        "preNode": [{
            "node": "xxx_0"
        }],
        "postNode": [{
            "node": "xxx_5"
        }]
    },
    {
        "node": "xxx_14",
        "index": "index_4",
        "status": "表达式5",
        "preNode": [{
            "node": "xxx_0"
        }],
        "postNode": [{
            "node": "xxx_13"
        },
        {
            "node": "xxx_5"
        }]
    },
    {
        "node": "xxx_3",
        "index": "index_2",
        "status": "表达式2",
        "preNode": [{
            "node": "xxx_0"
        }],
        "postNode": [{
            "node": "xxx_5"
        }]
    },
    {
        "node": "xxx_4",
        "index": "index_3",
        "status": "表达式3",
        "preNode": [{
            "node": "xxx_0"
        }],
        "postNode": [{
            "node": "xxx_12"
        }]
    },
    {
        "node": "xxx_5",
        "index": "index_4",
        "status": "表达式4",
        "preNode": [{
            "node": "xxx_3"
        },
        {
            "node": "xxx_2"
        },
        {
            "node": "xxx_14"
        }],
        "postNode": [{
            "node": "xxx_6"
        }]
    },
    {
        "node": "xxx_6",
        "index": "index_5",
        "status": "表达式6",
        "preNode": [{
            "node": "xxx_5"
        }],
        "postNode": [{
            "node": "xxx_7"
        }]
    },
    {
        "node": "xxx_7",
        "index": "index_6",
        "status": "表达式7",
        "preNode": [{
            "node": "xxx_6"
        }],
        "postNode": [{
            "node": "xxx_8"
        }]
    },
    {
        "node": "xxx_8",
        "index": "index_4",
        "status": "表达式8",
        "preNode": [{
            "node": "xxx_7"
        }],
        "postNode": [{
            "node": "xxx_9"
        },
        {
            "node": "xxx_10"
        }]
    },
    {
        "node": "xxx_9",
        "index": "index_5",
        "status": "表达式5",
        "preNode": [{
            "node": "xxx_8"
        }],
        "postNode": [{
            "node": "xxx_11"
        }]
    },
    {
        "node": "xxx_10",
        "index": "index_7",
        "status": "表达式6",
        "preNode": [{
            "node": "xxx_8"
        }],
        "postNode": [{
            "node": "xxx_11"
        }]
    },
    {
        "node": "xxx_11",
        "index": "index_8",
        "status": "表达式7",
        "preNode": [{
            "node": "xxx_9"
        },
        {
            "node": "xxx_10"
        }],
        "postNode": [{
            "node": "xxx_12"
        }]
    },
    {
        "node": "xxx_12",
        "index": "index_8",
        "status": "表达式7",
        "preNode": [{
            "node": "xxx_11"
        },
        {
            "node": "xxx_4"
        }],
        "postNode": [{
            "node": "xxx_13"
        }]
    },
    {
        "node": "xxx_13",
        "index": "",
        "status": "",
        "preNode": [{
            "node": "xxx_14"
        },
        {
            "node": "xxx_12"
        }],
        "postNode": []
    },
    {
        "node": "9999",
        "index": null,
        "status": null,
        "preNode": [{
            "node": "xxx_14"
        },
        {
            "node": "xxx_12"
        }],
        "postNode": null
    }]

     项目中list对象内容

     1 JsonModel{node='xxx_2', preNode='', index='index_1', status='表达式1'}
     2 JsonModel{node='xxx_14', preNode='', index='index_4', status='表达式5'}
     3 JsonModel{node='xxx_3', preNode='', index='index_2', status='表达式2'}
     4 JsonModel{node='xxx_4', preNode='', index='index_3', status='表达式3'}
     5 JsonModel{node='xxx_5', preNode='xxx_2', index='index_4', status='表达式4'}
     6 JsonModel{node='xxx_5', preNode='xxx_3', index='index_4', status='表达式5'}
     7 JsonModel{node='xxx_5', preNode='xxx_14', index='index_4', status='表达式5'}
     8 JsonModel{node='xxx_6', preNode='xxx_5', index='index_5', status='表达式6'}
     9 JsonModel{node='xxx_7', preNode='xxx_6', index='index_6', status='表达式7'}
    10 JsonModel{node='xxx_8', preNode='xxx_7', index='index_4', status='表达式8'}
    11 JsonModel{node='xxx_9', preNode='xxx_8', index='index_5', status='表达式5'}
    12 JsonModel{node='xxx_10', preNode='xxx_8', index='index_7', status='表达式6'}
    13 JsonModel{node='xxx_11', preNode='xxx_10', index='index_8', status='表达式7'}
    14 JsonModel{node='xxx_11', preNode='xxx_9', index='index_8', status='表达式8'}
    15 JsonModel{node='xxx_12', preNode='xxx_11', index='index_8', status='表达式7'}
    16 JsonModel{node='xxx_12', preNode='xxx_4', index='index_8', status='表达式8'}
    17 JsonModel{node='xxx_13', preNode='xxx_14', index='', status='表达式13'}
    18 JsonModel{node='xxx_13', preNode='xxx_12', index='', status='表达式14'}

    publicvoid testJson() throws Exception{
            List<JsonModel> list=new ArrayList<>();
            ObjectMapper objectMapper=new ObjectMapper();
    
            JsonModel jsonModel=new JsonModel("xxx_2","","index_1","表达式1");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_14","","index_4","表达式5");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_3","","index_2","表达式2");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_4","","index_3","表达式3");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_5","xxx_2","index_4","表达式4");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_5","xxx_3","index_4","表达式5");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_5","xxx_14","index_4","表达式5");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_6","xxx_5","index_5","表达式6");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_7","xxx_6","index_6","表达式7");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_8","xxx_7","index_4","表达式8");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_9","xxx_8","index_5","表达式5");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_10","xxx_8","index_7","表达式6");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_11","xxx_10","index_8","表达式7");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_11","xxx_9","index_8","表达式8");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_12","xxx_11","index_8","表达式7");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_12","xxx_4","index_8","表达式8");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_13","xxx_14","","表达式13");
            list.add(jsonModel);
    
            jsonModel=new JsonModel("xxx_13","xxx_12","","表达式14");
            list.add(jsonModel);
    
            list.forEach(var->
                    System.out.println(var.toString())
            );
            System.out.println();
    
    
            //将list转成String
            String str=objectMapper.writeValueAsString(list);
    
            //将字符串转成JsonNode
            JsonNode rootNode = objectMapper.readTree(str);
    
            Set<ChildNode> preNode_set=null;
            Set<ChildNode> postNode_set=null;
    
            List<Node> nodeList=new ArrayList<>();
    
            //寻找第一个indxe 创建一个start节点
            Node node=new Node();
            node.setNode("0");
            Set<ChildNode> childNodeList=new HashSet<>();
            for(int i=0;i<rootNode.size();i++){
    
                if("".equals(rootNode.get(i).get("preNode").asText())){
                   childNodeList.add(new ChildNode(rootNode.get(i).get("node").asText()));
                }
            }
            node.setPostNode(childNodeList);
            nodeList.add(node);
    
            //这种方式在如果我们只需要一个长json串中某个字段值时非常方便for (int i=0;i<rootNode.size();){
    
                preNode_set=new HashSet<>();
                postNode_set=new HashSet<>();
    
                //直接从rootNode中获取某个键的值，
                JsonNode nameNode = (rootNode.get(i)).get("node");
                String name = nameNode.asText();
    
                String index=rootNode.get(i).get("index").asText();
                String status=rootNode.get(i).get("status").asText();
    
                //找出后置节点  post_nodefor(int j=i+1;j<rootNode.size();j++){
                    String names = (rootNode.get(j)).get("preNode").asText();
    
                    if(name.equals(names)){
    
                        //  if(!"".equals(rootNode.get(j).get("postNode").asText())) {
                        postNode_set.add(new ChildNode((rootNode.get(j)).get("node").asText()));
                        //}                }
                }
    
                //找前置节点for(int j=0;j<list.size();j++){
                    String names = (rootNode.get(j)).get("node").asText();
    
                    //对于后一个的index相同时  需要跳过if(name.equals(names)){
    
                            if(!"".equals(rootNode.get(j).get("preNode").asText())){
                                preNode_set.add(new ChildNode((rootNode.get(j)).get("preNode").asText()));
                                if(j>i){
                                    ++i;
                                }else{
                                    i++;
                                }
                            }else{
                                preNode_set.add(new ChildNode("0"));
                                i++;
                            }
                        }
                }
    
                Node nodes=new Node();
    
                nodes.setIndex(index);
                nodes.setNode(name);
                nodes.setStatus(status);
                nodes.setPostNode(postNode_set);
                nodes.setPreNode(preNode_set);
    
                nodeList.add(nodes);
    
            }
    
            //后置节点
            Node pre_node=new Node();
            pre_node.setNode("9999");
            Set<ChildNode> childNodes=new HashSet<>();
            for(int i=0;i<rootNode.size();i++){
    
                //最后一个end 节点的pre_nodeif("".equals(rootNode.get(i).get("index").asText())){
    
                    childNodes.add(new ChildNode(rootNode.get(i).get("preNode").asText()));
                }
            }
            pre_node.setPreNode(childNodes);
            nodeList.add(pre_node);
    
            String s = objectMapper.writeValueAsString(nodeList);
            System.out.println(s);
    
            System.out.println();
            jsonTest(s);
    
        }
    
        /**
         * <p>json --> 对象</p>
         * @param s
         * @throws Exception
         */publicvoid jsonTest(String s) throws Exception{
            List<Node> nodeList=new ArrayList<>();
            ObjectMapper objectMapper=new ObjectMapper();
    　　　　　　
    //将字符串用objectMapper转换成jsonNode
            JsonNode jsonNode=objectMapper.readTree(s);
    
            List<JsonModel> jsonModels=new ArrayList<>();
    
            for(int i=1;i<jsonNode.size()-1;i++){
                String index=jsonNode.get(i).get("index").asText();
                String status=jsonNode.get(i).get("status").asText();
                String node=jsonNode.get(i).get("node").asText();
    
                for(int j=0;j<jsonNode.get(i).get("preNode").size();j++){
                    String childNode= jsonNode.get(i).get("preNode").get(j).get("node").asText();
                    JsonModel jsonModel=new JsonModel(node,childNode,index,status);
                    jsonModels.add(jsonModel);
                }
            }
            jsonModels.forEach(val->
                    System.out.println(val.toString())
            );
        }

以下是所用到的对象实体类
![](/wp-content/uploads/2017/07/1500290334.gif)![](/wp-content/uploads/2017/07/15002903341.gif)
     1package com.yf.af.biz.test;
     2 3/** 4 * Created by chen on 2017/7/14.
     5*/ 6publicclass JsonModel {
     7private String node;
     8private String preNode;
     9private String index;
    10private String status;
    1112public String getNode() {
    13return node;
    14    }
    1516publicvoid setNode(String node) {
    17this.node = node;
    18    }
    1920public String getPreNode() {
    21return preNode;
    22    }
    2324publicvoid setPreNode(String preNode) {
    25this.preNode = preNode;
    26    }
    2728public String getIndex() {
    29return index;
    30    }
    3132publicvoid setIndex(String index) {
    33this.index = index;
    34    }
    3536public String getStatus() {
    37return status;
    38    }
    3940publicvoid setStatus(String status) {
    41this.status = status;
    42    }
    4344public JsonModel(String node, String preNode, String index, String status) {
    45this.node = node;
    46this.preNode = preNode;
    47this.index = index;
    48this.status = status;
    49    }
    5051public JsonModel() {
    52    }
    5354    @Override
    55public String toString() {
    56return "JsonModel{" +
    57                 "node='" + node + '\'' +
    58                 ", preNode='" + preNode + '\'' +
    59                 ", index='" + index + '\'' +
    60                 ", status='" + status + '\'' +
    61                 '}';
    62    }
    63 }

View Code![](/wp-content/uploads/2017/07/1500290334.gif)![](/wp-content/uploads/2017/07/15002903341.gif)
     1package com.yf.af.biz.test;
     2 3import java.util.List;
     4import java.util.Set;
     5 6/** 7 * Created by chen on 2017/7/15.
     8*/ 9publicclass Node {
    10private String node;
    11private String index;
    12private String status;
    1314private Set<ChildNode> preNode;
    1516private Set<ChildNode> postNode;
    1718public String getNode() {
    19return node;
    20    }
    2122publicvoid setNode(String node) {
    23this.node = node;
    24    }
    2526public String getIndex() {
    27return index;
    28    }
    2930publicvoid setIndex(String index) {
    31this.index = index;
    32    }
    3334public String getStatus() {
    35return status;
    36    }
    3738publicvoid setStatus(String status) {
    39this.status = status;
    40    }
    4142public Set<ChildNode> getPreNode() {
    43return preNode;
    44    }
    4546publicvoid setPreNode(Set<ChildNode> preNode) {
    47this.preNode = preNode;
    48    }
    4950public Set<ChildNode> getPostNode() {
    51return postNode;
    52    }
    5354publicvoid setPostNode(Set<ChildNode> postNode) {
    55this.postNode = postNode;
    56    }
    5758    @Override
    59public String toString() {
    60return "Node{" +
    61                 "node='" + node + '\'' +
    62                 ", index='" + index + '\'' +
    63                 ", status='" + status + '\'' +
    64                 ", preNode=" + preNode +
    65                 ", postNode=" + postNode +
    66                 '}';
    67    }
    686970public Node() {
    71    }
    72 }

View Code![](/wp-content/uploads/2017/07/1500290334.gif)![](/wp-content/uploads/2017/07/15002903341.gif)
     1package com.yf.af.biz.test;
     2 3/** 4 * Created by chen on 2017/7/15.
     5*/ 6publicclass ChildNode {
     7private String node;
     8 9public String getNode() {
    10return node;
    11    }
    1213publicvoid setNode(String node) {
    14this.node = node;
    15    }
    1617public ChildNode(String node) {
    18this.node = node;
    19    }
    2021public ChildNode() {
    22    }
    23 }

View Code
{% endraw %}
