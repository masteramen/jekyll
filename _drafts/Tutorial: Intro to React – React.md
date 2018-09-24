---
  layout: post
  title:  "教程：React简介 -  React"
  title2:  "Tutorial: Intro to React – React"
  date:   2018-08-23 11:14:29  +0800
  source:  "https://reactjs.org/tutorial/tutorial.html"
  fileName:  "jiao-cheng-react-jian-jie-react"
  published: false
  ---
  {% raw %}
  This tutorial doesn’t assume any existing React knowledge.
本教程不假设任何现有的React知识。(zh_CN)

## [https://reactjs.org/tutorial/tutorial.html#before-we-start-the-tutorial](https://reactjs.org/tutorial/tutorial.html#before-we-start-the-tutorial)Before We Start the Tutorial
## [https://reactjs.org/tutorial/tutorial.html#before-we-start-the-tutorial](https://reactjs.org/tutorial/tutorial.html#before-we-start-the-tutorial)Before我们开始教程(zh_CN)

We will build a small game during this tutorial. **You might be tempted to skip it because you’re not building games — but give it a chance.** The techniques you’ll learn in the tutorial are fundamental to building any React apps, and mastering it will give you a deep understanding of React.
我们将在本教程中构建一个小游戏。 **你可能想跳过它，因为你没有构建游戏 - 但给它一个机会。**你将在本教程中学到的技巧是构建任何React应用程序的基础，掌握它会给你一个深刻的了解React。(zh_CN)

