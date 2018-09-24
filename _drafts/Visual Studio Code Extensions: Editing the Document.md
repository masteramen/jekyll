---
layout: post
title: "Visual Studio 代码扩展：编辑文档"
title2: "Visual Studio Code Extensions: Editing the Document"
date: 2018-08-23 09:13:35 +0800
source: "http://www.chrisstead.com/archives/1082/visual-studio-code-extensions-editing-the-document/"
fileName: "visual-studio-dai-ma-kuo-zhan-bian-ji-wen-dang"
published: true
---

{% raw %}
I have been supporting an extension for Visual Studio Code for about a month now. In that time I have learned a lot about building extensions for an editor and static analysis of Javascript. Today is more about the former and less about the latter. Nevertheless, I have found that creating snippets, modifying the status bar and displaying messages is trivial, but modifying the current document is hard when you don’t know how to even get started.
我一直支持 Visual Studio Code 的扩展大约一个月了。在那段时间里，我学到了很多关于构建编辑器扩展和 Javascript 静态分析的知识。今天更多的是前者而不是后者。不过，我发现创建片段，修改状态栏和显示消息是微不足道的，但是当你不知道如何开始时修改当前文档很难。(zh_CN)

The other important thing I have noted about writing extensions for VS Code is, although the documentation exists and is a, seemingly, exhaustive catalog of the extension API, it is quite lacking in examples and instructions. By the end of this post I hope to demystify one of the most challenging parts of document management I have found so far.
关于为 VS Code 编写扩展，我注意到的另一个重要的事情是，虽然文档存在并且是一个看似详尽的扩展 API 目录，但它在示例和指令中却相当缺乏。到本文结束时，我希望揭开目前为止我发现的文档管理中最具挑战性的部分之一。(zh_CN)

### The VSCode Module

### VSCode 模块(zh_CN)

The first thing to note is anything you do in VS Code which interacts with the core API will require the vscode module. It might seem strange to bring this up, but it is rather less than obvious that you will have to interact with the vscode module often.
首先要注意的是你在 VS Code 中做的任何与核心 API 交互的东西都需要 vscode 模块。提起它可能看起来很奇怪，但是你不得不经常与 vscode 模块进行交互。(zh_CN)

Under the hood, the vscode module contains pretty much everything you need to know about the editor and its current state. The module also contains all of the functions, objects and prototypes which you will need in order to make any headway in your code whatsoever. With that in mind, there are two ways you can get this module or any of its data into your current solution. The first option is to require it like any other node module.
在引擎盖下，vscode 模块包含您需要了解的有关编辑器及其当前状态的所有内容。该模块还包含您需要的所有功能，对象和原型，以便在您的代码中取得任何进展。考虑到这一点，有两种方法可以将此模块或其任何数据导入当前解决方案。第一种选择是像任何其他节点模块一样要求它。(zh_CN)

```
var vscode = require('vscode');
```

As of the latest release of VS Code, you now have to explicitly specify the vscode module in dev-dependencies in your packages.json file. Below is what my dependencies object looks like:
从 VS Code 的最新版本开始，您现在必须在 packages.json 文件中的 dev-dependencies 中显式指定 vscode 模块。下面是我的依赖项对象的样子：(zh_CN)

```
"devDependencies": {
"chai": "^3.4.1",
"mocha": "^2.3.4",
"mockery": "^1.4.0",
"sinon": "^1.17.2",
"vscode": "^0.11.x"
},

"devDependencies":{
    "chai":"^3.4.1",
    "mocha":"^2.3.4",
    "mockery":"^1.4.0",
    "sinon":"^1.17.2",
    "vscode":"^0.11.x"

},
```

