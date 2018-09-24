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
我一直支持 Visual Studio Code 的扩展大约一个月了。在那段时间里，我学到了很多关于构建编辑器扩展和 Javascript 静态分析的知识。今天更多的是前者而不是后者。不过，我发现创建片段，修改状态栏和显示消息是微不足道的，但是当你不知道如何开始时修改当前文档很难。

关于为 VS Code 编写扩展，我注意到的另一个重要的事情是，虽然文档存在并且是一个看似详尽的扩展 API 目录，但它在示例和指令中却相当缺乏。到本文结束时，我希望揭开目前为止我发现的文档管理中最具挑战性的部分之一。

### VSCode 模块

首先要注意的是你在 VS Code 中做的任何与核心 API 交互的东西都需要 vscode 模块。提起它可能看起来很奇怪，但是你不得不经常与 vscode 模块进行交互。

在引擎盖下，vscode 模块包含您需要了解的有关编辑器及其当前状态的所有内容。该模块还包含您需要的所有功能，对象和原型，以便在您的代码中取得任何进展。考虑到这一点，有两种方法可以将此模块或其任何数据导入当前解决方案。第一种选择是像任何其他节点模块一样要求它。

```
var vscode = require('vscode');
```

从 VS Code 的最新版本开始，您现在必须在 packages.json 文件中的 dev-dependencies 中显式指定 vscode 模块。下面是我的依赖项对象的样子：

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

现在，不要为我需要的其他东西而烦恼。这是测试库的全部内容，我们将在以后的文章中介绍。无论如何，最后一行是我的 vscode 要求。通过添加此依赖项，vscode 将在您的开发环境中可用，这使得实际完成工作成为可能。要安装并包含 vscode，请在扩展项目内的命令行中复制并粘贴以下内容：

```
npm install vscode --save-dev
```

### 制作文档编辑

简要介绍实际 vscode 模块的重要原因是，我们将在帖子的其余部分继续使用它。这将是从这里到帖子末尾的代码示例。

所以…

通过阅读 VS Code 扩展 API，在尝试将编辑推入视图时，实际上很容易迷失。实际上，有 5 种不同的对象类型必须按顺序实例化并相互注入以创建相当大的，深度嵌套的编辑对象层次结构。当我试图解决这个问题时，我不得不做笔记并保留书签，以便我可以交叉比较对象并找出哪些内容。

我将从查看序列中的最后一个对象开始，然后跳转到需要实例化的第一个对象，并开始最终实现。如果要对当前文档中的代码进行编辑，则需要创建一个新的 WorkspaceEdit，它将处理实际传播编辑的所有内部工作。准备好后，这个新的 WorkspaceEdit 对象将传递给 applyEdit 函数。这是最终代码的样子，所以很清楚我们最终会做些什么：

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

在此示例代码中，\_uri 指的是我们正在与之交互的文档，coords 包含编辑的开始和结束位置，内容包含我们要放在编辑器文档中的实际文本内容。我觉得我们几乎可以花一整篇博客文章来讨论每个部分所包含的内容以及如何构建每个部分。但是现在，让我们假设 vsEditor 来自我们的脚本之外并由初始编辑器调用提供，coords 是一个我们将很快挖掘的对象，内容只是包含任何内容的文本块。

### 位置对象

在我们之前的代码示例中，有一个名为 setEditFactory 的函数。在 VS Code 中，有两种类型的文档编辑，即设置和替换。到目前为止，我只使用了一组编辑，它看 ​​ 起来效果很好。但是，考虑到这一点，我们使用工厂函数构建编辑是有原因的。文档编辑包含许多移动部件，必须限制可重复使用的部件暴露于世界其他地方，因为当您正在尝试简单地向文档添加一些文本时，它们很大程度上没有任何照明。

让我们真正深入到编辑制作过程的另一端，并查看需要构建的第一个对象，以便在文档中实际产生更改：位置。每个编辑都必须指定一个位置。如果没有职位，编辑将无法知道您将要进行的更改的位置。

要创建位置对象，您需要两个数字值，特别是整数。我不打算告诉你究竟哪里获得这些数字，因为这实际上取决于你的特定扩展的逻辑，但我会说一个位置需要一个行号和一个字符号。如果您正在修改自己的扩展中的代码，只要它们作为文档中的坐标存在，您实际上可以组成任何两个所需的数字。第 5 行，如果存在，则 char 3 是一个很好的，所以请随意手动键入值以了解其工作原理。

无论如何，一旦我们有一条线和一个字符数，我们就可以建立一个位置了。

    function positionFactory(line, char) {
        return new vscode.Position(line, char);
    }

    functionpositionFactory(line,char){

        returnnewvscode.Position(line,char);

    }

实际上这就是它的全部内容。如果您使用行和字符编号新建一个 Position 对象，您将在扩展中有一个新的位置。

