---
layout: post
title:  "LeetCode & Q26-Remove Duplicates from Sorted Array-Easy"
title2:  "LeetCode & Q26-Remove Duplicates from Sorted Array-Easy"
date:   2017-01-01 23:54:44  +0800
source:  "https://www.jfox.info/leetcodeq26removeduplicatesfromsortedarrayeasy.html"
fileName:  "20170101184"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/leetcodeq26removeduplicatesfromsortedarrayeasy.html"
---
{% raw %}
Given a sorted array, remove the duplicates in place such that each element appear only *once* and return the new length.

Do not allocate extra space for another array, you must do this in place with constant memory.For example,

Given input array *nums* = `[1,1,2]`,

Your function should return length = `2`, with the first two elements of *nums* being `1` and `2` respectively. It doesn’t matter what you leave beyond the new length.

我写的一直有问题…用了HashSet集合，没有研究过这个类型，[1,1,2]输出结果一直是[1,1]

（在小本本上记下，要研究HashSet）

    import java.util.HashSet;import java.util.Set;publicclass Solution {
    
        publicstaticintremoveDuplicates(int[] nums) {
    
            Set<Integer> tempSet = new HashSet<>();
    
            for(int i = 0; i < nums.length; i++) {
    
                Integer wrap = Integer.valueOf(nums[i]);
    
                tempSet.add(wrap);
    
            }
    
            return tempSet.size();
    
        }
    
    }

下面是优秀答案

Solutions:

    publicclass Solution {
    
        publicstaticintremoveDuplicates(int[] nums) {
    
            int j = 0;
    
            for(int i = 0; i < nums.length; i++) {
    
                if(nums[i] != nums[j]) {
    
                    nums[++j] = nums[i];
    
                }
    
            }
    
            return ++j;
    
        }
    
    }

有两个点需要注意：

1. 因为重复的可能有多个，所以不能以相等来做判定条件
2. 注意`j++`和`++j`的区别，此处用法很巧妙，也很必要！
{% endraw %}
