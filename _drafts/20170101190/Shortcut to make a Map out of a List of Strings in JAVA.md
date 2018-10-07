---
layout: post
title:  "Shortcut to make a Map out of a List of Strings in JAVA"
title2:  "Shortcut to make a Map out of a List of Strings in JAVA"
date:   2017-01-01 23:54:50  +0800
source:  "http://www.jfox.info/shortcuttomakeamapoutofalistofstringsinjava.html"
fileName:  "20170101190"
lang:  "zh_CN"
published: true
permalink: "shortcuttomakeamapoutofalistofstringsinjava.html"
---
{% raw %}
Yes. You can also use [`Arrays.asList(T...)`](http://www.jfox.info/go.php?url=https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#asList-T...-) to create your `List`. Then use a `Stream` to [collect](http://www.jfox.info/go.php?url=https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collectors.html) this with `Boolean.TRUE` like

    List<String> list = Arrays.asList("ab", "bc", "cd");
    Map<String, Boolean> alphaToBoolMap = list.stream()
            .collect(Collectors.toMap(Function.identity(), (a) -> Boolean.TRUE));
    System.out.println(alphaToBoolMap);
    

Outputs

    {cd=true, bc=true, ab=true}
    

For the sake of completeness, we should also consider an example where some values should be `false`. Maybe an empty key like

    List<String> list = Arrays.asList("ab", "bc", "cd", "");
    
    Map<String, Boolean> alphaToBoolMap = list.stream().collect(Collectors //
            .toMap(Function.identity(), (a) -> {
                return !(a == null || a.isEmpty());
            }));
    System.out.println(alphaToBoolMap);
    

Which outputs

    {=false, cd=true, bc=true, ab=true}
{% endraw %}