### 范围对象

显示文档更改所需的下一个对象是范围对象。人们会想，范围对象只会采用裸坐标。可悲的是，事实并非如此。实际需要的范围是开始和结束位置对象。该范围告诉 VS Code 用新内容覆盖哪些行和字符，因此它必须从现有的行和字符转到现有的行和字符，也称为起始位置和结束位置。以下是我们创建范围对象的方法。

    function rangeFactory(start, end) {
        return new vscode.Range(start, end);
    }

    functionrangeFactory(start,end){

        returnnewvscode.Range(start,end);

    }

到目前为止，我们的工厂很干净，这使得他们的意图非常明显。这很方便，因为它变得非常奇怪并且很难在没有一些小心和干净代码的情况下快速跟进。无论如何，我们的范围有两个位置，所以我们提供它们如上所述，开始和结束。

### TextEdit 对象

TextEdit 对象是事物开始真正融合在一起的地方。现在我们有一个由两个位置组成的范围，我们可以通过我们的范围和文本内容来创建一个新的编辑对象。编辑对象是我们实际执行文档更改所需的关键对象之一。它包含几乎所有实际更改文档的必要信息。我们来看看如何构造 TextEdit 对象。

    function textEditFactory(range, content) {
        return new vscode.TextEdit(range, content);
    }

    functiontextEditFactory(range,content){

        returnnewvscode.TextEdit(range,content);

    }

请记住，虽然我们只编写了一些简短的代码，但我们现在构建了一个包含 4 个嵌套对象的对象树。你还在跟上吗？

### 构建编辑

现在我们已经完成了为树构建单个对象的细节，我们已经准备好实际构建完整的编辑并将其传递回调用者。下一个函数将使用我们的工厂，以便以正确的嵌套顺序构造包含所有依赖项的对象。

有没有人觉得我们正在组装一个俄罗斯套娃？

无论如何，我们的下一个函数也将遵循我们一直使用的工厂模式，因此我们在堆栈中上下都会得到一个干净的函数调用字符串，希望这些函数可以很容易地遵循。

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

如您所见，我们正在组装所有部件并将它们堆叠在一起以构建我们的文档编辑。完全构造的编辑将包含 VS Code 修改所选文档所需的所有指令。当我们构造下一个要与之交互的对象时，这将非常有用。

是的，还有更多。

### WorkspaceEdit 对象

为了将我们的编辑引入文档，我们需要构建一个工作区编辑来与之交互。您猜对了，这个工作区编辑是另一个对象。工作空间预先没有必需的依赖项，因此我们可以安全地构建它并稍后与之交互。这是我们的工厂：

    function workspaceEditFactory() {
        return new vscode.WorkspaceEdit();
    }

    functionworkspaceEditFactory(){

        returnnewvscode.WorkspaceEdit();

    }

这个新的工作区编辑是我们在将编辑应用到我们最初开始的文档之前进行最终设置的地方。一旦我们有工作区编辑，我们就可以执行 set 和 replace 等行为。这是我们当天的最后一家工厂，我们实际上开始了这个过程。这实际上给我们带来了完整的循环，回到我们在第一个例子中看到的编辑应用程序。我们来看看代码吧。

    function setEditFactory(uri, coords, content) {
        var workspaceEdit = workspaceEditFactory();
        var edit = editFactory(coords, content);

        workspaceEdit.set(uri, [edit]);
        return workspaceEdit;
    }

    functionsetEditFactory（URI，COORDS，内容）{

        varworkspaceEdit=workspaceEditFactory();

        Wredith = Editorial（Coorders，内容）;

        workspaceEdit.set（URI，[编辑]）;

        returnworkspaceEdit;

    }

现在我们可以看到我们所有的坐标，内容和神秘的 uri 去了哪里。我们的 setEditFactory 将我们所有的部分和部分组合在一起，然后将它们组合成一个编辑，然后我们就可以将它们应用到我们的工作区编辑对象中，然后将其传回给程序进行操作。

### 概要

即使在从 VS Code 文档中弄清楚并在扩展中实现它之后，这仍然需要保留。所有这些工作的好处是，如果正确完成，这可以包装在一个模块中，并且可以直接使用。这个模块的表面区域实际上只是一个函数 setEditFactory。这意味着，一旦正确运行，使用正确的部件调用单个函数应该很简单，并返回一个可以应用于编辑器的完全实例化的可用对象。

希望这对某人有用。识别这一点并将其全部放在一起并具有明确的意图是一个没有例子的挑战。如果有一个地方我会抱怨 VS Code，那就是文档。我希望我的帖子有助于消除晦涩难懂的风险，让人们更容易挖掘自己的扩展或为其他人建立的扩展做出贡献。

### _有关_

{% endraw %}