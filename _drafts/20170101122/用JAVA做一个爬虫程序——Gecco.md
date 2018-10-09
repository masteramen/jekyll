---
layout: post
title:  "用JAVA做一个爬虫程序——Gecco"
title2:  "用JAVA做一个爬虫程序——Gecco"
date:   2017-01-01 23:53:42  +0800
source:  "https://www.jfox.info/%e7%94%a8java%e5%81%9a%e4%b8%80%e4%b8%aa%e7%88%ac%e8%99%ab%e7%a8%8b%e5%ba%8fgecco.html"
fileName:  "20170101122"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%94%a8java%e5%81%9a%e4%b8%80%e4%b8%aa%e7%88%ac%e8%99%ab%e7%a8%8b%e5%ba%8fgecco.html"
---
{% raw %}
public class StarIndexPage{
        public static void main(String[] args) {
        String url = "http://ku.ent.sina.com.cn/star/search&page_no=1"; //想要爬取的网站的首页地址
        HttpGetRequest start = new HttpGetRequest(url); //获取网站请求
        start.setCharset("UTF-8");
        GeccoEngine.create() //创建搜索发动机
                   .classpath("com.yue.gecco") //要搜索的包名，会自动搜索该包下，含@Gecco注解的文件。
                   .start(start)   
                   .thread(5)//开启多少个线程抓取
                   .interval(2000) //隔多长时间抓取1次
                   .run();
         }
    }

2、HtmlBean部分。Gecco用到的注解部分很多。

    @Gecco(matchUrl = "http://ku.ent.sina.com.cn/star/search&page_no={page}",pipelines {"consolePipeline","starIndexPagePipeline"})
    //matchUrl是爬取相匹配的url路径，然后将获取到的HtmlBean输出到相应的管道（pipelines）进行处理。这里的管道是可以自定义的。
    public class StarIndexPage implements HtmlBean {
    
    private static final long serialVersionUID = 1225018257932399804L;
    
    @Request   
    private HttpRequest request;
    
    //url中的page参数
    @RequestParameter
    private String  page;
    
    
    //首页中的明星板块的集合，li的集合
    @HtmlField(cssPath = "#dataListInner > ul >li")
    private List<StarDetail> lsStarDetail;
    //@HtmlField(cssPath = "#dataListInner > ul >li")是用来抓取网页中的相应网页数据，csspath是jQuery的形式。
    //cssPath获取小技巧：用Chrome浏览器打开需要抓取的网页，按F12进入发者模式。然后在浏览器右侧选中该元素，鼠标右键选择Copy–Copy selector，即可获得该元素的cssPath
    
    //当前的页码，如果当前的是有很多页码的话，可以通过获取当前页码还有总页码，为继续抓取下一页做准备
    //@Text是指抓取网页中的文本部分。@Html是指抓取Html代码。@Href是用来抓取元素的连接 @Ajax是指获取Ajax得到的内容。
    @Text
    @HtmlField(cssPath = "#dataListInner > div > ul > li.curr a")
    private int currPageNum;
    
        //相应的Getter和Setter方法...省略
    }
    

StarDetail的HtmlBean部分

    public class StarDetail implements HtmlBean{
    
        /*//明星的照片
        @Image("src")
        @HtmlField(cssPath = "a > img")
        prie String PhotoString;*/
    
        //明星的名字
        @Html
        @HtmlField(cssPath ="div > div > h4")
        private String  starNameHtml;
    
        //明星的性别
        @Text
        @HtmlField(cssPath = "div > p:nth-child(2)")
        private  String starSex;
    
        //明星的职业
        @Html
        @HtmlField(cssPath = "div > p:nth-child(3)")
        private String professionHtml;
    
        //明星的国籍
        @Text
        @HtmlField(cssPath = " div > p:nth-child(4)")
        private String  nationality;
    
        //明星的出生日期
        @Text
        @HtmlField(cssPath = "div > p.special")
        private String birthday;
    
        //明星的星座
        @Text
        @HtmlField(cssPath = "div > p:nth-child(6)>a")
        private String constellation;
    
        //明星的身高
        @Text
        @HtmlField(cssPath = "div > p:nth-child(7)")
        private String height;
    
    ...省略相应的set和get方法...
    }
    

3、相应的pipeline部分。这部分主要是对获取的网页元素进行业务处理。也可以对数据进行持久化。

    @PipelineName("starIndexPagePipeline") 
     //@pipelineName 标签指定了pipline的名字。并且pipeline这个类需要实现Pipleline<T>。
    public class StarIndexPagePipeline implements Pipeline<StarIndexPage> {
    
        @Override
        public void process(StarIndexPage starIndexPage) {
    
            List<StarDetail> lsStarDetail = starIndexPage.getLsStarDetail();
    
            StringBuilder inputText =  new StringBuilder();
    
            for (StarDetail starDetail :lsStarDetail){
               String professionHtml=starDetail.getProfessionHtml();
               String starNameHtml=starDetail.getStarNameHtml();
                Document docName=Jsoup.parse(starNameHtml);
                String starName=docName.getElementsByTag("a").attr("title").trim();
    
                String starSex = starDetail.getStarSex().trim();
                Document doc = Jsoup.parse(professionHtml);
                String profession="未知"; //有不含a标签的，不含a标签的都是未知的
                if(professionHtml.indexOf("<a")!= -1){
                    profession = doc.getElementsByTag("a").text();
                }
                String nationality = starDetail.getNationality().trim();
                String birthday = starDetail.getBirthday().trim();
                String constellation = starDetail.getConstellation().trim();
                String height = starDetail.getHeight().trim();
                inputText.append(starName + "t" +
                        starSex + "t" +
                        profession + "t" +
                        nationality + "t" +
                        birthday + "t" +
                        constellation + "t" +
                        height + "t" +
                        System.getProperty("line.separator"));
            }
            //写入文件
            writeFile(inputText.toString());
    
            //爬取下一页
            HttpRequest currRequest = starIndexPage.getRequest();
            int currPageNum = starIndexPage.getCurrPageNum();
            System.out.println("----------已爬取第"+currPageNum+"页----------");
            searchNext(currPageNum,currRequest);
        }
    
        //写入文档的方法
        public void writeFile(String inputText){
            try {
                if(new File("D:明星数据.txt").exists()){
                    FileWriter fw1=new FileWriter("D:明星数据.txt",true);
                    PrintWriter pw = new PrintWriter(fw1);
                    pw.print(inputText);
                    pw.flush();
                    pw.close();
    
                }else{
                    File f1 =new File("D:明星数据.txt");
                    FileWriter fw1=new FileWriter("D:明星数据.txt",true);
                    PrintWriter pw = new PrintWriter(fw1,true);
                    pw.println("姓名"+"t"+"性别"+"t"+"职业"+"t"+"国籍"+"t"+"生日"+"t"+"星座"+"t"+"身高");
                    pw.print(inputText);
                    pw.flush();
                    pw.close();
                }
            }catch (IOException e){
                e.printStackTrace();
            }
          }
    
    
        public void searchNext(int currPageNum,HttpRequest currRequest){
            if (currPageNum<1799){  //总页数只有1799
                int nextPageNum=currPageNum + 1;
                String currUrl = currRequest.getUrl();
                String nextUrl = StringUtils.replaceOnce(currUrl,"page_no="+currPageNum,"page_no="+nextPageNum);
                SchedulerContext.into(currRequest.subRequest(nextUrl));
            }
            else{
                System.out.println("---------------爬取完毕------------------");
            }
    
        }
    }
{% endraw %}