> Tip
> 小费(zh_CN)
> 
> This tutorial is designed for people who prefer to **learn by doing**. If you prefer learning concepts from the ground up, check out our [step-by-step guide](https://reactjs.org/docs/hello-world.html). You might find this tutorial and the guide complementary to each other.
> 本教程专为喜欢**学习**的人而设计。如果您更喜欢从头开始学习概念，请查看我们的[循序渐进指南]（https://reactjs.org/docs/hello-world.html）。您可能会发现本教程和指南相互补充。(zh_CN)

The tutorial is divided into several sections:
本教程分为几个部分：(zh_CN)

- [Setup for the Tutorial](https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial) will give you **a starting point** to follow the tutorial.
- [教程的设置]（https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial）将为您提供**作为教程的起点**。(zh_CN)
- [Overview](https://reactjs.org/tutorial/tutorial.html#overview) will teach you **the fundamentals** of React: components, props, and state.
- [概述]（https://reactjs.org/tutorial/tutorial.html#overview）将教你** React的基本原理**：组件，道具和状态。(zh_CN)
- [Completing the Game](https://reactjs.org/tutorial/tutorial.html#completing-the-game) will teach you **the most common techniques** in React development.
- [完成游戏]（https://reactjs.org/tutorial/tutorial.html#completing-the-game）将教你** React开发中最常用的技巧**。(zh_CN)
- [Adding Time Travel](https://reactjs.org/tutorial/tutorial.html#adding-time-travel) will give you **a deeper insight** into the unique strengths of React.
- [添加时间旅行]（https://reactjs.org/tutorial/tutorial.html#adding-time-travel）将让您更深入地了解React的独特优势。(zh_CN)

You don’t have to complete all of the sections at once to get the value out of this tutorial. Try to get as far as you can — even if it’s one or two sections.
您不必一次完成所有部分以获得本教程的价值。尝试尽可能地 - 即使它是一个或两个部分。(zh_CN)

It’s fine to copy and paste code as you’re following along the tutorial, but we recommend to type it by hand. This will help you develop a muscle memory and a stronger understanding.
您可以按照教程中的说法复制和粘贴代码，但我们建议您手动输入代码。这将有助于您培养肌肉记忆和更强的理解力。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#what-are-we-building](https://reactjs.org/tutorial/tutorial.html#what-are-we-building)What Are We Building?
### [https://reactjs.org/tutorial/tutorial.html#what-are-we-building](https://reactjs.org/tutorial/tutorial.html#what-are-we-building）我们正在建设什么？(zh_CN)

In this tutorial, we’ll show how to build an interactive tic-tac-toe game with React.
在本教程中，我们将展示如何使用React构建交互式tic-tac-toe游戏。(zh_CN)

You can see what we’ll be building here: **[Final Result](https://codepen.io/gaearon/pen/gWWZgR?editors=0010)**. If the code doesn’t make sense to you, or if you are unfamiliar with the code’s syntax, don’t worry! The goal of this tutorial is to help you understand React and its syntax.
您可以在这里看到我们将要构建的内容：** [最终结果]（https://codepen.io/gaearon/pen/gWWZgR?editors=0010) **。如果代码对您没有意义，或者您不熟悉代码的语法，请不要担心！本教程的目的是帮助您了解React及其语法。(zh_CN)

We recommend that you check out the tic-tac-toe game before continuing with the tutorial. One of the features that you’ll notice is that there is a numbered list to the right of the game’s board. This list gives you a history of all of the moves that have occurred in the game, and is updated as the game progresses.
我们建议您在继续本教程之前查看井字游戏。您会注意到的一个功能是游戏棋盘右侧有一个编号列表。此列表为您提供游戏中发生的所有动作的历史记录，并随着游戏的进行而更新。(zh_CN)

You can close the tic-tac-toe game once you’re familiar with it. We’ll be starting from a simpler template in this tutorial. Our next step is to set you up so that you can start building the game.
一旦熟悉它，你就可以关闭井字游戏。我们将从本教程中的一个更简单的模板开始。我们的下一步是为您安排，以便您可以开始构建游戏。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#prerequisites](https://reactjs.org/tutorial/tutorial.html#prerequisites)Prerequisites

We’ll assume that you have some familiarity with HTML and JavaScript, but you should be able to follow along even if you’re coming from a different programming language. We’ll also assume that you’re familiar with programming concepts like functions, objects, arrays, and to a lesser extent, classes.
我们假设您对HTML和JavaScript有一定的了解，但即使您来自不同的编程语言，您也应该能够继续学习。我们还假设您熟悉编程概念，如函数，对象，数组，以及较小程度的类。(zh_CN)

If you need to review JavaScript, we recommend reading [this guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript). Note that we’re also using some features from ES6 — a recent version of JavaScript. In this tutorial, we’re using [arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions), [classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes), [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let), and [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const) statements. You can use the [Babel REPL](https://babeljs.io/repl/#?presets=react&amp;code_lz=MYewdgzgLgBApgGzgWzmWBeGAeAFgRgD4AJRBEAGhgHcQAnBAEwEJsB6AwgbgChRJY_KAEMAlmDh0YWRiGABXVOgB0AczhQAokiVQAQgE8AkowAUAcjogQUcwEpeAJTjDgUACIB5ALLK6aRklTRBQ0KCohMQk6Bx4gA) to check what ES6 code compiles to.
如果您需要查看JavaScript，我们建议您阅读[本指南]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript）。请注意，我们还使用了ES6的一些功能 - 最新版本的JavaScript。在本教程中，我们使用[arrow functions]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions），[classes]（https：// developer。 mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes），[`let`]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let ）和[`const`]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const）语句。您可以使用[巴贝尔REPL（https://babeljs.io/repl/#?presets=react&amp;code_lz=MYewdgzgLgBApgGzgWzmWBeGAeAFgRgD4AJRBEAGhgHcQAnBAEwEJsB6AwgbgChRJY_KAEMAlmDh0YWRiGABXVOgB0AczhQAokiVQAQgE8AkowAUAcjogQUcwEpeAJTjDgUACIB5ALLK6aRklTRBQ0KCohMQk6Bx4gA）检查什么ES6代码编译成。(zh_CN)

## [https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial](https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial)Setup for the Tutorial
## [https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial](https://reactjs.org/tutorial/tutorial.html#setup-for-the-tutorial）教程的设置(zh_CN)

There are two ways to complete this tutorial: you can either write the code in your browser, or you can set up a local development environment on your computer.
有两种方法可以完成本教程：您可以在浏览器中编写代码，也可以在计算机上设置本地开发环境。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#setup-option-1-write-code-in-the-browser](https://reactjs.org/tutorial/tutorial.html#setup-option-1-write-code-in-the-browser)Setup Option 1: Write Code in the Browser
### [https://reactjs.org/tutorial/tutorial.html#setup-option-1-write-code-in-the-browser](https://reactjs.org/tutorial/tutorial.html#setup-option-1 -write-in-the-browser）设置选项1：在浏览器中编写代码(zh_CN)

This is the quickest way to get started!
这是最快的入门方式！(zh_CN)

First, open this **[Starter Code](https://codepen.io/gaearon/pen/oWWQNa?editors=0010)** in a new tab. The new tab should display an empty tic-tac-toe game board and React code. We will be editing the React code in this tutorial.
首先，在新标签中打开** [入门代码]（https://codepen.io/gaearon/pen/oWWQNa?editors=0010）**。新标签应显示一个空的井字游戏板和React代码。我们将在本教程中编辑React代码。(zh_CN)

You can now skip the second setup option, and go to the [Overview](https://reactjs.org/tutorial/tutorial.html#overview) section to get an overview of React.
您现在可以跳过第二个设置选项，然后转到[概述]（https://reactjs.org/tutorial/tutorial.html#overview）部分以获取React的概述。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#setup-option-2-local-development-environment](https://reactjs.org/tutorial/tutorial.html#setup-option-2-local-development-environment)Setup Option 2: Local Development Environment
### [https://reactjs.org/tutorial/tutorial.html#setup-option-2-local-development-environment](https://reactjs.org/tutorial/tutorial.html#setup-option-2-local-development -environment）设置选项2：本地开发环境(zh_CN)

This is completely optional and not required for this tutorial!
这是完全可选的，本教程不需要！(zh_CN)
Optional: Instructions for following along locally using your preferred text editor
可选：使用首选文本编辑器在本地跟踪的说明(zh_CN)
This setup requires more work but allows you to complete the tutorial using an editor of your choice. Here are the steps to follow:
此设置需要更多工作，但允许您使用您选择的编辑器完成教程。以下是要遵循的步骤：(zh_CN)

1. Make sure you have a recent version of [Node.js](https://nodejs.org/en/) installed.
1. 确保安装了最新版本的[Node.js]（https://nodejs.org/en/）。(zh_CN)
2. Follow the [installation instructions for Create React App](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app) to make a new project.
2. 按照[创建React应用程序的安装说明]（https://reactjs.org/docs/create-a-new-react-app.html#create-react-app）创建一个新项目。(zh_CN)

    npminstall -g create-react-app
    create-react-app my-app

1. Delete all files in the `src/` folder of the new project (don’t delete the folder, just its contents).
1. 删除新项目的`src /`文件夹中的所有文件（不要删除文件夹，只删除其内容）。(zh_CN)

1. 
Add a file named `index.css` in the `src/` folder with [this CSS code](https://codepen.io/gaearon/pen/oWWQNa?editors=0100).
使用[此CSS代码]（https://codepen.io/gaearon/pen/oWWQNa?editors=0100）在`src /`文件夹中添加名为`index.css`的文件。(zh_CN)

2. 
Add a file named `index.js` in the `src/` folder with [this JS code](https://codepen.io/gaearon/pen/oWWQNa?editors=0010).
使用[此JS代码]（https://codepen.io/gaearon/pen/oWWQNa?editors=0010）在`src /`文件夹中添加名为`index.js`的文件。(zh_CN)

3. 
Add these three lines to the top of `index.js` in the `src/` folder:
将这三行添加到`src /`文件夹中`index.js`的顶部：(zh_CN)

    import React from'react';import ReactDOM from'react-dom';import'./index.css';

Now if you run `npm start` in the project folder and open `http://localhost:3000` in the browser, you should see an empty tic-tac-toe field.
现在，如果你在项目文件夹中运行`npm start`并在浏览器中打开`http：// localhost：3000`，你应该会看到一个空的tic-tac-toe字段。(zh_CN)

We recommend following [these instructions](http://babeljs.io/docs/editors) to configure syntax highlighting for your editor.
我们建议按照[这些说明]（http://babeljs.io/docs/editors）为编辑器配置语法高亮显示。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#help-im-stuck](https://reactjs.org/tutorial/tutorial.html#help-im-stuck)Help, I’m Stuck!
### [https://reactjs.org/tutorial/tutorial.html#help-im-stuck](https://reactjs.org/tutorial/tutorial.html#help-im-stuck)Help，我被困了！(zh_CN)

If you get stuck, check out the [community support resources](https://reactjs.org/community/support.html). In particular, [Reactiflux Chat](https://discord.gg/0ZcbPKXt5bZjGY5n) is a great way to get help quickly. If you don’t receive an answer, or if you remain stuck, please file an issue, and we’ll help you out.
如果您遇到困难，请查看[社区支持资源]（https://reactjs.org/community/support.html）。特别是，[Reactiflux Chat]（https://discord.gg/0ZcbPKXt5bZjGY5n）是一种快速获得帮助的好方法。如果您没有收到答复，或者您仍然遇到问题，请提出问题，我们会帮助您。(zh_CN)

## [https://reactjs.org/tutorial/tutorial.html#overview](https://reactjs.org/tutorial/tutorial.html#overview)Overview

Now that you’re set up, let’s get an overview of React!
现在您已经设置好了，让我们来看看React！(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#what-is-react](https://reactjs.org/tutorial/tutorial.html#what-is-react)What Is React?
### [https://reactjs.org/tutorial/tutorial.html#what-is-react](https://reactjs.org/tutorial/tutorial.html#what-is-react）什么是React？(zh_CN)

React is a declarative, efficient, and flexible JavaScript library for building user interfaces. It lets you compose complex UIs from small and isolated pieces of code called “components”.
React是一个用于构建用户界面的声明性，高效且灵活的JavaScript库。它允许您从称为“组件”的小而孤立的代码片段中组合复杂的UI。(zh_CN)

React has a few different kinds of components, but we’ll start with `React.Component` subclasses:
React有几种不同的组件，但我们将从`React.Component`子类开始：(zh_CN)

    classShoppingListextendsReact.Component{render(){return(<divclassName="shopping-list"><h1>Shopping List for {this.props.name}</h1><ul><li>Instagram</li><li>WhatsApp</li><li>Oculus</li></ul></div>);}}
    classShoppingListextendsReact.Component {render（）{return（<divclassName =“shopping-list”> <h1> {this.props.name}的购物清单</ h1> <ul> <li> Instagram </ li> <li> WhatsApp的</ LI> <LI>魔环</ LI> </ UL> </ DIV>）;}}(zh_CN)

We’ll get to the funny XML-like tags soon. We use components to tell React what we want to see on the screen. When our data changes, React will efficiently update and re-render our components.
我们很快就会得到有趣的类似XML的标签。我们使用组件告诉React我们想要在屏幕上看到什么。当我们的数据发生变化时，React将有效地更新和重新渲染我们的组件。(zh_CN)

Here, ShoppingList is a **React component class**, or **React component type**. A component takes in parameters, called `props` (short for “properties”), and returns a hierarchy of views to display via the `render` method.
这里，ShoppingList是** React组件类**，或** React组件类型**。组件接受名为`props`（“属性”的缩写）的参数，并返回要通过`render`方法显示的视图层次结构。(zh_CN)

The `render` method returns a *description* of what you want to see on the screen. React takes the description and displays the result. In particular, `render` returns a **React element**, which is a lightweight description of what to render. Most React developers use a special syntax called “JSX” which makes these structures easier to write. The `<div />` syntax is transformed at build time to `React.createElement('div')`. The example above is equivalent to:
`render`方法返回你想在屏幕上看到的*描述*。 React接受描述并显示结果。特别是，`render`返回一个** React元素**，它是渲染内容的轻量级描述。大多数React开发人员使用称为“JSX”的特殊语法，这使得这些结构更容易编写。 `<div />`语法在构建时转换为`React.createElement（'div'）`。上面的例子相当于：(zh_CN)

    return React.createElement('div',{className:'shopping-list'},
    返回React.createElement（'div'，{className：'shopping-list'}，(zh_CN)
      React.createElement('h1',),
      React.createElement('ul',));

[See full expanded version.](https://babeljs.io/repl/#?presets=react&amp;code_lz=DwEwlgbgBAxgNgQwM5IHIILYFMC8AiJACwHsAHUsAOwHMBaOMJAFzwD4AoKKYQgRlYDKJclWpQAMoyZQAZsQBOUAN6l5ZJADpKmLAF9gAej4cuwAK5wTXbg1YBJSswTV5mQ7c7XgtgOqEETEgAguTuYFamtgDyMBZmSGFWhhYchuAQrADc7EA)
[查看完整的扩展版本。（https://babeljs.io/repl/#?presets=react&amp;code_lz=DwEwlgbgBAxgNgQwM5IHIILYFMC8AiJACwHsAHUsAOwHMBaOMJAFzwD4AoKKYQgRlYDKJclWpQAMoyZQAZsQBOUAN6l5ZJADpKmLAF9gAej4cuwAK5wTXbg1YBJSswTV5mQ7c7XgtgOqEETEgAguTuYFamtgDyMBZmSGFWhhYchuAQrADc7EA）(zh_CN)

If you’re curious, `createElement()` is described in more detail in the [API reference](https://reactjs.org/docs/react-api.html#createelement), but we won’t be using it in this tutorial. Instead, we will keep using JSX.
如果你很好奇，在[API参考]（https://reactjs.org/docs/react-api.html#createelement）中会更详细地描述`createElement（）`，但我们不会使用它在本教程中。相反，我们将继续使用JSX。(zh_CN)

JSX comes with the full power of JavaScript. You can put *any* JavaScript expressions within braces inside JSX. Each React element is a JavaScript object that you can store in a variable or pass around in your program.
JSX具有JavaScript的全部功能。您可以将* any * JavaScript表达式放在JSX中的大括号内。每个React元素都是一个JavaScript对象，您可以将其存储在变量中或在程序中传递。(zh_CN)

The `ShoppingList` component above only renders built-in DOM components like `<div />` and `<li />`. But you can compose and render custom React components too. For example, we can now refer to the whole shopping list by writing `<ShoppingList />`. Each React component is encapsulated and can operate independently; this allows you to build complex UIs from simple components.
上面的`ShoppingList`组件只呈现内置的DOM组件，如`<div />`和`<li />`。但您也可以编写和渲染自定义React组件。例如，我们现在可以通过编写`<ShoppingList />`来引用整个购物清单。每个React组件都是封装的，可以独立运行;这允许您从简单的组件构建复杂的UI。(zh_CN)

## [https://reactjs.org/tutorial/tutorial.html#inspecting-the-starter-code](https://reactjs.org/tutorial/tutorial.html#inspecting-the-starter-code)Inspecting the Starter Code

If you’re going to work on the tutorial **in your browser,** open this code in a new tab: **[Starter Code](https://codepen.io/gaearon/pen/oWWQNa?editors=0010)**. If you’re going to work on the tutorial **locally,** instead open `src/index.js` in your project folder (you have already touched this file during the [setup](https://reactjs.org/tutorial/tutorial.html#setup-option-2-local-development-environment)).
如果您要在浏览器中处理教程**，请在新选项卡中打开此代码：** [入门代码]（https://codepen.io/gaearon/pen/oWWQNa?editors=0010 ）**。如果你打算在本地学习本教程**，而是在你的项目文件夹中打开`src / index.js`（你已经在[setup]中触及了这个文件（https://reactjs.org/教程/ tutorial.html＃设置选项-2-本地开发环境））。(zh_CN)

This Starter Code is the base of what we’re building. We’ve provided the CSS styling so that you only need focus on learning React and programming the tic-tac-toe game.
这个入门代码是我们正在构建的基础。我们提供了CSS样式，因此您只需要专注于学习React和编写井字游戏。(zh_CN)

By inspecting the code, you’ll notice that we have three React components:
通过检查代码，您会注意到我们有三个React组件：(zh_CN)

The Square component renders a single `<button>` and the Board renders 9 squares. The Game component renders a board with placeholder values which we’ll modify later. There are currently no interactive components.
Square组件呈现单个“<button>”，Board呈现9个方块。 Game组件呈现具有占位符值的板，稍后我们将对其进行修改。目前没有互动组件。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#passing-data-through-props](https://reactjs.org/tutorial/tutorial.html#passing-data-through-props)Passing Data Through Props
### [https://reactjs.org/tutorial/tutorial.html#passing-data-through-props](https://reactjs.org/tutorial/tutorial.html#passing-data-through-props)通过道具传递数据(zh_CN)

Just to get our feet wet, let’s try passing some data from our Board component to our Square component.
为了让我们的脚湿透，让我们尝试将一些数据从我们的Board组件传递到Square组件。(zh_CN)

In Board’s `renderSquare` method, change the code to pass a prop called `value` to the Square:
在Board的`renderSquare`方法中，更改代码以将名为`value`的道具传递给Square：(zh_CN)

    classBoardextendsReact.Component{renderSquare(i){return<Squarevalue={i}/>;}
    classBoardextendsReact.Component {renderSquare（I）{返回<Squarevalue = {I} />;}(zh_CN)

Change Square’s `render` method to show that value by replacing `{/* TODO */}` with `{this.props.value}`:
改变Square的`render`方法，通过用`{this.props.value}`替换`{/ * TODO * /}`来显示该值：(zh_CN)

    classSquareextendsReact.Component{render(){return(<buttonclassName="square">{this.props.value}</button>);}}
    classSquareextendsReact.Component {渲染（）{回报（<buttonclassName = “正方形”> {this.props.value} </按钮>）;}}(zh_CN)

Before:
之前：(zh_CN)

[![React Devtools](https://reactjs.org/static/tictac-empty-1566a4f8490d6b4b1ed36cd2c11fe4b6-a9336.png)](https://reactjs.org/static/tictac-empty-1566a4f8490d6b4b1ed36cd2c11fe4b6-a9336.png)

After: You should see a number in each square in the rendered output.
之后：您应该在渲染输出中的每个方块中看到一个数字。(zh_CN)

[![React Devtools](https://reactjs.org/static/tictac-numbers-685df774da6da48f451356f33f4be8b2-be875.png)](https://reactjs.org/static/tictac-numbers-685df774da6da48f451356f33f4be8b2-be875.png)

**[View the full code at this point](https://codepen.io/gaearon/pen/aWWQOG?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/aWWQOG?editors=0010) **(zh_CN)

Congratulations! You’ve just “passed a prop” from a parent Board component to a child Square component. Passing props is how information flows in React apps, from parents to children.
恭喜！您刚刚从父Board组件“传递道具”到子Square组件。传递道具是React应用程序中信息流动的方式，从父母到孩子。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component](https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component)Making an Interactive Component
### [https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component](https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component）制作交互式组件(zh_CN)

Let’s fill the Square component with an “X” when we click it.
当我们点击它时，让我们用“X”填充Square组件。(zh_CN)
First, change the button tag that is returned from the Square component’s `render()` function to this:
首先，将Square组件的`render（）`函数返回的按钮标记更改为：(zh_CN)

    classSquareextendsReact.Component{render(){return(<buttonclassName="square"onClick={function(){alert('click');}}>{this.props.value}</button>);}}
    classSquareextendsReact.Component {渲染（）{回报（<buttonclassName = “正方形” 的onClick = {函数（）{警报（ '点击'）;}}> {this.props.value} </按钮>）;}}(zh_CN)

If we click on a Square now, we should get an alert in our browser.
如果我们现在点击Square，我们应该在浏览器中收到提醒。(zh_CN)

> Note
> 注意(zh_CN)
> 
> To save typing and avoid the [confusing behavior of `this`](https://yehudakatz.com/2011/08/11/understanding-javascript-function-invocation-and-this/), we will use the [arrow function syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) for event handlers here and further below:
> 为了节省打字并避免[这个`的混淆行为]（https://yehudakatz.com/2011/08/11/understanding-javascript-function-invocation-and-this/），我们将使用[箭头功能]语法]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions），用于事件处理程序，如下所示：(zh_CN)
> 
> 
>     classSquareextendsReact.Component{render(){return(<buttonclassName="square"onClick={()=>alert('click')}>{this.props.value}</button>);}}
>     classSquareextendsReact.Component {渲染（）{回报（<buttonclassName = “正方形” 的onClick = {（）=>警报（ '点击'）}> {this.props.value} </按钮>）;}}(zh_CN)
> 
> 
> 
> Notice how with `onClick={() => alert('click')}`, we’re passing *a function* as the `onClick` prop. It only fires after a click. Forgetting `() =>` and writing `onClick={alert('click')}` is a common mistake, and would fire the alert every time the component re-renders.
> 请注意如何使用`onClick = {（）=> alert（'click'）}`，我们将*函数*作为`onClick`道具传递。它只在点击后触发。忘记`（）=>`并编写`onClick = {alert（'click'）}`是一个常见的错误，每次组件重新渲染时都会触发警报。(zh_CN)

As a next step, we want the Square component to “remember” that it got clicked, and fill it with an “X” mark. To “remember” things, components use **state**.
下一步，我们希望Square组件“记住”它被点击，并用“X”标记填充它。为了“记住”事物，组件使用**状态**。(zh_CN)

React components can have state by setting `this.state` in their constructors. `this.state` should be considered as private to a React component that it’s defined in. Let’s store the current value of the Square in `this.state`, and change it when the Square is clicked.
通过在构造函数中设置`this.state`，React组件可以具有状态。 `this.state`应该被认为是它所定义的React组件的私有。让我们将Square的当前值存储在`this.state`中，并在单击Square时更改它。(zh_CN)

First, we’ll add a constructor to the class to initialize the state:
首先，我们将在类中添加一个构造函数来初始化状态：(zh_CN)

    classSquareextendsReact.Component{constructor(props){super(props);this.state ={      value:null,};}render(){return(<buttonclassName="square"onClick={()=>alert('click')}>{this.props.value}</button>);}}
    classSquareextendsReact.Component {constructor（props）{super（props）; this.state = {value：null，};} render（）{return（<buttonclassName =“square”onClick = {（）=> alert（'click' ）}> {this.props.value} </按钮>）;}}(zh_CN)

> Note
> 注意(zh_CN)
> 
> In [JavaScript classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes), you need to always call `super` when defining the constructor of a subclass. All React component classes that have a `constructor` should start it with a `super(props)` call.
> 在[JavaScript classes]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes）中，在定义子类的构造函数时，需要始终调用`super`。所有具有`constructor`的React组件类都应该以`super（props）`调用启动它。(zh_CN)

Now we’ll change the Square’s `render` method to display the current state’s value when clicked:
现在我们将改变Square的`render`方法，以便在单击时显示当前状态的值：(zh_CN)

- Replace `this.props.value` with `this.state.value` inside the `<button>` tag.
- 在`<button>`标记内用`this.state.value`替换`this.props.value`。(zh_CN)
- Replace the `() => alert()` event handler with `() => this.setState({value: 'X'})`.
- 用`（）=> this.setState（{value：'X'}）`替换`（）=> alert（）`事件处理程序。(zh_CN)
- Put the `className` and `onClick` props on separate lines for better readability.
- 将`className`和`onClick`道具放在不同的行上以提高可读性。(zh_CN)

After these changes, the `<button>` tag that is returned by the Square’s `render` method looks like this:
在这些更改之后，Square的`render`方法返回的`<button>`标记如下所示：(zh_CN)

    classSquareextendsReact.Component{constructor(props){super(props);this.state ={
          value:null,};}render(){return(<buttonclassName="square"onClick={()=>this.setState({value:'X'})}>{this.state.value}</button>);}}
          值：空，};}渲染（）{回报（<buttonclassName = “正方形” 的onClick = {（）=> this.setState（{值： 'X'}）}> {this.state.value} </按钮>）;}}(zh_CN)

By calling `this.setState` from an `onClick` handler in the Square’s `render` method, we tell React to re-render that Square whenever its `<button>` is clicked. After the update, the Square’s `this.state.value` will be `'X'`, so we’ll see the `X` on the game board. If you click on any Square, an `X` should show up.
通过在Square的`render`方法中从`onClick`处理程序调用`this.setState`，我们告诉React在点击它的`<button>`时重新渲染该Square。更新后，Square的`this.state.value`将为''X'，所以我们将在游戏板上看到`X`。如果你点击任何Square，就会出现一个`X`。(zh_CN)

When you call `setState` in a component, React automatically updates the child components inside of it too.
当您在组件中调用`setState`时，React也会自动更新其中的子组件。(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/VbbVLg?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/VbbVLg?editors=0010) **(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#developer-tools](https://reactjs.org/tutorial/tutorial.html#developer-tools)Developer Tools

The React Devtools extension for [Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/) lets you inspect a React component tree with your browser’s developer tools.
[Chrome]的React Devtools扩展程序（https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en）和[Firefox]（https://addons.mozilla.org/ en-US / firefox / addon / react-devtools /）允许您使用浏览器的开发人员工具检查React组件树。(zh_CN)
[![React Devtools](https://reactjs.org/static/devtools-878d91461c78d8f238e116477dfe0b46-6ca3b.png)](https://reactjs.org/static/devtools-878d91461c78d8f238e116477dfe0b46-6ca3b.png)
The React DevTools let you check the props and the state of your React components.
React DevTools让您检查React组件的道具和状态。(zh_CN)

After installing React DevTools, you can right-click on any element on the page, click “Inspect” to open the developer tools, and the React tab will appear as the last tab to the right.
安装React DevTools后，您可以右键单击页面上的任何元素，单击“Inspect”打开开发人员工具，React选项卡将显示为右侧的最后一个选项卡。(zh_CN)

**However, note there are a few extra steps to get it working with CodePen:**
**但是，请注意有一些额外的步骤可以使它与CodePen一起使用：**(zh_CN)

1. Log in or register and confirm your email (required to prevent spam).
1. 登录或注册并确认您的电子邮件（防止垃圾邮件所需）。(zh_CN)
2. Click the “Fork” button.
2. 单击“Fork”按钮。(zh_CN)
3. Click “Change View” and then choose “Debug mode”.
3. 单击“更改视图”，然后选择“调试模式”。(zh_CN)
4. In the new tab that opens, the devtools should now have a React tab.
4. 在打开的新选项卡中，devtools现在应该有一个React选项卡。(zh_CN)

## [https://reactjs.org/tutorial/tutorial.html#completing-the-game](https://reactjs.org/tutorial/tutorial.html#completing-the-game)Completing the Game

We now have the basic building blocks for our tic-tac-toe game. To have a complete game, we now need to alternate placing “X”s and “O”s on the board, and we need a way to determine a winner.
我们现在拥有我们的井字游戏的基本构建模块。要拥有一个完整的游戏，我们现在需要在棋盘上交替放置“X”和“O”，我们需要一种方法来确定胜利者。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#lifting-state-up](https://reactjs.org/tutorial/tutorial.html#lifting-state-up)Lifting State Up

Currently, each Square component maintains the game’s state. To check for a winner, we’ll maintain the value of each of the 9 squares in one location.
目前，每个Square组件都维持游戏的状态。为了检查获胜者，我们将在一个位置保持9个方格中每个方格的值。(zh_CN)

We may think that Board should just ask each Square for the Square’s state. Although this approach is possible in React, we discourage it because the code becomes difficult to understand, susceptible to bugs, and hard to refactor. Instead, the best approach is to store the game’s state in the parent Board component instead of in each Square. The Board component can tell each Square what to display by passing a prop, [just like we did when we passed a number to each Square](https://reactjs.org/tutorial/tutorial.html#passing-data-through-props).
我们可能认为董事会应该向每个广场询问Square的状态。虽然这种方法在React中是可行的，但我们不鼓励它，因为代码变得难以理解，易受错误影响，并且难以重构。相反，最好的方法是将游戏的状态存储在父Board组件中，而不是存储在每个Square中。 Board组件可以通过传递prop来告诉每个Square要显示什么，[就像我们将数字传递给每个Square时所做的那样]（https://reactjs.org/tutorial/tutorial.html#passing-data-through-道具）。(zh_CN)

**To collect data from multiple children, or to have two child components communicate with each other, you need to declare the shared state in their parent component instead. The parent component can pass the state back down to the children by using props; this keeps the child components in sync with each other and with the parent component.**
**要从多个子级收集数据，或者让两个子组件相互通信，您需要在其父组件中声明共享状态。父组件可以使用props将状态传递回子节点;这可以使子组件彼此同步并与父组件保持同步。**(zh_CN)

Lifting state into a parent component is common when React components are refactored — let’s take this opportunity to try it out. We’ll add a constructor to the Board and set the Board’s initial state to contain an array with 9 nulls. These 9 nulls correspond to the 9 squares:
当React组件被重构时，将状态提升为父组件是很常见的 - 让我们借此机会尝试一下。我们将向Board添加一个构造函数，并将Board的初始状态设置为包含一个包含9个空值的数组。这9个空值对应9个方块：(zh_CN)

    classBoardextendsReact.Component{constructor(props){super(props);this.state ={      squares:Array(9).fill(null),};}renderSquare(i){return<Squarevalue={i}/>;}render(){const status ='Next player: X';return(<div><divclassName="status">{status}</div><divclassName="board-row">{this.renderSquare(0)}{this.renderSquare(1)}{this.renderSquare(2)}</div><divclassName="board-row">{this.renderSquare(3)}{this.renderSquare(4)}{this.renderSquare(5)}</div><divclassName="board-row">{this.renderSquare(6)}{this.renderSquare(7)}{this.renderSquare(8)}</div></div>);}}
    classBoardextendsReact.Component {constructor（props）{super（props）; this.state = {squares：Array（9）.fill（null），};} renderSquare（i）{return <Squarevalue = {i} />;} render（）{const status ='下一个玩家：X';返回（<div> <divclassName =“status”> {status} </ div> <divclassName =“board-row”> {this.renderSquare（0）} {this.renderSquare（1）} {this.renderSquare（2）} </ DIV> <divclassName = “板排”> {this.renderSquare（3）} {this.renderSquare（4）} {this.renderSquare（ 5）} </ DIV> <divclassName = “板排”> {this.renderSquare（6）} {this.renderSquare（7）} {this.renderSquare（8）} </ DIV> </ DIV>）; }}(zh_CN)

When we fill the board in later, the board will look something like this:
当我们稍后填写董事会时，董事会将看起来像这样：(zh_CN)

    ['O',null,'X','X','X','O','O',null,null,]

The Board’s `renderSquare` method currently looks like this:
Board的`renderSquare`方法目前看起来像这样：(zh_CN)

    renderSquare(i){return<Squarevalue={i}/>;}
    renderSquare（I）{返回<Squarevalue = {I} />;}(zh_CN)

In the beginning, we [passed the `value` prop down](https://reactjs.org/tutorial/tutorial.html#passing-data-through-props) from the Board to show numbers from 0 to 8 in every Square. In a different previous step, we replaced the numbers with an “X” mark [determined by Square’s own state](https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component). This is why Square currently ignores the `value` prop passed to it by the Board.
一开始，我们[从董事会传递了`value` prop down]（https://reactjs.org/tutorial/tutorial.html#passing-data-through-props），在每个广场显示0到8的数字。在前面的不同步骤中，我们将数字替换为“X”标记[由Square自己的状态确定]（https://reactjs.org/tutorial/tutorial.html#making-an-interactive-component）。这就是为什么Square目前忽略了董事会传递给它的“价值”道具。(zh_CN)

We will now use the prop passing mechanism again. We will modify the Board to instruct each individual Square about its current value (`'X'`, `'O'`, or `null`). We have already defined the `squares` array in the Board’s constructor, and we will modify the Board’s `renderSquare` method to read from it:
我们现在再次使用道具传递机制。我们将修改董事会，以指示每个广场的当前价值（“X”，“O'”或“null”）。我们已经在Board的构造函数中定义了`squares`数组，我们将修改Board的`renderSquare`方法来读取它：(zh_CN)

    renderSquare(i){return<Squarevalue={this.state.squares[i]}/>;}
    renderSquare（I）{返回<Squarevalue = {this.state.squares [I]} />;}(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/gWWQPY?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/gWWQPY?editors=0010) **(zh_CN)

Each Square will now receive a `value` prop that will either be `'X'`, `'O'`, or `null` for empty squares.
每个Square现在都会收到一个'value`道具，它对于空方块要么是''X'，要么是''，要么是'null`。(zh_CN)

Next, we need to change what happens when a Square is clicked. The Board component now maintains which squares are filled. We need to create a way for the Square to update the Board’s state. Since state is considered to be private to a component that defines it, we cannot update the Board’s state directly from Square.
接下来，我们需要更改单击Square时发生的情况。 Board组件现在维护填充的方块。我们需要为Square创建一种更新Board状态的方法。由于状态被认为是定义它的组件的私有状态，因此我们无法直接从Square更新Board的状态。(zh_CN)

To maintain the Board’s state’s privacy, we’ll pass down a function from the Board to the Square. This function will get called when a Square is clicked. We’ll change the `renderSquare` method in Board to:
为了维护董事会的国家隐私，我们将从董事会向广场传递一项功能。单击Square时将调用此函数。我们将把Board中的`renderSquare`方法更改为：(zh_CN)

    renderSquare(i){return(<Squarevalue={this.state.squares[i]}onClick={()=>this.handleClick(i)}/>);}
    renderSquare（I）{返回（<Squarevalue = {this.state.squares [I]}的onClick = {（）=> this.handleClick（I）} />）;}(zh_CN)

> Note
> 注意(zh_CN)
> 
> We split the returned element into multiple lines for readability, and added parentheses so that JavaScript doesn’t insert a semicolon after `return` and break our code.
> 为了便于阅读，我们将返回的元素拆分为多行，并添加了括号，以便JavaScript在`return`之后不插入分号并破坏我们的代码。(zh_CN)

Now we’re passing down two props from Board to Square: `value` and `onClick`. The `onClick` prop is a function that Square can call when clicked. We’ll make the following changes to Square:
现在我们传递了两个从Board到Square的道具：`value`和`onClick`。 `onClick` prop是Square在点击时可以调用的函数。我们将对Square进行以下更改：(zh_CN)

- Replace `this.state.value` with `this.props.value` in Square’s `render` method
- 用Square的`render`方法中的`this.props.value`替换`this.state.value`(zh_CN)
- Replace `this.setState()` with `this.props.onClick()` in Square’s `render` method
- 用Square的`render`方法中的`this.props.onClick（）`替换`this.setState（）`(zh_CN)
- Delete the `constructor` from Square because Square no longer keeps track of the game’s state
- 从Square中删除`constructor`，因为Square不再跟踪游戏的状态(zh_CN)

After these changes, the Square component looks like this:
完成这些更改后，Square组件如下所示：(zh_CN)

    classSquareextendsReact.Component{render(){return(<buttonclassName="square"onClick={()=>this.props.onClick()}>{this.props.value}</button>);}}
    classSquareextendsReact.Component {渲染（）{回报（<buttonclassName = “正方形” 的onClick = {（）=> this.props.onClick（）}> {this.props.value} </按钮>）;}}(zh_CN)

When a Square is clicked, the `onClick` function provided by the Board is called. Here’s a review of how this is achieved:
单击Square时，将调用Board提供的`onClick`功能。以下是对如何实现这一目标的回顾：(zh_CN)

1. The `onClick` prop on the built-in DOM `<button>` component tells React to set up a click event listener.
1. 内置DOM` <button>`组件的`onClick` prop告诉React设置一个click事件监听器。(zh_CN)
2. When the button is clicked, React will call the `onClick` event handler that is defined in Square’s `render()` method.
2. 单击该按钮时，React将调用Square的`render（）`方法中定义的`onClick`事件处理程序。(zh_CN)
3. This event handler calls `this.props.onClick()`. The Square’s `onClick` prop was specified by the Board.
3. 这个事件处理程序调用`this.props.onClick（）`。 Square的'onClick`道具由董事会指定。(zh_CN)
4. Since the Board passed `onClick={() => this.handleClick(i)}` to Square, the Square calls `this.handleClick(i)` when clicked.
4. 由于董事会将`onClick = {（）=> this.handleClick（i）}`传递给Square，Square点击时调用`this.handleClick（i）`。(zh_CN)
5. We have not defined the `handleClick()` method yet, so our code crashes.
5. 我们还没有定义`handleClick（）`方法，所以我们的代码崩溃了。(zh_CN)

> Note
> 注意(zh_CN)
> 
> The DOM `<button>` element’s `onClick` attribute has a special meaning to React because it is a built-in component. For custom components like Square, the naming is up to you. We could name the Square’s `onClick` prop or Board’s `handleClick` method differently. In React, however, it is a convention to use `on[Event]` names for props which represent events and `handle[Event]` for the methods which handle the events.
> DOM` <button>`元素的`onClick`属性对React有特殊意义，因为它是一个内置组件。对于像Square这样的自定义组件，命名取决于您。我们可以用不同的方式命名Square的`onClick` prop或Board的`handleClick`方法。但是，在React中，对于表示事件的props使用`on [Event]`名称，对处理事件的方法使用`handle [Event]`。(zh_CN)

When we try to click a Square, we should get an error because we haven’t defined `handleClick` yet. We’ll now add `handleClick` to the Board class:
当我们尝试单击Square时，我们应该得到一个错误，因为我们还没有定义`handleClick`。我们现在将`handleClick`添加到Board类：(zh_CN)

    classBoardextendsReact.Component{constructor(props){super(props);this.state ={
          squares:Array(9).fill(null),};}handleClick(i){const squares =this.state.squares.slice();    squares[i]='X';this.setState({squares: squares});}renderSquare(i){return(<Squarevalue={this.state.squares[i]}onClick={()=>this.handleClick(i)}/>);}render(){const status ='Next player: X';return(<div><divclassName="status">{status}</div><divclassName="board-row">{this.renderSquare(0)}{this.renderSquare(1)}{this.renderSquare(2)}</div><divclassName="board-row">{this.renderSquare(3)}{this.renderSquare(4)}{this.renderSquare(5)}</div><divclassName="board-row">{this.renderSquare(6)}{this.renderSquare(7)}{this.renderSquare(8)}</div></div>);}}
          squares：Array（9）.fill（null），};} handleClick（i）{const squares = this.state.squares.slice（）; squares [i] ='X'; this.setState（{squares：squares}）;} renderSquare（i）{return（<Squarevalue = {this.state.squares [i]} onClick = {（）=> this。 handleClick（i）} />）;} render（）{const status ='下一个玩家：X';返回（<div> <divclassName =“status”> {status} </ div> <divclassName =“board-row “> {this.renderSquare（0）} {this.renderSquare（1）} {this.renderSquare（2）} </ DIV> <divclassName =” 板排“> {this.renderSquare（3）} {此。 renderSquare（4）} {this.renderSquare（5）} </ DIV> <divclassName = “板排”> {this.renderSquare（6）} {this.renderSquare（7）} {this.renderSquare（8）} </ DIV> </ DIV>）;}}(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/ybbQJX?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/ybbQJX?editors=0010) **(zh_CN)

After these changes, we’re again able to click on the Squares to fill them. However, now the state is stored in the Board component instead of the individual Square components. When the Board’s state changes, the Square components re-render automatically. Keeping the state of all squares in the Board component will allow it to determine the winner in the future.
在这些变化之后，我们再次能够点击Squares来填充它们。但是，现在状态存储在Board组件中而不是单个Square组件中。当Board的状态发生变化时，Square组件会自动重新渲染。保持Board组件中所有方块的状态将允许它在将来确定胜利者。(zh_CN)

Since the Square components no longer maintain state, the Square components receive values from the Board component and inform the Board component when they’re clicked. In React terms, the Square components are now **controlled components**. The Board has full control over them.
由于Square组件不再维持状态，Square组件从Board组件接收值，并在单击它们时通知Board组件。在React术语中，Square组件现在是**受控组件**。董事会完全控制他们。(zh_CN)

Note how in `handleClick`, we call `.slice()` to create a copy of the `squares` array to modify instead of modifying the existing array. We will explain why we create a copy of the `squares` array in the next section.
注意在`handleClick`中，我们调用`.slice（）`来创建`squares`数组的副本来修改而不是修改现有的数组。我们将解释为什么我们在下一节中创建`squares`数组的副本。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#why-immutability-is-important](https://reactjs.org/tutorial/tutorial.html#why-immutability-is-important)Why Immutability Is Important
### [https://reactjs.org/tutorial/tutorial.html#why-immutability-is-important](https://reactjs.org/tutorial/tutorial.html#why-immutability-is-important）为什么不变性很重要(zh_CN)

In the previous code example, we suggested that you use the `.slice()` operator to create a copy of the `squares` array to modify instead of modifying the existing array. We’ll now discuss immutability and why immutability is important to learn.
在前面的代码示例中，我们建议您使用`.slice（）`运算符来创建`squares`数组的副本以进行修改，而不是修改现有数组。我们现在将讨论不变性以及为什么不可变性对于学习很重要。(zh_CN)

There are generally two approaches to changing data. The first approach is to *mutate* the data by directly changing the data’s values. The second approach is to replace the data with a new copy which has the desired changes.
通常有两种改变数据的方法。第一种方法是通过直接改变数据的值来*变换数据。第二种方法是用具有所需更改的新副本替换数据。(zh_CN)

#### [https://reactjs.org/tutorial/tutorial.html#data-change-with-mutation](https://reactjs.org/tutorial/tutorial.html#data-change-with-mutation)Data Change with Mutation
#### [https://reactjs.org/tutorial/tutorial.html#data-change-with-mutation](https://reactjs.org/tutorial/tutorial.html#data-change-with-mutation）变异数据变更(zh_CN)

    var player ={score:1, name:'Jeff'};
    var player = {得分：1，名字：'杰夫'};(zh_CN)
    player.score =2;

#### [https://reactjs.org/tutorial/tutorial.html#data-change-without-mutation](https://reactjs.org/tutorial/tutorial.html#data-change-without-mutation)Data Change without Mutation
#### [https://reactjs.org/tutorial/tutorial.html#data-change-without-mutation](https://reactjs.org/tutorial/tutorial.html#data-change-without-mutation）没有变异的数据变更(zh_CN)

    var player ={score:1, name:'Jeff'};var newPlayer = Object.assign({}, player,{score:2});// Or if you are using object spread syntax proposal, you can write:
    var player = {score：1，name：'Jeff'}; var newPlayer = Object.assign（{}，player，{score：2}）; //或者如果您使用的是对象扩展语法提议，您可以编写：(zh_CN)

The end result is the same but by not mutating (or changing the underlying data) directly, we gain several benefits described below.
最终结果是相同的，但通过不直接改变（或改变基础数据），我们获得了下面描述的几个好处。(zh_CN)

#### [https://reactjs.org/tutorial/tutorial.html#complex-features-become-simple](https://reactjs.org/tutorial/tutorial.html#complex-features-become-simple)Complex Features Become Simple
#### [https://reactjs.org/tutorial/tutorial.html#complex-features-become-simple](https://reactjs.org/tutorial/tutorial.html#complex-features-become-simple)Complex功能变得简单(zh_CN)

Immutability makes complex features much easier to implement. Later in this tutorial, we will implement a “time travel” feature that allows us to review the tic-tac-toe game’s history and “jump back” to previous moves. This functionality isn’t specific to games — an ability to undo and redo certain actions is a common requirement in applications. Avoiding direct data mutation lets us keep previous versions of the game’s history intact, and reuse them later.
不可变性使复杂功能更容易实现。在本教程的后面，我们将实现一个“时间旅行”功能，允许我们查看井字游戏的历史记录并“跳回”以前的动作。此功能并非特定于游戏 - 撤消和重做某些操作的能力是应用程序中的常见要求。避免直接数据突变可以让我们保留游戏历史的先前版本，并在以后重复使用。(zh_CN)

#### [https://reactjs.org/tutorial/tutorial.html#detecting-changes](https://reactjs.org/tutorial/tutorial.html#detecting-changes)Detecting Changes
#### [https://reactjs.org/tutorial/tutorial.html#detecting-changes](https://reactjs.org/tutorial/tutorial.html#detecting-changes)检测更改(zh_CN)

Detecting changes in mutable objects is difficult because they are modified directly. This detection requires the mutable object to be compared to previous copies of itself and the entire object tree to be traversed.
检测可变对象的变化很困难，因为它们是直接修改的。此检测需要将可变对象与其自身的先前副本和要遍历的整个对象树进行比较。(zh_CN)

Detecting changes in immutable objects is considerably easier. If the immutable object that is being referenced is different than the previous one, then the object has changed.
检测不可变对象中的更改要容易得多。如果被引用的不可变对象与前一个不同，则该对象已更改。(zh_CN)

#### [https://reactjs.org/tutorial/tutorial.html#determining-when-to-re-render-in-react](https://reactjs.org/tutorial/tutorial.html#determining-when-to-re-render-in-react)Determining When to Re-render in React
#### [https://reactjs.org/tutorial/tutorial.html#determining-when-to-re-render-in-react](https://reactjs.org/tutorial/tutorial.html#determining-when-to-re -render-in-react）确定何时在React中重新渲染(zh_CN)

The main benefit of immutability is that it helps you build *pure components* in React. Immutable data can easily determine if changes have been made which helps to determine when a component requires re-rendering.
不变性的主要好处是它可以帮助你在React中构建*纯组件*。不可变数据可以很容易地确定是否已经进行了更改，这有助于确定组件何时需要重新呈现。(zh_CN)

You can learn more about `shouldComponentUpdate()` and how you can build *pure components* by reading [Optimizing Performance](https://reactjs.org/docs/optimizing-performance.html#examples).
您可以通过阅读[优化性能]（https://reactjs.org/docs/optimizing-performance.html#examples）了解有关`shouldComponentUpdate（）`以及如何构建*纯组件*的更多信息。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#functional-components](https://reactjs.org/tutorial/tutorial.html#functional-components)Functional Components

We’ll now change the Square to be a **functional component**.
我们现在将Square改为**功能组件**。(zh_CN)

In React, **functional components** are a simpler way to write components that only contain a `render` method and don’t have their own state. Instead of defining a class which extends `React.Component`, we can write a function that takes `props` as input and returns what should be rendered. Functional components are less tedious to write than classes, and many components can be expressed this way.
在React中，**函数组件**是一种更简单的方法来编写只包含`render`方法且没有自己状态的组件。我们可以编写一个将`props`作为输入并返回应该呈现的内容的函数，而不是定义一个扩展`React.Component`的类。功能组件的编写比类更乏味，许多组件可以这种方式表达。(zh_CN)

Replace the Square class with this function:
用这个函数替换Square类：(zh_CN)

    functionSquare(props){return(<buttonclassName="square"onClick={props.onClick}>{props.value}</button>);}
    functionSquare（道具）{返回（<buttonclassName = “正方形” 的onClick = {props.onClick}> {props.value} </按钮>）;}(zh_CN)

We have changed `this.props` to `props` both times it appears.
我们两次出现时都将`this.props`改为`props`。(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/QvvJOv?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/QvvJOv?editors=0010) **(zh_CN)

> Note
> 注意(zh_CN)
> 
> When we modified the Square to be a functional component, we also changed `onClick={() => this.props.onClick()}` to a shorter `onClick={props.onClick}` (note the lack of parentheses on *both* sides). In a class, we used an arrow function to access the correct `this` value, but in a functional component we don’t need to worry about `this`.
> 当我们将Square修改为一个功能组件时，我们还将`onClick = {（）=> this.props.onClick（）}更改为更短的`onClick = {props.onClick}`（注意缺少括号*双方）。在类中，我们使用箭头函数来访问正确的`this`值，但在功能组件中我们不需要担心`this`。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#taking-turns](https://reactjs.org/tutorial/tutorial.html#taking-turns)Taking Turns

We now need to fix an obvious defect in our tic-tac-toe game: the “O”s cannot be marked on the board.
我们现在需要在我们的井字游戏中修复一个明显的缺陷：无法在棋盘上标记“O”。(zh_CN)

We’ll set the the first move to be “X” by default. We can set this default by modifying the initial state in our Board constructor:
我们默认将第一步设置为“X”。我们可以通过修改Board构造函数中的初始状态来设置此默认值：(zh_CN)

    classBoardextendsReact.Component{constructor(props){super(props);this.state ={
          squares:Array(9).fill(null),      xIsNext:true,};}

Each time a player moves, `xIsNext` (a boolean) will be flipped to determine which player goes next and the game’s state will be saved. We’ll update the Board’s `handleClick` function to flip the value of `xIsNext`:
每次玩家移动时，将翻转`xIsNext`（布尔值）以确定接下来哪个玩家进入并且将保存游戏的状态。我们将更新Board的`handleClick`函数来翻转`xIsNext`的值：(zh_CN)

    handleClick(i){const squares =this.state.squares.slice();    squares[i]=this.state.xIsNext ?'X':'O';this.setState({
          squares: squares,      xIsNext:!this.state.xIsNext,});}

With this change, “X”s and “O”s can take turns. Let’s also change the “status” text in Board’s `render` so that it displays which player has the next turn:
通过这种改变，“X”和“O”可以轮流进行。让我们也改变Board的`render`中的“status”文本，以便它显示哪个玩家有下一个回合：(zh_CN)

    render(){const status ='Next player: '+(this.state.xIsNext ?'X':'O');return(
    render（）{const status ='下一个玩家：'+（this.state.xIsNext？'X'：'O'）;返回（(zh_CN)

After applying these changes, you should have this Board component:
应用这些更改后，您应该拥有此Board组件：(zh_CN)

    classBoardextendsReact.Component{constructor(props){super(props);this.state ={
          squares:Array(9).fill(null),      xIsNext:true,};}handleClick(i){const squares =this.state.squares.slice();    squares[i]=this.state.xIsNext ?'X':'O';this.setState({      squares: squares,      xIsNext:!this.state.xIsNext,});}renderSquare(i){return(<Squarevalue={this.state.squares[i]}onClick={()=>this.handleClick(i)}/>);}render(){const status ='Next player: '+(this.state.xIsNext ?'X':'O');return(<div><divclassName="status">{status}</div><divclassName="board-row">{this.renderSquare(0)}{this.renderSquare(1)}{this.renderSquare(2)}</div><divclassName="board-row">{this.renderSquare(3)}{this.renderSquare(4)}{this.renderSquare(5)}</div><divclassName="board-row">{this.renderSquare(6)}{this.renderSquare(7)}{this.renderSquare(8)}</div></div>);}}
          squares：Array（9）.fill（null），xIsNext：true，};} handleClick（i）{const squares = this.state.squares.slice（）; squares [i] = this.state.xIsNext？'X'：'O'; this.setState（{square：squares，xIsNext：！this.state.xIsNext，}）;} renderSquare（i）{return（<Squarevalue = {this.state.squares [i]} onClick = {（）=> this.handleClick（i）} />）;} render（）{const status ='下一个玩家：'+（this.state.xIsNext？ 'X'： 'O'）;返回（<DIV> <divclassName = “状态”> {状态} </ DIV> <divclassName = “板排”> {this.renderSquare（0）} {this.renderSquare（ 1）} {this.renderSquare（2）} </ DIV> <divclassName = “板排”> {this.renderSquare（3）} {this.renderSquare（4）} {this.renderSquare（5）} </ DIV> <divclassName = “板排”> {this.renderSquare（6）} {this.renderSquare（7）} {this.renderSquare（8）} </ DIV> </ DIV>）;}}(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/KmmrBy?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/KmmrBy?editors=0010) **(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#declaring-a-winner](https://reactjs.org/tutorial/tutorial.html#declaring-a-winner)Declaring a Winner
### [https://reactjs.org/tutorial/tutorial.html#declaring-a-winner](https://reactjs.org/tutorial/tutorial.html#declaring-a-winner）宣布获胜者(zh_CN)

Now that we show which player’s turn is next, we should also show when the game is won and there are no more turns to make. We can determine a winner by adding this helper function to the end of the file:
现在我们展示下一个玩家的转弯，我们还应该展示何时赢得比赛并且没有更多的转弯。我们可以通过将此帮助函数添加到文件末尾来确定获胜者：(zh_CN)

    functioncalculateWinner(squares){const lines =[[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6],];for(let i =0; i < lines.length; i++){const[a, b, c]= lines[i];if(squares[a]&& squares[a]=== squares[b]&& squares[a]=== squares[c]){return squares[a];}}returnnull;}
    functioncalculateWinner（squares）{const lines = [[0,1,2]，[3,4,5]，[6,7,8]，[0,3,6]，[1,4,7]，[ 2,5,8]，[0,4,8]，[2,4,6]，];对于（let i = 0; i <lines.length; i ++）{const [a，b，c] = lines [i]; if（square [a] && squares [a] === squares [b] && squares [a] === squares [c]）{return squares [a];}} returnnull;}(zh_CN)

We will call `calculateWinner(squares)` in the Board’s `render` function to check if a player has won. If a player has won, we can display text such as “Winner: X” or “Winner: O”. We’ll replace the `status` declaration in Board’s `render` function with this code:
我们将在Board的`render`函数中调用`calculateWinner（squares）`以检查玩家是否赢了。如果玩家获胜，我们可以显示诸如“Winner：X”或“Winner：O”之类的文本。我们将使用以下代码替换Board的`render`函数中的`status`声明：(zh_CN)

    render(){const winner =calculateWinner(this.state.squares);let status;if(winner){      status ='Winner: '+ winner;}else{      status ='Next player: '+(this.state.xIsNext ?'X':'O');}return(
    render（）{const winner = calculateWinner（this.state.squares）; let status; if（winner）{status ='Winner：'+ winner;} else {status ='Next player：'+（this.state.xIsNext ？ 'X'： 'O'）;}回报（(zh_CN)

We can now change the Board’s `handleClick` function to return early by ignoring a click if someone has won the game or if a Square is already filled:
我们现在可以更改Board的`handleClick`功能，如果某人赢了游戏或者Square已经填满，则忽略点击以提前返回：(zh_CN)

    handleClick(i){const squares =this.state.squares.slice();if(calculateWinner(squares)|| squares[i]){return;}    squares[i]=this.state.xIsNext ?'X':'O';this.setState({
          squares: squares,
          正方形：正方形，(zh_CN)
          xIsNext:!this.state.xIsNext,});}

**[View the full code at this point](https://codepen.io/gaearon/pen/LyyXgK?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/LyyXgK?editors=0010) **(zh_CN)

Congratulations! You now have a working tic-tac-toe game. And you’ve just learned the basics of React too. So *you’re* probably the real winner here.
恭喜！你现在有一个工作的井字游戏。你刚刚学到了React的基础知识。所以*你可能是真正的胜利者。(zh_CN)

As a final exercise, let’s make it possible to “go back in time” to the previous moves in the game.
作为最后的练习，让我们可以“回到过去的时间”到之前的游戏动作。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#storing-a-history-of-moves](https://reactjs.org/tutorial/tutorial.html#storing-a-history-of-moves)Storing a History of Moves
### [https://reactjs.org/tutorial/tutorial.html#storing-a-history-of-moves](https://reactjs.org/tutorial/tutorial.html#storing-a-history-of-moves)Storing移动历史(zh_CN)

If we mutated the `squares` array, implementing time travel would be very difficult.
如果我们改变了`square`数组，实现时间旅行将非常困难。(zh_CN)

However, we used `slice()` to create a new copy of the `squares` array after every move, and [treated it as immutable](https://reactjs.org/tutorial/tutorial.html#why-immutability-is-important). This will allow us to store every past version of the `squares` array, and navigate between the turns that have already happened.
但是，我们使用`slice（）`在每次移动后创建`squares`数组的新副本，并[将其视为不可变]（https://reactjs.org/tutorial/tutorial.html#why-immutability-是重要的）。这将允许我们存储`square`数组的每个过去版本，并在已经发生的转弯之间导航。(zh_CN)

We’ll store the past `squares` arrays in another array called `history`. The `history` array represents all board states, from the first to the last move, and has a shape like this:
我们将过去的`square`数组存储在另一个名为`history`的数组中。 `history`数组表示从第一个到最后一个移动的所有板状态，并且具有如下形状：(zh_CN)

    history =[{
        squares:[null,null,null,null,null,null,null,null,null,]},{
        正方形：[NULL，NULL，NULL，NULL，NULL，NULL，NULL，NULL，NULL，]}，{(zh_CN)
        squares:[null,null,null,null,'X',null,null,null,null,]},{
        正方形：[NULL，NULL，NULL，NULL， 'X'，NULL，NULL，NULL，NULL，]}，{(zh_CN)
        squares:[null,null,null,null,'X',null,null,null,'O',]},]
        正方形：[NULL，NULL，NULL，NULL， 'X'，NULL，NULL，NULL， 'O'，]}，](zh_CN)

Now we need to decide which component should own the `history` state.
现在我们需要决定哪个组件应该拥有`history`状态。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#lifting-state-up-again](https://reactjs.org/tutorial/tutorial.html#lifting-state-up-again)Lifting State Up, Again
### [https://reactjs.org/tutorial/tutorial.html#lifting-state-up-again](https://reactjs.org/tutorial/tutorial.html#lifting-state-up-again)再次提升状态(zh_CN)

We’ll want the top-level Game component to display a list of past moves. It will need access to the `history` to do that, so we will place the `history` state in the top-level Game component.
我们希望顶级游戏组件显示过去移动的列表。它需要访问`history`来做到这一点，所以我们将`history`状态放在顶级Game组件中。(zh_CN)

Placing the `history` state into the Game component lets us remove the `squares` state from its child Board component. Just like we [“lifted state up”](https://reactjs.org/tutorial/tutorial.html#lifting-state-up) from the Square component into the Board component, we are now lifting it up from the Board into the top-level Game component. This gives the Game component full control over the Board’s data, and lets it instruct the Board to render previous turns from the `history`.
将`history`状态放入Game组件可以让我们从子Board组件中删除`squares`状态。就像我们从广场组件进入董事会组件一样[“提升状态”]（https://reactjs.org/tutorial/tutorial.html#lifting-state-up），我们现在将其从董事会提升为顶级游戏组件。这使得Game组件可以完全控制Board的数据，并让它指示Board从`history`渲染之前的转弯。(zh_CN)

First, we’ll set up the initial state for the Game component within its constructor:
首先，我们将在其构造函数中为Game组件设置初始状态：(zh_CN)

    classGameextendsReact.Component{constructor(props){super(props);this.state ={      history:[{        squares:Array(9).fill(null),}],      xIsNext:true,};}render(){return(<divclassName="game"><divclassName="game-board"><Board/></div><divclassName="game-info"><div>{}</div><ol>{}</ol></div></div>);}}
    classGameextendsReact.Component {constructor（props）{super（props）; this.state = {history：[{squares：Array（9）.fill（null），}]，xIsNext：true，};} render（）{return （<divclassName = “游戏”> <divclassName = “游戏板”> <板/> </ DIV> <divclassName = “游戏信息”> <DIV> {} </ DIV> <OL> {} </醇> </ DIV> </ DIV>）;}}(zh_CN)

Next, we’ll have the Board component receive `squares` and `onClick` props from the Game component. Since we now have a single click handler in Board for many Squares, we’ll need to pass the location of each Square into the `onClick` handler to indicate which Square was clicked. Here are the required steps to transform the Board component:
接下来，我们将让Board组件从Game组件接收`squares`和`onClick`道具。由于我们现在在Board中有一个单击处理程序用于许多Squares，我们需要将每个Square的位置传递到`onClick`处理程序以指示单击了哪个Square。以下是转换Board组件所需的步骤：(zh_CN)

- Delete the `constructor` in Board.
- 删除Board中的`constructor`。(zh_CN)
- Replace `this.state.squares[i]` with `this.props.squares[i]` in Board’s `renderSquare`.
- 将`this.state.squares [i]`替换为Board的`renderSquare`中的`this.props.squares [i]`。(zh_CN)
- Replace `this.handleClick(i)` with `this.props.onClick(i)` in Board’s `renderSquare`.
- 在Board的`renderSquare`中用`this.props.onClick（i）`替换`this.handleClick（i）`。(zh_CN)

The Board component now looks like this:
Board组件现在看起来像这样：(zh_CN)

    classBoardextendsReact.Component{handleClick(i){const squares =this.state.squares.slice();if(calculateWinner(squares)|| squares[i]){return;}
        squares[i]=this.state.xIsNext ?'X':'O';this.setState({
          squares: squares,
          正方形：正方形，(zh_CN)
          xIsNext:!this.state.xIsNext,});}renderSquare(i){return(<Squarevalue={this.props.squares[i]}onClick={()=>this.props.onClick(i)}/>);}render(){const winner =calculateWinner(this.state.squares);let status;if(winner){
          ！xIsNext：this.state.xIsNext，}）;} renderSquare（I）{返回（<Squarevalue = {this.props.squares [I]}的onClick = {（）=> this.props.onClick（I）} / >）;} render（）{const winner = calculateWinner（this.state.squares）; let status; if（winner）{(zh_CN)
          status ='Winner: '+ winner;}else{
          status ='获胜者：'+获胜者;}其他{(zh_CN)
          status ='Next player: '+(this.state.xIsNext ?'X':'O');}return(<div><divclassName="status">{status}</div><divclassName="board-row">{this.renderSquare(0)}{this.renderSquare(1)}{this.renderSquare(2)}</div><divclassName="board-row">{this.renderSquare(3)}{this.renderSquare(4)}{this.renderSquare(5)}</div><divclassName="board-row">{this.renderSquare(6)}{this.renderSquare(7)}{this.renderSquare(8)}</div></div>);}}
          status ='下一个玩家：'+（this.state.xIsNext？'X'：'O'）;} return（<div> <divclassName =“status”> {status} </ div> <divclassName =“board-行 “> {this.renderSquare（0）} {this.renderSquare（1）} {this.renderSquare（2）} </ DIV> <divclassName =” 板排“> {this.renderSquare（3）} {此.renderSquare（4）} {this.renderSquare（5）} </ DIV> <divclassName = “板排”> {this.renderSquare（6）} {this.renderSquare（7）} {this.renderSquare（8） } </ DIV> </ DIV>）;}}(zh_CN)

We’ll update the Game component’s `render` function to use the most recent history entry to determine and display the game’s status:
我们将更新Game组件的`render`函数，以使用最新的历史记录条目来确定和显示游戏的状态：(zh_CN)

    render(){const history =this.state.history;const current = history[history.length -1];const winner =calculateWinner(current.squares);let status;if(winner){      status ='Winner: '+ winner;}else{      status ='Next player: '+(this.state.xIsNext ?'X':'O');}return(<divclassName="game"><divclassName="game-board"><Boardsquares={current.squares}onClick={(i)=>this.handleClick(i)}/></div><divclassName="game-info"><div>{status}</div><ol>{}</ol></div></div>);}
    render（）{const history = this.state.history; const current = history [history.length -1]; const winner = calculateWinner（current.squares）; let status; if（winner）{status ='Winner：'+获胜者;} else {status ='下一位玩家：'+（this.state.xIsNext？'X'：'O'）;} return（<divclassName =“game”> <divclassName =“game-board”> <Boardsquares = {} current.squares的onClick = {（I）=> this.handleClick（I）} /> </ DIV> <divclassName = “游戏信息”> <DIV> {状态} </ DIV> <OL> { } </ OL> </ DIV> </ DIV>）;}(zh_CN)

Since the Game component is now rendering the game’s status, we can remove the corresponding code from the Board’s `render` method. After refactoring, the Board’s `render` function looks like this:
由于Game组件现在呈现游戏的状态，我们可以从Board的`render`方法中删除相应的代码。重构后，Board的`render`函数如下所示：(zh_CN)

    render(){return(<div><divclassName="board-row">{this.renderSquare(0)}{this.renderSquare(1)}{this.renderSquare(2)}</div><divclassName="board-row">{this.renderSquare(3)}{this.renderSquare(4)}{this.renderSquare(5)}</div><divclassName="board-row">{this.renderSquare(6)}{this.renderSquare(7)}{this.renderSquare(8)}</div></div>);}
    渲染（）{回报（<DIV> <divclassName = “板排”> {this.renderSquare（0）} {this.renderSquare（1）} {this.renderSquare（2）} </ DIV> <divclassName =”板排 “> {this.renderSquare（3）} {this.renderSquare（4）} {this.renderSquare（5）} </ DIV> <divclassName =” 板排“> {this.renderSquare（6）} {this.renderSquare（7）} {this.renderSquare（8）} </ DIV> </ DIV>）;}(zh_CN)

Finally, we need to move the `handleClick` method from the Board component to the Game component. We also need to modify `handleClick` because the Game component’s state is structured differently. Within the Game’s `handleClick` method, we concatenate new history entries onto `history`.
最后，我们需要将`handleClick`方法从Board组件移动到Game组件。我们还需要修改`handleClick`，因为Game组件的状态结构不同。在Game的`handleClick`方法中，我们将新的历史条目连接到`history`。(zh_CN)

    handleClick(i){const history =this.state.history;const current = history[history.length -1];const squares = current.squares.slice();if(calculateWinner(squares)|| squares[i]){return;}
    handleClick（i）{const history = this.state.history; const current = history [history.length -1]; const squares = current.squares.slice（）; if（calculateWinner（squares）|| squares [i]） {返回;}(zh_CN)
        squares[i]=this.state.xIsNext ?'X':'O';this.setState({      history: history.concat([{        squares: squares,}]),      xIsNext:!this.state.xIsNext,});}

> Note
> 注意(zh_CN)
> 
> Unlike the array `push()` method you might be more familiar with, the `concat()` method doesn’t mutate the original array, so we prefer it.
> 与您可能更熟悉的数组`push（）`方法不同，`concat（）`方法不会改变原始数组，所以我们更喜欢它。(zh_CN)

At this point, the Board component only needs the `renderSquare` and `render` methods. The game’s state and the `handleClick` method should be in the Game component.
此时，Board组件只需要`renderSquare`和`render`方法。游戏的状态和`handleClick`方法应该在Game组件中。(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/EmmOqJ?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/EmmOqJ?editors=0010) **(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#showing-the-past-moves](https://reactjs.org/tutorial/tutorial.html#showing-the-past-moves)Showing the Past Moves

Since we are recording the tic-tac-toe game’s history, we can now display it to the player as a list of past moves.
由于我们正在记录井字游戏的历史，我们现在可以将其作为过去动作的列表显示给玩家。(zh_CN)

We learned earlier that React elements are first-class JavaScript objects; we can pass them around in our applications. To render multiple items in React, we can use an array of React elements.
我们之前了解到React元素是一流的JavaScript对象;我们可以在我们的应用程序中传递它们。要在React中呈现多个项目，我们可以使用React元素数组。(zh_CN)

In JavaScript, arrays have a [`map()` method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) that is commonly used for mapping data to other data, for example:
在JavaScript中，数组有一个[`map（）`方法]（https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map），它通常用于映射数据其他数据，例如：(zh_CN)

    const numbers =[1,2,3];const doubled = numbers.map(x => x *2);

Using the `map` method, we can map our history of moves to React elements representing buttons on the screen, and display a list of buttons to “jump” to past moves.
使用`map`方法，我们可以将我们的移动历史映射到表示屏幕上按钮的React元素，并显示一个按钮列表以“跳转”到过去的移动。(zh_CN)

Let’s `map` over the `history` in the Game’s `render` method:
让我们在游戏的`render`方法中对`history`进行`map`：(zh_CN)

    render(){const history =this.state.history;const current = history[history.length -1];const winner =calculateWinner(current.squares);const moves = history.map((step, move)=>{const desc = move ?'Go to move #'+ move :'Go to game start';return(<li><buttononClick={()=>this.jumpTo(move)}>{desc}</button></li>);});let status;if(winner){
    render（）{const history = this.state.history; const current = history [history.length -1]; const winner = calculateWinner（current.squares）; const moves = history.map（（step，move）=> { const desc = move？'去移动''+移动：'转到游戏开始';返回（<li> <buttononClick = {（）=> this.jumpTo（move）}> {desc} </ button> < / li>）;}）; let status; if（winner）{(zh_CN)
          status ='Winner: '+ winner;}else{
          status ='获胜者：'+获胜者;}其他{(zh_CN)
          status ='Next player: '+(this.state.xIsNext ?'X':'O');}return(<divclassName="game"><divclassName="game-board"><Boardsquares={current.squares}onClick={(i)=>this.handleClick(i)}/></div><divclassName="game-info"><div>{status}</div><ol>{moves}</ol></div></div>);}
          status ='下一个玩家：'+（this.state.xIsNext？'X'：'O'）;} return（<divclassName =“game”> <divclassName =“game-board”> <Boardsquares = {current.squares }的onClick = {（I）=> this.handleClick（I）} /> </ DIV> <divclassName = “游戏信息”> <DIV> {状态} </ DIV> <OL> {移动} </醇> </ DIV> </ DIV>）;}(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/EmmGEa?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/EmmGEa?editors=0010) **(zh_CN)

For each move in the tic-tac-toes’s game’s history, we create a list item `<li>` which contains a button `<button>`. The button has a `onClick` handler which calls a method called `this.jumpTo()`. We haven’t implemented the `jumpTo()` method yet. For now, we should see a list of the moves that have occurred in the game and a warning in the developer tools console that says:
对于tic-tac-toes游戏历史中的每一个动作，我们创建一个列表项`<li>`，其中包含一个按钮`<button>`。该按钮有一个`onClick`处理程序，它调用一个名为`this.jumpTo（）`的方法。我们还没有实现`jumpTo（）`方法。现在，我们应该看到游戏中发生的移动列表以及开发人员工具控制台中的警告：(zh_CN)

>  Warning:
>  警告：(zh_CN)
> Each child in an array or iterator should have a unique “key” prop. Check the render method of “Game”.
> 数组或迭代器中的每个子节点都应该具有唯一的“键”支柱。检查“游戏”的渲染方法。(zh_CN)

Let’s discuss what the above warning means.
让我们讨论上述警告的含义。(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#picking-a-key](https://reactjs.org/tutorial/tutorial.html#picking-a-key)Picking a Key

When we render a list, React stores some information about each rendered list item. When we update a list, React needs to determine what has changed. We could have added, removed, re-arranged, or updated the list’s items.
当我们渲染列表时，React存储有关每个渲染列表项的一些信息。当我们更新列表时，React需要确定已更改的内容。我们可以添加，删除，重新安排或更新列表的项目。(zh_CN)

Imagine transitioning from
想象一下过渡(zh_CN)

    <li>Alexa: 7 tasks left</li><li>Ben: 5 tasks left</li>
    <li> Alexa：剩下7个任务</ li> <li> Ben：剩下5个任务</ li>(zh_CN)

to

    <li>Ben: 9 tasks left</li><li>Claudia: 8 tasks left</li><li>Alexa: 5 tasks left</li>
    <li> Ben：剩下9个任务</ li> <li> Claudia：剩下8个任务</ li> <li> Alexa：剩下5个任务</ li>(zh_CN)

From our perspective, our transition swapped Alexa and Ben’s ordering and inserted Claudia between Alexa and Ben. However, React is a computer program and does not know what we intended. Because React cannot know our intentions, we need to specify a *key* property for each list item to differentiate each list item from its siblings. The strings `alexa`, `ben`, `claudia` may be used as keys. If we had access to a database, Alexa, Ben, and Claudia’s database IDs could be used as keys.
从我们的角度来看，我们的过渡交换了Alexa和Ben的订购，并将Alexa和Ben之间的Claudia插入。但是，React是一个计算机程序，不知道我们的意图。因为React无法知道我们的意图，我们需要为每个列表项指定一个* key *属性，以区分每个列表项和它的兄弟。字符串`alexa`，`ben`，`claudia`可以用作键。如果我们可以访问数据库，Alexa，Ben和Claudia的数据库ID可以用作密钥。(zh_CN)

    <likey={user.id}>{user.name}: {user.taskCount} tasks left</li>
    <likey = {user.id}> {user.name}：{user.taskCount}任务离开</ li>(zh_CN)

`key` is a special and reserved property in React (along with `ref`, a more advanced feature). When an element is created, React extracts the `key` property and stores the key directly on the returned element. Even though `key` may look like it belongs in `props`, `key` cannot be referenced using `this.props.key`. React automatically uses `key` to decide which components to update. A component cannot inquire about its `key`.
`key`是React中的一个特殊保留属性（与`ref`一起使用，是一个更高级的功能）。创建元素时，React将提取`key`属性并将该键直接存储在返回的元素上。尽管`key`可能看起来像属于`props`，但是`key`不能使用`this.props.key`引用。 React自动使用`key`来决定要更新的组件。组件无法查询其“密钥”。(zh_CN)

When a list is re-rendered, React takes each list item’s key and searches the previous list’s items for a matching key. If the current list has a key that does not exist in the previous list, React creates a component. If the current list is missing a key that exists in the previous list, React destroys a component. Keys tell React about the identity of each component which allows React to maintain state between re-renders. If a component’s key changes, the component will be destroyed and re-created with a new state.
重新呈现列表时，React会获取每个列表项的键，并在前一个列表的项目中搜索匹配的键。如果当前列表具有上一个列表中不存在的密钥，则React会创建一个组件。如果当前列表缺少上一个列表中存在的密钥，则React会破坏组件。密钥告诉React每个组件的身份，它允许React在重新渲染之间保持状态。如果组件的键发生更改，则组件将被销毁并使用新状态重新创建。(zh_CN)

**It’s strongly recommended that you assign proper keys whenever you build dynamic lists.** If you don’t have an appropriate key, you may want to consider restructuring your data so that you do.
**强烈建议您在构建动态列表时分配正确的密钥。**如果您没有合适的密钥，您可能需要考虑重构数据以便这样做。(zh_CN)

If no key is specified, React will present a warning and use the array index as a key by default. Using the array index as a key is problematic when trying to re-order a list’s items or inserting/removing list items. Explicitly passing `key={i}` silences the warning but has the same problems as array indices and is not recommended in most cases.
如果未指定任何键，则React将显示警告并默认使用数组索引作为键。尝试重新排序列表的项目或插入/删除列表项时，使用数组索引作为键是有问题的。显式传递`key = {i}`会使警告静音但与数组索引有相同的问题，在大多数情况下不推荐使用。(zh_CN)

Keys do not need to be globally unique. Keys only needs to be unique between components and their siblings.
密钥不需要全局唯一。键只需要在组件和它们的兄弟之间是唯一的。(zh_CN)

In the tic-tac-toe game’s history, each past move has a unique ID associated with it: it’s the sequential number of the move. The moves are never re-ordered, deleted, or inserted in the middle, so it’s safe to use the move index as a key.
在tic-tac-toe游戏的历史中，每个过去的移动都有一个与之相关的唯一ID：它是移动的连续编号。移动永远不会在中间重新排序，删除或插入，因此将移动索引用作键是安全的。(zh_CN)

In the Game component’s `render` method, we can add the key as `<li key={move}>` and React’s warning about keys should disappear:
在Game组件的`render`方法中，我们可以将键添加为`<li key = {move}>`，并且React关于键的警告应该消失：(zh_CN)

    const moves = history.map((step, move)=>{const desc = move ?'Go to move #'+ move :'Go to game start';return(<likey={move}><buttononClick={()=>this.jumpTo(move)}>{desc}</button></li>);});
    const moves = history.map（（step，move）=> {const desc = move？'去移动''+移动：'转到游戏开始';返回（<likey = {move}> <buttononClick = {（ ）=> this.jumpTo（移动）}> {递减} </按钮> </ LI>）;}）;(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/PmmXRE?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/PmmXRE?editors=0010) **(zh_CN)

Clicking any of the list item’s buttons throws an error because the `jumpTo` method is undefined. Before we implement `jumpTo`, we’ll add `stepNumber` to the Game component’s state to indicate which step we’re currently viewing.
单击任何列表项的按钮会引发错误，因为`jumpTo`方法未定义。在我们实现`jumpTo`之前，我们将`stepNumber`添加到Game组件的状态，以指示我们当前正在查看的步骤。(zh_CN)

First, add `stepNumber: 0` to the initial state in Game’s `constructor`:
首先，在Game的`constructor`中将`stepNumber：0`添加到初始状态：(zh_CN)

    classGameextendsReact.Component{constructor(props){super(props);this.state ={
          history:[{
          历史：[{(zh_CN)
            squares:Array(9).fill(null),}],      stepNumber:0,      xIsNext:true,};}

Next, we’ll define the `jumpTo` method in Game to update that `stepNumber`. We also set `xIsNext` to true if the number that we’re changing `stepNumber` to is even:
接下来，我们将在Game中定义`jumpTo`方法来更新`stepNumber`。如果我们将`stepNumber`改为的数字是偶数，我们也将`xIsNext`设置为true：(zh_CN)

    handleClick(i){}jumpTo(step){this.setState({      stepNumber: step,      xIsNext:(step %2)===0,});}render(){}

We will now make a few changes to the Game’s `handleClick` method which fires when you click on a square.
我们现在将对Game的`handleClick`方法进行一些更改，当您单击一个正方形时会触发该方法。(zh_CN)

The `stepNumber` state we’ve added reflects the move displayed to the user now. After we make a new move, we need to update `stepNumber` by adding `stepNumber: history.length` as part of the `this.setState` argument. This ensures we don’t get stuck showing the same move after a new one has been made.
我们添加的`stepNumber`状态反映了现在向用户显示的移动。在我们进行新的操作之后，我们需要通过添加`stepNumber：history.length`作为`this.setState`参数的一部分来更新`stepNumber`。这样可以确保我们不会在制作新动作后显示相同的动作。(zh_CN)

We will also replace reading `this.state.history` with `this.state.history.slice(0, this.state.stepNumber + 1)`. This ensures that if we “go back in time” and then make a new move from that point, we throw away all the “future” history that would now become incorrect.
我们还将用`this.state.history.slice（0，this.state.stepNumber + 1）`替换读取`this.state.history`。这确保了如果我们“回到过去”然后从那一点开始新的行动，我们就会抛弃现在变得不正确的所有“未来”历史。(zh_CN)

    handleClick(i){const history =this.state.history.slice(0,this.state.stepNumber +1);const current = history[history.length -1];const squares = current.squares.slice();if(calculateWinner(squares)|| squares[i]){return;}
        squares[i]=this.state.xIsNext ?'X':'O';this.setState({
          history: history.concat([{
            squares: squares
            正方形：正方形(zh_CN)
          }]),      stepNumber: history.length,      xIsNext:!this.state.xIsNext,});}

Finally, we will modify the Game component’s `render` method from always rendering the last move to rendering the currently selected move according to `stepNumber`:
最后，我们将修改Game组件的`render`方法，始终根据`stepNumber`呈现最后一次移动以呈现当前选定的移动：(zh_CN)

    render(){const history =this.state.history;const current = history[this.state.stepNumber];const winner =calculateWinner(current.squares);

If we click on any step in the game’s history, the tic-tac-toe board should immediately update to show what the board looked like after that step occurred.
如果我们点击游戏历史记录中的任何一个步骤，那么井字游戏板应该立即更新以显示该步骤发生后该板的样子。(zh_CN)

**[View the full code at this point](https://codepen.io/gaearon/pen/gWWZgR?editors=0010)**
**[此时查看完整代码]（https://codepen.io/gaearon/pen/gWWZgR?editors=0010) **(zh_CN)

### [https://reactjs.org/tutorial/tutorial.html#wrapping-up](https://reactjs.org/tutorial/tutorial.html#wrapping-up)Wrapping Up

Congratulations! You’ve created a tic-tac-toe game that:
恭喜！你创造了一个井字游戏：(zh_CN)

- Lets you play tic-tac-toe,
- 让你玩tic-tac-toe，(zh_CN)
- Indicates when a player has won the game,
- 表示玩家赢得比赛的时间，(zh_CN)
- Stores a game’s history as a game progresses,
- 随着游戏的进行存储游戏的历史，(zh_CN)
- Allows players to review a game’s history and see previous versions of a game’s board.
- 允许玩家查看游戏的历史记录并查看游戏主板的先前版本。(zh_CN)

Nice work! We hope you now feel like you have a decent grasp on how React works.
干得好！我们希望您现在感觉自己对React的工作方式有了很好的把握。(zh_CN)

Check out the final result here: **[Final Result](https://codepen.io/gaearon/pen/gWWZgR?editors=0010)**.
在这里查看最终结果：** [最终结果]（https://codepen.io/gaearon/pen/gWWZgR?editors=0010) **。(zh_CN)

If you have extra time or want to practice your new React skills, here are some ideas for improvements that you could make to the tic-tac-toe game which are listed in order of increasing difficulty:
如果你有额外的时间或想要练习你的新React技能，这里有一些你可以对tic-tac-toe游戏进行改进的想法，它们按照难度增加的顺序列出：(zh_CN)

1. Display the location for each move in the format (col, row) in the move history list.
1. 以移动历史记录列表中的格式（col，row）显示每个移动的位置。(zh_CN)
2. Bold the currently selected item in the move list.
2. 加粗移动列表中当前选定的项目。(zh_CN)
3. Rewrite Board to use two loops to make the squares instead of hardcoding them.
3. 重写Board使用两个循环来制作正方形而不是硬编码。(zh_CN)
4. Add a toggle button that lets you sort the moves in either ascending or descending order.
4. 添加切换按钮，可以按升序或降序对移动进行排序。(zh_CN)
5. When someone wins, highlight the three squares that caused the win.
5. 当有人获胜时，突出显示导致胜利的三个方格。(zh_CN)
6. When no one wins, display a message about the result being a draw.
6. 当没有人获胜时，显示关于结果为平局的消息。(zh_CN)

Throughout this tutorial, we touched on React concepts including elements, components, props, and state. For a more detailed explanation of each of these topics, check out [the rest of the documentation](https://reactjs.org/docs/hello-world.html). To learn more about defining components, check out the [`React.Component` API reference](https://reactjs.org/docs/react-component.html).
在本教程中，我们讨论了React概念，包括元素，组件，道具和状态。有关这些主题的更详细说明，请查看[文档的其余部分]（https://reactjs.org/docs/hello-world.html）。要了解有关定义组件的更多信息，请查看[`React.Component` API参考]（https://reactjs.org/docs/react-component.html）。(zh_CN)
  {% endraw %}
    