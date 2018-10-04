---
layout: post
title:  "设置Visual Studio代码的网络连接"
title2:  "Setup Visual Studio Code's Network Connection"
date:   2018-09-03 07:15:22  +0800
source:  "https://code.visualstudio.com/docs/setup/network"
fileName:  "e7ac7fd"
lang:  "en"
published: false
---
{% raw %}
Visual Studio Code is built on top of [Electron](https://electron.atom.io/) and benefits from all the networking stack capabilities of [Chromium](https://www.chromium.org/). This also means that VS Code users get much of the networking support available in [Google Chrome](https://www.google.com/chrome/index.html).
Visual Studio Code构建于[Electron]（https://electron.atom.io/）之上，并受益于[Chromium]（https://www.chromium.org/）的所有网络堆栈功能。这也意味着VS Code用户可以获得[Google Chrome]（https://www.google.com/chrome/index.html）中提供的大量网络支持。(zh_CN)

## Common hostnames
## 常用主机名(zh_CN)

A handful of features within VS Code require network communication to work, such as the auto-update mechanism, querying and installing extensions, and telemetry. For these features to work properly in a proxy environment, you must have the product correctly configured.
VS Code中的一些功能需要网络通信才能工作，例如自动更新机制，查询和安装扩展以及遥测。要使这些功能在代理环境中正常运行，您必须正确配置产品。(zh_CN)

If you are behind a firewall which needs to whitelist domains used by VS Code, here's the list of hostnames you should allow communication to go through:
如果您位于需要将VS Code使用的域列入白名单的防火墙后面，那么您应该允许通信的主机名列表：(zh_CN)

- `vscode-update.azurewebsites.net`
- `vscode.blob.core.windows.net`
- `marketplace.visualstudio.com`
- `*.gallerycdn.vsassets.io`
- `rink.hockeyapp.net`
- `vscode.search.windows.net`
- `raw.githubusercontent.com`
- `vsmarketplacebadge.apphb.com`

## Proxy server support
## 代理服务器支持(zh_CN)

VS Code has exactly the same proxy server support as Google Chromium. Here's a snippet from [Chromium's documentation](https://www.chromium.org/developers/design-documents/network-settings):
VS Code与Google Chromium具有完全相同的代理服务器支持。以下是[Chromium的文档]（https://www.chromium.org/developers/design-documents/network-settings）的片段：(zh_CN)

    "The Chromium network stack uses the system network settings so that users and administrators can control the network settings of all applications easily. The network settings include:
    
     - proxy settings
     - SSL/TLS settings
     - certificate revocation check settings
     - certificate and private key stores"
    

This means that your proxy settings should be picked up automatically.
这意味着您的代理设置应该自动获取。(zh_CN)

Otherwise, you can use the following command line arguments to control your proxy settings:
否则，您可以使用以下命令行参数来控制代理设置：(zh_CN)

    
    --no-proxy-server
    
    # Manual proxy address
    --proxy-server=<scheme>=<uri>[:<port>][;...] | <uri>[:<port>] | "direct://"
    
    
    --proxy-pac-url=<pac-file-url>
    
    # Disable proxy per host
    --proxy-bypass-list=(<trailing_domain>|<ip-address>)[:<port>][;...]
    

[Click here](https://www.chromium.org/developers/design-documents/network-settings) to know more about these command line arguments.
[单击此处]（https://www.chromium.org/developers/design-documents/network-settings）以了解有关这些命令行参数的更多信息。(zh_CN)

### Authenticated proxies
### 经过身份验证的代理(zh_CN)

Authenticated proxies should work seamlessly within VS Code with the addition of [PR #22369](https://github.com/Microsoft/vscode/pull/22369).
经过身份验证的代理应该在VS代码中无缝地工作，并添加[PR＃22369]（https://github.com/Microsoft/vscode/pull/22369）。(zh_CN)

The authentication methods supported are:
支持的身份验证方法是：(zh_CN)

- Basic
- 基本(zh_CN)
- Digest
- 消化(zh_CN)
- NTLM
- Negotiate
- 谈判(zh_CN)

When using VS Code behind an authenticated HTTP proxy, the following authentication popup should appear:
在经过身份验证的HTTP代理后面使用VS Code时，应显示以下身份验证弹出窗口：(zh_CN)

![proxy](https://code.visualstudio.com/assets/docs/setup/network/proxy.png)

Note that SOCKS5 proxy authentication support isn't implemented yet; you can follow the [issue in Chromium's issue tracker](https://bugs.chromium.org/p/chromium/issues/detail?id=256785).
请注意，SOCKS5代理身份验证支持尚未实现;您可以按照[Chromium问题跟踪器中的问题]（https://bugs.chromium.org/p/chromium/issues/detail?id=256785）进行操作。(zh_CN)

[Click here](https://www.chromium.org/developers/design-documents/http-authentication) to read more about HTTP proxy authentication within VS Code.
[单击此处]（https://www.chromium.org/developers/design-documents/http-authentication）以阅读有关VS代码中的HTTP代理身份验证的更多信息。(zh_CN)

### SSL certificates
### SSL证书(zh_CN)

Often HTTPS proxies rewrite SSL certificates of the incoming requests. Chromium was designed to reject responses which are signed by certificates which it doesn't trust. If you hit any SSL trust issues, there are a few options available for you:
HTTPS代理通常会重写传入请求的SSL证书。 Chromium旨在拒绝由不信任的证书签署的回复。如果您遇到任何SSL信任问题，可以使用以下几种选项：(zh_CN)

- Since Chromium simply uses the OS's certificate trust infrastructure, the preferred option is to add your proxy's certificate to your OS's trust chain. [Click here](https://www.chromium.org/Home/chromium-security/root-ca-policy) to read more about the Root Certificate Policy in Chromium.
- 由于Chromium只使用操作系统的证书信任基础结构，因此首选选项是将代理的证书添加到操作系统的信任链中。 [点击此处]（https://www.chromium.org/Home/chromium-security/root-ca-policy）以了解有关Chromium中的根证书政策的更多信息。(zh_CN)
- If your proxy runs in `localhost`, you can always try the [`--allow-insecure-localhost`](https://peter.sh/experiments/chromium-command-line-switches/#allow-insecure-localhost) command line flag.
- 如果您的代理运行`localhost`, 你可以随时试试[`--allow-insecure-localhost`](https://peter.sh/experiments/chromium-command-line-switches/#allow-insecure-localhost）命令行标志。(zh_CN)
- If all else fails, you can tell VS Code to ignore all certificate errors using the [`--ignore-certificate-errors`](https://peter.sh/experiments/chromium-command-line-switches/#ignore-certificate-errors) command line flag. **Warning:** This is **dangerous** and **not recommended**, since it opens the door to security issues.
- 如果所有其他方法都失败了，您可以告诉VS Code使用[忽略所有证书错误`--ignore-certificate-errors`](https://peter.sh/experiments/chromium-command-line-switches/#ignore-certificate-errors）命令行标志。 **警告：**这是**危险**和**不推荐**，因为它打开了安全问题的大门。(zh_CN)

## Legacy proxy server support
## 旧版代理服务器支持(zh_CN)

Extensions don't benefit yet from the same proxy support that VS Code supports. You can follow this issue's development in [GitHub](https://github.com/Microsoft/vscode/issues/12588).
扩展不会受益于VS Code支持的相同代理支持。您可以在[GitHub]（https://github.com/Microsoft/vscode/issues/12588）中关注此问题的开发。(zh_CN)

Similarly to extensions, a few other VS Code features don't yet fully support proxy networking, namely the CLI interface. The CLI interface is what you get when running `code --install-extension vscodevim.vim` from a command prompt or terminal. You can follow this issue's development in [GitHub](https://github.com/Microsoft/vscode/issues/29910).
与扩展类似，其他一些VS Code功能尚不完全支持代理网络，即CLI接口。 CLI界面是您运行时获得的`code --install-extension vscodevim.vim` 从命令提示符或终端。您可以在[GitHub]（https://github.com/Microsoft/vscode/issues/29910）中关注此问题的开发。(zh_CN)

Due to both of these constraints, the `http.proxy`, `http.proxyStrictSSL` and `http.proxyAuthorization` variables are still part of VS Code's settings, yet they are only respected in these two scenarios.
由于这两个限制，`http.proxy`, `http.proxyStrictSSL` 和`http.proxyAuthorization` 变量仍然是VS Code设置的一部分，但它们仅在这两种情况下得到尊重。(zh_CN)

## Troubleshooting
## 故障排除(zh_CN)

Here are some helpful links that might help you troubleshoot networking issues in VS Code:
以下是一些有用的链接，可以帮助您解决VS Code中的网络问题：(zh_CN)

Last updated on 9/5/2018
最后更新于9/5/2018(zh_CN)
{% endraw %}
