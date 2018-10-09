---
layout: post
title:  "JDK 1.8之 HashMap 源码分析"
title2:  "JDK 1.8之 HashMap 源码分析"
date:   2017-01-01 23:58:00  +0800
source:  "https://www.jfox.info/jdk18%e4%b9%8bhashmap%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90.html"
fileName:  "20170101380"
lang:  "zh_CN"
published: true
permalink: "2017/jdk18%e4%b9%8bhashmap%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90.html"
---
{% raw %}
与JDK1.7中HashMap的实现相比，JDK1.8做了如下改动：

- 
hash()函数算法修改

- 
 table数组的类型，由 **Entry** 改成了 **Node**

- 
 HashMap存储数据的结构由 **数组+链表** ，进化成了 **数组+链表+（RBT）红黑树**

![](/wp-content/uploads/2017/07/1500648034.png)

（图片转自网络）

重点关注与1.7中实现不同的地方！

### 构造函数

    public HashMap(int initialCapacity, float loadFactor) {
            if (initialCapacity < 0)
                throw new IllegalArgumentException("Illegal initial capacity: " +
                                                   initialCapacity);
            if (initialCapacity > MAXIMUM_CAPACITY)
                initialCapacity = MAXIMUM_CAPACITY;
            if (loadFactor <= 0 || Float.isNaN(loadFactor))
                throw new IllegalArgumentException("Illegal load factor: " +
                                                   loadFactor);
            this.loadFactor = loadFactor;
            this.threshold = tableSizeFor(initialCapacity); // 初始化阈值
        }

    /**
         * 根据容量计算阈值（临界值）
         */
        static final int tableSizeFor(int cap) {
            int n = cap - 1;
            n |= n >>> 1;
            n |= n >>> 2;
            n |= n >>> 4;
            n |= n >>> 8;
            n |= n >>> 16;
            return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
        }

### Node

    // 与1.7中 Entry的内容大同小异，只是换了个名称而已！
        static class Node<K,V> implements Map.Entry<K,V> {
            final int hash;
            final K key;
            V value;
            Node<K,V> next; // 指向下一个节点
    
            Node(int hash, K key, V value, Node<K,V> next) {
                this.hash = hash;
                this.key = key;
                this.value = value;
                this.next = next;
            }
    
            public final K getKey()        { return key; }
            public final V getValue()      { return value; }
            public final String toString() { return key + "=" + value; }
    
            public final int hashCode() {
                return Objects.hashCode(key) ^ Objects.hashCode(value);
            }
    
            public final V setValue(V newValue) {
                V oldValue = value;
                value = newValue;
                return oldValue;
            }
    
            public final boolean equals(Object o) {
                if (o == this)
                    return true;
                if (o instanceof Map.Entry) {
                    Map.Entry<?,?> e = (Map.Entry<?,?>)o;
                    if (Objects.equals(key, e.getKey()) &&
                        Objects.equals(value, e.getValue()))
                        return true;
                }
                return false;
            }
        }

### hash

相比JDK1.7中的hash()函数，1.8做了简化！

    static final int hash(Object key) {
            int h;
            return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
        }

如果key是null，则返回0

如果key不是null，则得到key的hashCode值，右移16位之后，做异或运算！

### put

    // 这个常量的意思就是，当一个bucket是一个链表，链表个数大于等于8时，就要树状化，也就是要从链表结构变成红黑树结构
    static final int TREEIFY_THRESHOLD = 8;

先来看看put()的实现

    // 如果已经存在key对应的节点，则覆盖value值
        public V put(K key, V value) {
            return putVal(hash(key), key, value, false, true);
        }

    // 如果已经存在key对应的节点，不覆盖value值
        @Override
        public V putIfAbsent(K key, V value) {
            return putVal(hash(key), key, value, true, true);
        }

 重点来看 **putVal()** 函数！ 

    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                       boolean evict) {
            Node<K,V>[] tab; Node<K,V> p; int n, i;
            if ((tab = table) == null || (n = tab.length) == 0) // 如果map为空时，调用resize()进行初始化！
                n = (tab = resize()).length;
            if ((p = tab[i = (n - 1) & hash]) == null) // 如果没有在数组中找到对应的节点，则直接插入一个Node (未发生碰撞)
                tab[i] = newNode(hash, key, value, null);
            else {     // 找到了(n - 1) & hash 对应下标的数组（tab）中的节点 ,也就是发生了碰撞
                Node<K,V> e; K k;
    
                // 1. hash值一样，key值一样，则找到目标Node
                if (p.hash == hash &&
                    ((k = p.key) == key || (key != null && key.equals(k))))
    
                // 2. 数组中找到的这个节点p是TreeNode类型，则需要插入到RBT里面一个节点
                else if (p instanceof TreeNode)
                    e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
                else {
    
                // 3. 不是TreeNode类型，则表示是一个链表，这里就类似与jdk1.7中的操作
                    for (int binCount = 0; ; ++binCount) { // 遍历链表
                        if ((e = p.next) == null) {
    
                            // 4. 此时查找当前链表的次数已经超过7个，则需要链表RBT化！
    
                            if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                                treeifyBin(tab, hash);
                            break;
                        }
                        if (e.hash == hash &&
                            ((k = e.key) == key || (key != null && key.equals(k)))) // 5. 找到链表中对应的节点
                            break;
                        p = e;
                    }
                }
                // 如果e不为空，则表示在HashMap中找到了对应的节点
                if (e != null) { // existing mapping for key
                    V oldValue = e.value;
                    // 当onlyIfAbsent=false 或者key对应的旧value为空时，用新的value替换旧value
                    if (!onlyIfAbsent || oldValue == null)
                        e.value = value;
                    afterNodeAccess(e);
                    return oldValue;
                }
            }
            ++modCount; // 操作次数+1
            if (++size > threshold) // hashmap节点个数+1，并判断是否超过阈值，如果超过则重建结构！
                resize();
            afterNodeInsertion(evict);
            return null;
        }

下面主要关注是三个函数：

- 
putTreeVal(this, tab, hash, key, value);

- 
treeifyBin(tab, hash);

- 
resize();

putTreeVal() 函数的目的就是往RBT中插入一个节点，但是牵涉到平衡化的方法，所以相对来讲难一些！

### treeifyBin
{% endraw %}
