---
layout: post
title:  "什么是 ROC AUC"
title2:  "什么是 ROC AUC"
date:   2017-01-01 23:52:37  +0800
source:  "http://www.jfox.info/%e4%bb%80%e4%b9%88%e6%98%afrocauc.html"
fileName:  "20170101057"
lang:  "zh_CN"
published: true
permalink: "%e4%bb%80%e4%b9%88%e6%98%afrocauc.html"
---
{% raw %}
ROC 曲线和 AUC 常被用来评价一个二值分类器的优劣。

先来看一下混淆矩阵中的各个元素，在后面会用到：

![](/wp-content/uploads/2017/07/1499179104.png)

**1. ROC ：**

纵轴为 TPR 真正例率，预测为正且实际为正的样本占所有正例样本的比例。 
横轴为 FPR 假正例率，预测为正但实际为负的样本占所有负例样本的比例。

![](/wp-content/uploads/2017/07/14991791041.png)

对角线对应的是 “随机猜想” 
![](/wp-content/uploads/2017/07/14991791042.png)

当一个学习器的 ROC 曲线被另一个学习器的包住，那么后者性能优于前者。 
有交叉时，需要用 AUC 进行比较。

**2. 先看图中的四个点和对角线：**

- 第一个点，(0,1)，即 FPR=0, TPR=1，这意味着 FN（false negative）=0，并且FP（false positive）=0。这意味着分类器很完美，因为它将所有的样本都正确分类。
- 第二个点，(1,0)，即 FPR=1，TPR=0，这个分类器是最糟糕的，因为它成功避开了所有的正确答案。
- 第三个点，(0,0)，即 FPR=TPR=0，即 FP（false positive）=TP（true positive）=0，此时分类器将所有的样本都预测为负样本（negative）。
- 第四个点（1,1），分类器将所有的样本都预测为正样本。
- 对角线上的点表示分类器将一半的样本猜测为正样本，另外一半的样本猜测为负样本。

因此，ROC 曲线越接近左上角，分类器的性能越好。

**3. 如何画 ROC 曲线**

例如有如下 20 个样本数据，Class 为真实分类，Score 为分类器预测此样本为正例的概率。 
![](/wp-content/uploads/2017/07/1499179105.png)

- 按 Score 从大到小排列
- 依次将每个 Score 设定为阈值，然后这 20 个样本的标签会变化，当它的 score 大于或等于当前阈值时，则为正样本，否则为负样本。
- 这样对每个阈值，可以计算一组 FPR 和 TPR，此例一共可以得到 20 组。
- 当阈值设置为 1 和 0 时， 可以得到 ROC 曲线上的 (0,0) 和 (1,1) 两个点。

![](/wp-content/uploads/2017/07/14991791051.png)

**4. 代码：**

输入 y 的�
{% endraw %}
