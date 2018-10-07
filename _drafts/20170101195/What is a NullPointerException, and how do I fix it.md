---
layout: post
title:  "What is a NullPointerException, and how do I fix it?"
title2:  "What is a NullPointerException, and how do I fix it"
date:   2017-01-01 23:54:55  +0800
source:  "http://www.jfox.info/whatisanullpointerexceptionandhowdoifixit.html"
fileName:  "20170101195"
lang:  "zh_CN"
published: true
permalink: "whatisanullpointerexceptionandhowdoifixit.html"
---
{% raw %}
When you declare a reference variable (i.e. an object) you are really creating a pointer to an object. Consider the following code where you declare a variable of primitive type `int`:

    int x;
    x = 10;
    

In this example the variable x is an `int` and Java will initialize it to 0 for you. When you assign it to 10 in the second line your value 10 is written into the memory location pointed to by x.

But, when you try to declare a reference type something different happens. Take the following code:

    Integer num;
    num = new Integer(10);
    

The first line declares a variable named `num`, but, it does not contain a primitive value. Instead it contains a pointer (because the type is `Integer` which is a reference type). Since you did not say as yet what to point to Java sets it to null, meaning “I am pointing at nothing”.

In the second line, the `new` keyword is used to instantiate (or create) an object of type Integer and the pointer variable num is assigned this object. You can now reference the object using the dereferencing operator `.` (a dot). 

The `Exception` that you asked about occurs when you declare a variable but did not create an object. If you attempt to dereference `num` BEFORE creating the object you get a `NullPointerException`. In the most trivial cases the compiler will catch the problem and let you know that “num may not have been initialized” but sometimes you write code that does not directly create the object.

For instance you may have a method as follows:

    public void doSomething(SomeObject obj){
       //do something to obj
    }
    

in which case you are not creating the object `obj`, rather assuming that is was created before the `doSomething` method was called. Unfortunately it is possible to call the method like this:

    doSomething(null);
    

in which case `obj` is null. If the method is intended to do something to the passed-in object, it is appropriate to throw the `NullPointerException` because it’s a programmer error and the programmer will need that information for debugging purposes.

Alternatively, there may be cases where the purpose of the method is not solely to operate on the passed in object, and therefore a null parameter may be acceptable. In this case, you would need to check for a null parameter and behave differently. You should also explain this in the documentation. For example, `doSomething` could be written as:

    /**
      * @param obj An optional foo for ____. May be null, in which case 
      *  the result will be ____. */
    public void doSomething(SomeObject obj){
        if(obj != null){
           //do something
        } else {
           //do something else
        }
    }
    

Finally, [How to pinpoint the exception location & cause using Stack Trace](http://www.jfox.info/go.php?url=https://stackoverflow.com/q/3988788/2775450)
{% endraw %}