For now, don’t sweat the other stuff I have required. It is all test library stuff, which we will look at in a future post. Anyway, that last line is my vscode requirement. By adding this dependency, vscode will be available in your development environment, which makes actually getting work done possible. To install and include vscode, copy and paste the following at the command line inside your extension project:
现在，不要为我需要的其他东西而烦恼。这是测试库的全部内容，我们将在以后的文章中介绍。无论如何，最后一行是我的 vscode 要求。通过添加此依赖项，vscode 将在您的开发环境中可用，这使得实际完成工作成为可能。要安装并包含 vscode，请在扩展项目内的命令行中复制并粘贴以下内容：(zh_CN)

```
npm install vscode --save-dev
```

### Making a Document Edit

### 制作文档编辑(zh_CN)

The reason it was important to briefly cover the actual vscode module is, we are going to live on it for the rest of the post. It will be in just about ever code sample from here to the end of the post.
简要介绍实际 vscode 模块的重要原因是，我们将在帖子的其余部分继续使用它。这将是从这里到帖子末尾的代码示例。(zh_CN)

So…
所以…(zh_CN)

By reading the VS Code extension API it is really, really easy to get lost when trying to push an edit into the view. There are, in fact, 5 different object types which must be instantiated in order and injected into one another to create a rather large, deeply nested edit object hierarchy. As I was trying to figure it out, I had to take notes and keep bookmarks so I could cross-compare objects and sort out which goes where.
通过阅读 VS Code 扩展 API，在尝试将编辑推入视图时，实际上很容易迷失。实际上，有 5 种不同的对象类型必须按顺序实例化并相互注入以创建相当大的，深度嵌套的编辑对象层次结构。当我试图解决这个问题时，我不得不做笔记并保留书签，以便我可以交叉比较对象并找出哪些内容。(zh_CN)

I will start off by looking at the last object in the sequence and then jump to the very first objects which need to be instantiated and work to our final implementation. When you want to make an edit to the code in the current document, you need to create a new WorkspaceEdit which will handle all of the internal workings for actually propagating the edit. This new WorkspaceEdit object will be passed, when ready, into an applyEdit function. Here’s what the final code will look like, so it is clear what we are working toward in the end:
我将从查看序列中的最后一个对象开始，然后跳转到需要实例化的第一个对象，并开始最终实现。如果要对当前文档中的代码进行编辑，则需要创建一个新的 WorkspaceEdit，它将处理实际传播编辑的所有内部工作。准备好后，这个新的 WorkspaceEdit 对象将传递给 applyEdit 函数。这是最终代码的样子，所以很清楚我们最终会做些什么：(zh_CN)

    function applyEdit (vsEditor, coords, content){
        var vsDocument = getDocument(vsEditor);
        var edit = setEditFactory(vsDocument._uri, coords, content);
        vscode.workspace.applyEdit(edit);
    }

    functionapplyEdit(vsEditor,coords,content){

        varvsDocument=getDocument(vsEditor);

        varedit=setEditFactory(vsDocument._uri,coords,content);

        vscode.workspace.applyEdit(edit);

    }

In this sample code, the \_uri refers to the document we are interacting with, coords contains the start and end position for our edit and content contains the actual text content we want to put in our editor document. I feel we could almost spend an entire blog post just discussing what each of these pieces entails and how to construct each one. For now, however, let’s just assume the vsEditor is coming from outside our script and provided by the initial editor call, the coords are an object which we will dig into a little more soon, and content is just a block of text containing anything.
在此示例代码中，\_uri 指的是我们正在与之交互的文档，coords 包含编辑的开始和结束位置，内容包含我们要放在编辑器文档中的实际文本内容。我觉得我们几乎可以花一整篇博客文章来讨论每个部分所包含的内容以及如何构建每个部分。但是现在，让我们假设 vsEditor 来自我们的脚本之外并由初始编辑器调用提供，coords 是一个我们将很快挖掘的对象，内容只是包含任何内容的文本块。(zh_CN)

### The Position Object

### 位置对象(zh_CN)

