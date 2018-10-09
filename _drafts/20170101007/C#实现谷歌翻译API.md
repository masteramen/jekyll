---
layout: post
title:  "C#实现谷歌翻译API"
title2:  "C#实现谷歌翻译API"
date:   2017-01-01 23:51:47  +0800
source:  "https://www.jfox.info/c%e5%ae%9e%e7%8e%b0%e8%b0%b7%e6%ad%8c%e7%bf%bb%e8%af%91api.html"
fileName:  "20170101007"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/c%e5%ae%9e%e7%8e%b0%e8%b0%b7%e6%ad%8c%e7%bf%bb%e8%af%91api.html"
---
{% raw %}
由于谷歌翻译官方API是付费版本，本着免费和开源的精神，分享一下用C#实现谷歌翻译API的代码。这个代码非常简单，主要分两块：通过WebRequest的方式请求内容；获取Get方式的请求参数（难点在于tk的获取）。

一、WebRequest代码

    var webRequest = WebRequest.Create(url) as HttpWebRequest;
    
    webRequest.Method = "GET";
    
    webRequest.CookieContainer = cookie;
    
    webRequest.Referer = referer;
    
    webRequest.Timeout = 20000;
    
    webRequest.Headers.Add("X-Requested-With:XMLHttpRequest");
    
    webRequest.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
    
    webRequest.UserAgent = useragent;
    
      using (var webResponse = (HttpWebResponse)webRequest.GetResponse())
      {
    　　 using (var reader = new StreamReader(webResponse.GetResponseStream(), Encoding.UTF8))
    　　 {
    
    　　　　html = reader.ReadToEnd();
    　　　　reader.Close();
    　　　　webResponse.Close();
    　　 }
      }

二、谷歌翻译接口的实现

　　1、抓包查看翻译网络请求，这里是用谷歌浏览器查看的网络请求，如下图：

 　　可以看到，请求方式是“Get”方式，后面跟的请求参数很多，如下图：

　　其中，最重要的参数有：sl–来源语言，一般设置为auto即自动检测，tl–目标语言，你想翻译成的语言，tk–ticket即使发车车票，谷歌就靠这个来防止我们免费调用的，这是本API最难的地方。

　　2、tk的获取

　　在打开https://translate.google.com/页面是，获取到的HTML代码中有如下一个生成TKK的脚本：

　　直接运行这个脚本，可以生成一个字符串：

　　从监控的网络中可以发现其中一个JS调用了这个TKK值，这个JS加了密进行混淆的，要破解这个JS需要扎实的基本功，以及足够的耐心，我也是网上找的别人破解的JS代码，亲测可用，需将此代码保存在**gettk.js**文档中，方便调用：

    var b = function (a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
    }
    
    var tk =  function (a,TKK) {
        for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
            var c = a.charCodeAt(f);
            128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ? (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240, g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
        }
        a = h;
        for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
        a = b(a, "+-3^+b+-f");
        a ^= Number(e[1]) || 0;
        0 > a && (a = (a & 2147483647) + 2147483648);
        a %= 1E6;
        return a.toString() + "." + (a ^ h)
    }

　　要得到tk只需要，运行tk这个函数，它有两个输入值：a为翻译文本内容，TKK是上文正则匹配得到的JS字符串执行的结果值。为方便在C#中执行JS，封装了一个能执行JS的函数，如下：

    /// 执行JS/// 参数体/// 
            private string ExecuteScript(string sExpression, string sCode)
            {
                MSScriptControl.ScriptControl scriptControl = new MSScriptControl.ScriptControl();
                scriptControl.UseSafeSubset = true;
                scriptControl.Language = "JScript";
                scriptControl.AddCode(sCode);
                try
                {
                    string str = scriptControl.Eval(sExpression).ToString();
                    return str;
                }
                catch (Exception ex)
                {
                    string str = ex.Message;
                }
                returnnull;
            }   

　　3、实现翻译的完整代码

    /// 谷歌翻译/// 待翻译文本/// 中文：zh-CN，英文：en
    
    public string GoogleTranslate(string text, string fromLanguage, string toLanguage)
    {
        CookieContainer cc = new CookieContainer();
    
        string GoogleTransBaseUrl = "https://translate.google.com/";
    
        var BaseResultHtml = GetResultHtml(GoogleTransBaseUrl, cc, "");
    
        Regex re = new Regex(@"(?<=TKK=)(.*?)(?=);)");
    
        var TKKStr = re.Match(BaseResultHtml).ToString() + ")";
    
        var TKK = ExecuteScript(TKKStr, TKKStr);
    
        var GetTkkJS = File.ReadAllText("./gettk.js");
    
        var tk = ExecuteScript("tk(""+text+"",""+TKK+"")", GetTkkJS);
    
        string googleTransUrl = "https://translate.google.com/translate_a/single?client=t&sl="+fromLanguage+"&tl="+toLanguage+"&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&ssel=0&tsel=0&kc=1&tk="+tk+"&q="+HttpUtility.UrlEncode(text);
    
        var ResultHtml = GetResultHtml(googleTransUrl, cc, "https://translate.google.com/");
    
        dynamic TempResult = Newtonsoft.Json.JsonConvert.DeserializeObject(ResultHtml);
    
        string ResultText = Convert.ToString(TempResult[0][0][0]);
    
        return ResultText;
    }
    
    public string GetResultHtml(string url,CookieContainer cc,string refer)
    {
        var html="";
        
        var webRequest = WebRequest.Create(url) as HttpWebRequest;
    
        webRequest.Method = "GET";
    
        webRequest.CookieContainer = cookie;
    
        webRequest.Referer = referer;
    
        webRequest.Timeout = 20000;
    
        webRequest.Headers.Add("X-Requested-With:XMLHttpRequest");
    
        webRequest.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
    
        webRequest.UserAgent = useragent;
    
        using (var webResponse = (HttpWebResponse)webRequest.GetResponse())
        {
        　　 using (var reader = new StreamReader(webResponse.GetResponseStream(), Encoding.UTF8))
        　　 {
    
        　　　　html = reader.ReadToEnd();
        　　　　reader.Close();
        　　　　webResponse.Close();
        　　 }
        }
        return html;
    }
    
    
    
    /// 执行JS/// 参数体/// 
    private string ExecuteScript(string sExpression, string sCode)
    {
        MSScriptControl.ScriptControl scriptControl = new MSScriptControl.ScriptControl();
        scriptControl.UseSafeSubset = true;
        scriptControl.Language = "JScript";
        scriptControl.AddCode(sCode);
        try
        {
            string str = scriptControl.Eval(sExpression).ToString();
            return str;
        }
        catch (Exception ex)
        {
            string str = ex.Message;
        }
        returnnull;
    }
{% endraw %}
