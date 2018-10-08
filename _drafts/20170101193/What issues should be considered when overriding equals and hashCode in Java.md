---
layout: post
title:  "What issues should be considered when overriding equals and hashCode in Java?"
title2:  "What issues should be considered when overriding equals and hashCode in Java"
date:   2017-01-01 23:54:53  +0800
source:  "http://www.jfox.info/whatissuesshouldbeconsideredwhenoverridingequalsandhashcodeinjava.html"
fileName:  "20170101193"
lang:  "zh_CN"
published: true
permalink: "whatissuesshouldbeconsideredwhenoverridingequalsandhashcodeinjava.html"
---
{% raw %}
### The theory (for the language lawyers and the mathematically inclined):

`equals()` ([javadoc](http://www.jfox.info/go.php?url=http://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#equals(java.lang.Object))) must define an equivalence relation (it must be *reflexive*, *symmetric*, and *transitive*). In addition, it must be *consistent* (if the objects are not modified, then it must keep returning the same value). Furthermore, `o.equals(null)` must always return false.

`hashCode()` ([javadoc](http://www.jfox.info/go.php?url=http://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#hashCode())) must also be *consistent* (if the object is not modified in terms of `equals()`, it must keep returning the same value).

The **relation** between the two methods is:

*Whenever `a.equals(b)`, then `a.hashCode()` must be same as `b.hashCode()`.*

### In practice:

If you override one, then you should override the other.

Use the same set of fields that you use to compute `equals()` to compute `hashCode()`.

Use the excellent helper classes [EqualsBuilder](http://www.jfox.info/go.php?url=http://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/builder/EqualsBuilder.html) and [HashCodeBuilder](http://www.jfox.info/go.php?url=http://commons.apache.org/proper/commons-lang/apidocs/org/apache/commons/lang3/builder/HashCodeBuilder.html) from the [Apache Commons Lang](http://www.jfox.info/go.php?url=http://commons.apache.org/lang/) library. An example:

    public class Person {
        private String name;
        private int age;
        // ...
    
        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31). // two randomly chosen prime numbers
                // if deriving: appendSuper(super.hashCode()).
                append(name).
                append(age).
                toHashCode();
        }
    
        @Override
        public boolean equals(Object obj) {
           if (!(obj instanceof Person))
                return false;
            if (obj == this)
                return true;
    
            Person rhs = (Person) obj;
            return new EqualsBuilder().
                // if deriving: appendSuper(super.equals(obj)).
                append(name, rhs.name).
                append(age, rhs.age).
                isEquals();
        }
    }
    

### Also remember:

When using a hash-based [Collection](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/Collection.html) or [Map](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/Map.html) such as [HashSet](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/HashSet.html), [LinkedHashSet](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/LinkedHashSet.html), [HashMap](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/HashMap.html), [Hashtable](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/Hashtable.html), or [WeakHashMap](http://www.jfox.info/go.php?url=http://download.oracle.com/javase/1.4.2/docs/api/java/util/WeakHashMap.html), make sure that the hashCode() of the key objects that you put into the collection never changes while the object is in the collection. The bulletproof way to ensure this is to make your keys immutable, [which has also other benefits](http://www.jfox.info/go.php?url=http://www.javapractices.com/topic/TopicAction.do?Id=29).
{% endraw %}