In our previous code sample, there is a function called setEditFactory. In VS Code there are two types of document edits, set and replace. So far I have only used a set edit and it seems to work quite nicely. With that in mind, however, there is a reason we are using a factory function to construct our edit. A document edit contains so many moving parts it is essential to limit exposure of the reusable pieces to the rest of the world since they largely illuminate nothing when you are in the middle of trying to simply add some text to the document.
在我们之前的代码示例中，有一个名为 setEditFactory 的函数。在 VS Code 中，有两种类型的文档编辑，即设置和替换。到目前为止，我只使用了一组编辑，它看 ​​ 起来效果很好。但是，考虑到这一点，我们使用工厂函数构建编辑是有原因的。文档编辑包含许多移动部件，必须限制可重复使用的部件暴露于世界其他地方，因为当您正在尝试简单地向文档添加一些文本时，它们很大程度上没有任何照明。(zh_CN)

Let’s actually dig into the other end of our edit manufacture process and look at the very first object which need to be constructed in order to actually produce a change in our document: the position. Every edit must have a position specified. Without a position, the editor won’t know where to place the changes you are about to make.
让我们真正深入到编辑制作过程的另一端，并查看需要构建的第一个对象，以便在文档中实际产生更改：位置。每个编辑都必须指定一个位置。如果没有职位，编辑将无法知道您将要进行的更改的位置。(zh_CN)

In order to create a position object, you need two number values, specifically integers. I’m not going to tell you where, exactly, to get these numbers because that is really up to the logic of your specific extension, but I will say that a position requires a line number and a character number. If you are tinkering with code in your own extension, you can actually make up any two numbers you want as long as they exist as coordinates in your document. line 5, char 3 is a great one if it exists, so feel free to key the values in by hand to get an idea of how this works.
要创建位置对象，您需要两个数字值，特别是整数。我不打算告诉你究竟哪里获得这些数字，因为这实际上取决于你的特定扩展的逻辑，但我会说一个位置需要一个行号和一个字符号。如果您正在修改自己的扩展中的代码，只要它们作为文档中的坐标存在，您实际上可以组成任何两个所需的数字。第 5 行，如果存在，则 char 3 是一个很好的，所以请随意手动键入值以了解其工作原理。(zh_CN)

Anyway, once we have a line and a character number, we are ready to construct a position.
无论如何，一旦我们有一条线和一个字符数，我们就可以建立一个位置了。(zh_CN)

    function positionFactory(line, char) {
        return new vscode.Position(line, char);
    }

    functionpositionFactory(line,char){

        returnnewvscode.Position(line,char);

    }

That’s actually all there is to it. If you new up a Position object with a line and character number, you will have a new position to work with in your extension.
实际上这就是它的全部内容。如果您使用行和字符编号新建一个 Position 对象，您将在扩展中有一个新的位置。(zh_CN)

### The Range Object

### 范围对象(zh_CN)

The next object you will need to display your document change is a range object. The range object, one would think, would simply take bare coordinates. Sadly this is not the case. What range actually takes is a start and end position object. The range tells VS Code what lines and characters to overwrite with your new content, so it must go from an existing line and character to an existing line and character, otherwise known as a start position and end position. Here’s how we create a range object.
显示文档更改所需的下一个对象是范围对象。人们会想，范围对象只会采用裸坐标。可悲的是，事实并非如此。实际需要的范围是开始和结束位置对象。该范围告诉 VS Code 用新内容覆盖哪些行和字符，因此它必须从现有的行和字符转到现有的行和字符，也称为起始位置和结束位置。以下是我们创建范围对象的方法。(zh_CN)

    function rangeFactory(start, end) {
        return new vscode.Range(start, end);
    }

    functionrangeFactory(start,end){

        returnnewvscode.Range(start,end);

    }

