---
layout: post
title:  "窗口管理器 xmonad 教程"
title2:  "窗口管理器 xmonad 教程"
date:   2017-01-01 23:58:21  +0800
source:  "https://www.jfox.info/%e7%aa%97%e5%8f%a3%e7%ae%a1%e7%90%86%e5%99%a8xmonad%e6%95%99%e7%a8%8b.html"
fileName:  "20170101401"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%aa%97%e5%8f%a3%e7%ae%a1%e7%90%86%e5%99%a8xmonad%e6%95%99%e7%a8%8b.html"
---
{% raw %}
开发者最需要的，就是一个顺手的开发环境。 

![](/wp-content/uploads/2017/07/1501315235.jpg)

 每个人的偏好不一样，我的开发环境是 Fish Shell + Xfce + xmonad + Vim，已经用了好多年，非常满意。 

 三个月前，我介绍了 [ Fish Shell ](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/entry/312911) ，今天就来介绍 [ xmonad ](https://www.jfox.info/go.php?url=http://xmonad.org/) 。根据本文，读者可以从零开始配置并使用 xmonad。 

![](/wp-content/uploads/2017/07/1501315235.png)

 xmonad 的所有操作都通过键盘，只适合命令行的重度用户。如果你喜欢鼠标和图形界面，xmonad 不适合你。另外，它本身也不支持 Windows 系统。 

##  一、xmonad 是什么？ 

 xmonad 是一种窗口管理器（window manager），用来管理软件窗口的位置和大小，会自动在桌面上平铺（tiling）窗口。 

![](/wp-content/uploads/2017/07/1501315236.jpg)

 （图片说明：各种软件窗口） 

 注意，窗口管理器不是桌面环境（desktop environment）。后者是一套功能完善、集成各种工具的图形用户界面，比如 Gnome 和 KDE。桌面环境肯定包含了窗口管理器，但是（某些）窗口管理器可以不需要桌面环境，独立运行，xmonad 就是这种。 

![](/wp-content/uploads/2017/07/1501315237.png)

 （图片说明：典型的桌面环境） 

 桌面环境通常很重，窗口管理器就很轻，不仅体积小，资源占用也少，用户可以配置各种细节，释放出系统的最大性能。 

 Linux 系统允许用户更换窗口管理器，有 [ 很多种 ](https://www.jfox.info/go.php?url=https://www.slant.co/topics/390/~best-window-managers-for-linux) 可以选择。xmonad 一直是最受欢迎的前三名，它使用 Haskell 语言编写，是世界上使用人数最多的 Haskell 软件。它的特点就是极简化，性能高。 

##  二、安装 

 xmonad 的官网提供 [ 二进制包 ](https://www.jfox.info/go.php?url=http://xmonad.org/download.html) ，各个发行版都有。如果想自己编译，也可以下载源码。 

 我的发行版是 Debian，安装就是一行命令。 

    
    $ sudo apt-get install xmonad
    

 此外，还需要再安装两个小工具。 

    
    $ sudo apt-get install xmobar dmenu
    

 安装完成后，退出当前对话（session），选择 xmonad 会话重新登录。登录后，你会看到一个完全空白的桌面，什么也没有，这说明 xmonad 起作用了，因为这时还没有任何软件窗口。 

##  三、常用命令 

###  3.1 打开终端 

 第一步，你需要打开一个窗口。一般来说，总是打开命令行终端窗口。 

 xmonad 提供一个功能键，称为 ` mod ` 键（modifier 的缩写），所有操作都要使用这个键，默认为 ` alt ` 键，但是一般会把它改掉，比如改成 ` Windows ` 键，具体修改方法请看后文。 

 打开终端窗口，按下 ` mod + shift + return ` （默认为 ` alt + shift + return ` ）。这会打开一个终端窗口，占据了所有桌面空间。 

![](/wp-content/uploads/2017/07/1501315238.png)

 按下 ` mod + shift + return ` ，再打开一个终端窗口。它与第一个窗口水平地平分屏幕，每个窗口占据50%空间。 

![](/wp-content/uploads/2017/07/15013152381.png)

 注意，第二个窗口占据桌面的左边，自动获得焦点，成为当前窗口。这个左边部分就称为”主栏”（master pane），右边部分称为”副栏”，前面打开的第一个窗口自动进入副栏。 

 再按一次 ` mod + shift + return ` ，打开第三个窗口。 

![](/wp-content/uploads/2017/07/15013152382.png)

 这时，第三个窗口就会占据主栏，前两个窗口自动进入副栏。规则就是，新窗口总是独占主栏，旧窗口平分副栏。 

###  3.2 布局模式 

 默认的布局模式是，主栏在左边，副栏在右边。 

 按下 ` mod + space ` ，布局模式改成主栏在上方，副栏在下方。 

![](/wp-content/uploads/2017/07/1501315239.png)

 再按一次 ` mod + space ` ，就变成独占模式，当前窗口独占整个桌面，其他窗口不可见。 

![](/wp-content/uploads/2017/07/1501315238.png)

 再按一次 ` mod + space ` ，就变回默认模式（主栏在左边，副栏在右边）。 

![](/wp-content/uploads/2017/07/15013152382.png)

 按下 ` mod + , ` （mod + 逗号），一个副栏窗口会移动到主栏，即主栏变成有两个窗口，副栏变成只有一个窗口。 

![](/wp-content/uploads/2017/07/15013152391.png)

 再按一次 ` mod + , ` （mod + 逗号），主栏变成三个窗口，副栏消失。 

![](/wp-content/uploads/2017/07/1501315240.png)

 按下 ` mod + . ` （mod + 句号），主栏减少一个窗口，副栏增加一个窗口。 

###  3.3 移动焦点 

 新窗口总是自动获得焦点，变成当前窗口。按下 ` mod + j ` ，焦点顺时针移动到下一个窗口。 

 按下 ` mod + k ` ，焦点逆时针移动到上一个窗口。 

 如果当前窗口在副栏，按下 ` mod + return ` ，会与主栏窗口对调位置。 

###  3.4 调整窗口顺序 

 按下 ` mod + shift + j ` ，按照顺时针的顺序，当前窗口与下一个窗口交换位置，即当前窗口前进到下一个位置。 

 按下 ` mod + shift + k ` ，按照逆时针顺序，当前窗口与上一个窗口交换位置。即当前窗口后退到上一个位置。 

###  3.5 调整栏位大小 

 按下 ` mod + l ` ，主栏增加尺寸。 

 按下 ` mod + h ` ，副栏增加尺寸。 

###  3.6 浮动窗口 

 正常情况下，xmonad 决定了窗口的位置和大小，但有时我们希望自己控制。xmonad 允许某个窗口浮动，脱离原有的布局。 

 按下 ` mod + 鼠标左键 ` 拖动窗口，该窗口就会变成浮动窗口，可以放到屏幕的任何位置。 

 按下 ` mod + 鼠标右键 ` 可以调整窗口大小。 

 按下 ` mod + t ` ，当前浮动窗口就会结束浮动，重新回到 xmonad 的布局。 

###  3.7 关闭窗口 

 窗口可以自然关闭（比如终端窗口按 ` ctrl + d ` ），也可以让 xmonad 强行关闭它。 

 按下 ` mod + shift + c ` ，会关闭当前窗口，焦点移到下一个窗口。 

###  3.8 退出 xmonad 

 按下 ` mod + shift + q ` ，将会立刻关闭所有窗口，退出 xmonad，用户需要重新登录。 

##  四、工作区 

 xmonad 提供9个工作区，相当于提供9个桌面。按下 ` mod + 1 ` 到 ` mod + 9 ` 切换。 xmonad 启动后，默认处于1号工作区 。 

 如果要将一个窗口移到不同的工作区，先用 ` mod + j ` 或 ` mod + k ` ，将其变成焦点窗口，然后使用 ` mod + shift + 6 ` ，就将其移到了6号工作区。 

 我的习惯是，1号工作区是终端，2号是浏览器，4号是虚拟机。 

##  五、多显示器 

![](/wp-content/uploads/2017/07/1501315240.jpg)

 多显示器需要使用配置工具，我用的是 xrandr。其他工具还有 Xinerama 和 winView，另外 arandr 是 xrandr 的图形界面，也可以用。 

 下面的命令查看显示器的连接情况。 

    
    $ xrandr -q
    

 具体的配置教程可以看 [ 这里 ](https://www.jfox.info/go.php?url=https://wiki.archlinux.org/index.php/xrandr) 。 

 使用多显示器时，每个显示器会分配到一个工作区。默认情况下，1号工作区显示在主显示器，2号工作区显示在第二个显示器。如果要将4号工作区显示在当前显示器，那么按下 ` mod + 4 ` ，4号工作就会与当前屏幕中的工作区互换位置。 

` mod + w ` 转移焦点到左显示器， ` mod + e ` 转移焦点到右显示器。 

` mod + shift + w ` 将当前窗口移到左显示器， ` mod + shift + e ` 将当前窗口移到右显示器。 

##  六、配置文件 

 xmonad 的配置文件是 ` ～/.xmonad/xmonad.hs ` 。该文件需要用户自己新建， [ 这里 ](https://www.jfox.info/go.php?url=https://gist.github.com/ruanyf/65893d5d5916bb2ffefd8ea69ff869f7) 是一个简单的范例，详细的解释可以看 [ 官网 ](https://www.jfox.info/go.php?url=https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen's_Configuration) 。 

 这个文件里面， ` modMask ` 决定了 ` mod ` 到底是哪一个键。 

    
    modMask = mod4Mask
    

 上面的这行就将 ` mod ` 键设为了 ` Windows ` 键。 

 修改配置文件以后，按下 ` mod + q ` ，新的配置就会生效。 

##  七、xmobar 

 xmonad 的默认桌面，什么也没有，不太方便。xmobar 提供了一个状态栏，将常用信息显示在上面，比如 CPU 和内存的占用情况、天气、时间等等。 

![](/wp-content/uploads/2017/07/1501315241.jpg)

 （图片说明：顶部状态栏就是 xmobar。） 

 它的配置文件是 ` ~/.xmobarrc ` （教程 [ 1 ](https://www.jfox.info/go.php?url=https://wiki.archlinux.org/index.php/Xmobar) ， [ 2 ](https://www.jfox.info/go.php?url=http://projects.haskell.org/xmobar/) ， [ 3 ](https://www.jfox.info/go.php?url=http://beginners-guide-to-xmonad.readthedocs.io/configure_xmobar.html) ）。 [ 这里 ](https://www.jfox.info/go.php?url=https://gist.github.com/ruanyf/9d234b57ad1894d559abe57449fec65c) 是一个最简单配置， [ 这里 ](https://www.jfox.info/go.php?url=https://gist.github.com/ruanyf/a640a98d41383387d3a6401796f54710) 是我的笔记本电脑使用的配置。 

##  八、dmenu 

 最后，dmenu 在桌面顶部提供了一个菜单条，可以快速启动应用程序。 

![](/wp-content/uploads/2017/07/1501315241.png)

 （图片说明：dmenu 显示在屏幕顶部，输入 ` fire ` 会自动显示包含 ` fire ` 的启动命令。） 

 它从系统变量 ` $PATH ` 指定的路径中，寻找所有的应用程序，根据用户的键入，动态提示最符合的结果。 

 按下 ` mod + p ` 就会进入 ` dmenu ` 菜单栏，按下 ` ESC ` 键可以退出。方向键用来选择应用程序， ` return ` 键用来启动。 

 （完）
{% endraw %}