So far our factories are nice and clean, which makes their intent pretty obvious. This is handy because it gets really strange and hard to follow quickly without some care and feeding of clean code. Anyway, our range takes two positions, so we provide them as named above, start and end.
到目前为止，我们的工厂很干净，这使得他们的意图非常明显。这很方便，因为它变得非常奇怪并且很难在没有一些小心和干净代码的情况下快速跟进。无论如何，我们的范围有两个位置，所以我们提供它们如上所述，开始和结束。(zh_CN)

### The TextEdit Object

### TextEdit 对象(zh_CN)

The TextEdit object is where things start to really come together. Now that we have a range made of two positions, we can pass our range and our text content through to create a new edit object. The edit object is one of the key objects we need to actually perform our document change. It contains almost all of the necessary information to actually make a document change. Let’s look at how to construct a TextEdit object.
TextEdit 对象是事物开始真正融合在一起的地方。现在我们有一个由两个位置组成的范围，我们可以通过我们的范围和文本内容来创建一个新的编辑对象。编辑对象是我们实际执行文档更改所需的关键对象之一。它包含几乎所有实际更改文档的必要信息。我们来看看如何构造 TextEdit 对象。(zh_CN)

    function textEditFactory(range, content) {
        return new vscode.TextEdit(range, content);
    }

    functiontextEditFactory(range,content){

        returnnewvscode.TextEdit(range,content);

    }

Keep in mind, though we have only written a few short lines of code we have now constructed an object tree containing 4 nested objects. Are you still keeping up?
请记住，虽然我们只编写了一些简短的代码，但我们现在构建了一个包含 4 个嵌套对象的对象树。你还在跟上吗？(zh_CN)

### Building an Edit

### 构建编辑(zh_CN)

Now that we have gotten through the nitty gritty of constructing individual objects for our tree, we are ready to actually build a full edit and pass it back to the caller. This next function will make use of our factories in order to construct an object containing all dependencies in the right nesting order.
现在我们已经完成了为树构建单个对象的细节，我们已经准备好实际构建完整的编辑并将其传递回调用者。下一个函数将使用我们的工厂，以便以正确的嵌套顺序构造包含所有依赖项的对象。(zh_CN)

Does anyone else feel like we are putting together a matryoshka doll?
有没有人觉得我们正在组装一个俄罗斯套娃？(zh_CN)

Anyway our next function will also follow the factory pattern we have been using so we get a clean string of function calls all the way up and down our stack which will, hopefully, keep things easy to follow.
无论如何，我们的下一个函数也将遵循我们一直使用的工厂模式，因此我们在堆栈中上下都会得到一个干净的函数调用字符串，希望这些函数可以很容易地遵循。(zh_CN)

    function editFactory (coords, content){
        var start = positionFactory(coords.start.line, coords.start.char);
        var end = positionFactory(coords.end.line, coords.end.char);
        var range = rangeFactory(start, end);

        return textEditFactory(range, content);
    }

    functioneditFactory(coords,content){

        varstart=positionFactory(coords.start.line,coords.start.char);

        varend=positionFactory(coords.end.line,coords.end.char);

        varrange=rangeFactory(start,end);

        returntextEditFactory(range,content);

    }

tupian

As you can see, we are assembling all of the pieces and the stacking them together to build our document edit. The fully constructed edit will contain all of the instructions VS Code needs to modify the selected document. This will be useful as we construct our next object to interact with.
如您所见，我们正在组装所有部件并将它们堆叠在一起以构建我们的文档编辑。完全构造的编辑将包含 VS Code 修改所选文档所需的所有指令。当我们构造下一个要与之交互的对象时，这将非常有用。(zh_CN)

Yes, there’s more.
是的，还有更多。(zh_CN)

### The WorkspaceEdit Object

### WorkspaceEdit 对象(zh_CN)

In order to introduce our edit into a document, we need to build a workspace edit to interact with. This workspace edit is, you guessed it, another object. A workspace has no required dependencies up front, so we are safe to construct this bare and interact with it later. Here’s our factory:
为了将我们的编辑引入文档，我们需要构建一个工作区编辑来与之交互。您猜对了，这个工作区编辑是另一个对象。工作空间预先没有必需的依赖项，因此我们可以安全地构建它并稍后与之交互。这是我们的工厂：(zh_CN)

    function workspaceEditFactory() {
        return new vscode.WorkspaceEdit();
    }

    functionworkspaceEditFactory(){

        returnnewvscode.WorkspaceEdit();

    }

This new workspace edit is where we will do our final setup before applying our edits into the document we started with, originally. Once we have a workspace edit, we can perform behaviors like set and replace. Here’s our last factory of the day, where we actually kick off the process. This actually brings us full circle, back to our edit application we looked at in the very first example. Let’s look at the code.
这个新的工作区编辑是我们在将编辑应用到我们最初开始的文档之前进行最终设置的地方。一旦我们有工作区编辑，我们就可以执行 set 和 replace 等行为。这是我们当天的最后一家工厂，我们实际上开始了这个过程。这实际上给我们带来了完整的循环，回到我们在第一个例子中看到的编辑应用程序。我们来看看代码吧。(zh_CN)

    function setEditFactory(uri, coords, content) {
        var workspaceEdit = workspaceEditFactory();
        var edit = editFactory(coords, content);

        workspaceEdit.set(uri, [edit]);
        return workspaceEdit;
    }

    functionsetEditFactory(uri,coords,content){
    functionsetEditFactory（URI，COORDS，内容）{(zh_CN)

        varworkspaceEdit=workspaceEditFactory();

        varedit=editFactory(coords,content);
        Wredith = Editorial（Coorders，内容）;(zh_CN)

        workspaceEdit.set(uri,[edit]);
        workspaceEdit.set（URI，[编辑]）;(zh_CN)

        returnworkspaceEdit;

    }

Now we can see where all of our coordinates, content and that mysterious uri went. Our setEditFactory takes all of our bits and pieces and puts them together into a single edit which we can then apply to our workspace edit object, which is then passed back for the program to operate on.
现在我们可以看到我们所有的坐标，内容和神秘的 uri 去了哪里。我们的 setEditFactory 将我们所有的部分和部分组合在一起，然后将它们组合成一个编辑，然后我们就可以将它们应用到我们的工作区编辑对象中，然后将其传回给程序进行操作。(zh_CN)

### Summary

### 概要(zh_CN)

Even after having figured this out from the VS Code documentation and implementing it in an extension, this is a lot to keep in your head. The bright side of all this work is, if done correctly, this can be wrapped up in a module and squirreled away to just be used outright. The surface area on this module is really only a single function, setEditFactory. This means, once you have it running correctly, it should be simple to call a single function with the right parts and get back a fully instantiated, usable object which can be applied to the editor.
即使在从 VS Code 文档中弄清楚并在扩展中实现它之后，这仍然需要保留。所有这些工作的好处是，如果正确完成，这可以包装在一个模块中，并且可以直接使用。这个模块的表面区域实际上只是一个函数 setEditFactory。这意味着，一旦正确运行，使用正确的部件调用单个函数应该很简单，并返回一个可以应用于编辑器的完全实例化的可用对象。(zh_CN)

Hopefully this is useful for someone. Identifying this and putting it all together with clear intent was a challenge with no examples. If there were ever one place I would complain about VS Code it is the documentation. I hope my post helps clear up the obscurities and makes it easier for people to dig into making their own extensions or contributing to an extension someone else has built.
希望这对某人有用。识别这一点并将其全部放在一起并具有明确的意图是一个没有例子的挑战。如果有一个地方我会抱怨 VS Code，那就是文档。我希望我的帖子有助于消除晦涩难懂的风险，让人们更容易挖掘自己的扩展或为其他人建立的扩展做出贡献。(zh_CN)

### _Related_

### _有关_(zh_CN)

{% endraw %}
