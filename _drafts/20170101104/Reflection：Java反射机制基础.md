---
layout: post
title:  "Reflection：Java反射机制基础"
title2:  "Reflection：Java反射机制基础"
date:   2017-01-01 23:53:24  +0800
source:  "https://www.jfox.info/reflectionjava%e5%8f%8d%e5%b0%84%e6%9c%ba%e5%88%b6%e5%9f%ba%e7%a1%80.html"
fileName:  "20170101104"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/reflectionjava%e5%8f%8d%e5%b0%84%e6%9c%ba%e5%88%b6%e5%9f%ba%e7%a1%80.html"
---
{% raw %}
反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性；这种动态获取的信息以及动态调用对象的方法的功能称为java语言的反射机制

### 反射机制能做什么

反射机制主要提供了以下功能：

- 
在运行时判断任意一个对象所属的类

- 
在运行时构造任意一个类的对象

- 
在运行时判断任意一个类所具有的成员变量和方法

- 
在运行时调用任意一个对象的方法

- 
生成动态代理

### 反射机制的相关API

#### 通过一个对象获得完整的包名和类名

        @Test
        public void getReflectionName() {
            String str = new String();
            System.out.println(str.getClass().getName()); // java.lang.String
            System.out.println(str.getClass().getSimpleName()); // String
        }
    

#### 实例化Class类对象(三种方式)

        @Test
        public void getInitClazz() {
    
            try {
                // 方式一：
                Class<?> clazz_1 = Class.forName("java.lang.String");
                // 方式二：
                Class<?> clazz_2 = new String().getClass();
                // 方式三：
                Class<?> clazz_3 = String.class;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

#### 获取一个对象的父类与实现的接口

        @Test
        public void getParentAndIntefaces() {
    
            try {
                Class<?> clazz = Class.forName("java.lang.String");
                // 取得父类
                Class<?> parentClass = clazz.getSuperclass();
                System.out.println("clazz的父类为：" + parentClass.getName());// clazz的父类为： java.lang.Object
                
                // 获取所有的接口
                Class<?> intes[] = clazz.getInterfaces();
                System.out.println("clazz实现的接口有：");
                for (int i = 0; i < intes.length; i++) {
                    System.out.println((i + 1) + "：" + intes[i].getName());
                }
    
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

#### 通过反射获取属性

        @Test
        public void getFieldsByReflect() {
    
            try {
                    Class<?> clazz = String.class ;
                    // 取得本类的全部属性
                    Field[] declaredFields = clazz.getDeclaredFields(); 
                    // 取得实现的接口或者父类的属性
                    Field[] fields = clazz.getFields();
                    
                    //遍历本类属性
                    for (Field field : declaredFields) {
                        // 权限修饰符
                        int mo = field.getModifiers();
                        String priv = Modifier.toString(mo);
                        // 属性类型
                        Class<?> type = field.getType();
                        System.out.println(priv + " " + type.getName() + " " + field.getName() + ";");
                    }
                    
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

#### 通过反射获取方法函数

        @Test
        public void getMethodsByReflect() {
    
            try {
                Class<?> clazz = String.class ;
                // 类的所有公用（public）方法包括其继承类的公用方法，当然也包括它所实现接口的方法
                Method[] methods = clazz.getMethods();
                // 类或接口声明的所有方法，包括公共、保护、默认（包）访问和私有方法，但不包括继承的方法。当然也包括它所实现接口的方法
                Method[] declaredMethods = clazz.getDeclaredMethods();
                
                //遍历本类属性
                for (Method method : methods) {
                    // 权限修饰符
                    int mo = method.getModifiers();
                    String priv = Modifier.toString(mo);
                    //返回值
                    Class<?> returnType = method.getReturnType();
                    //方法名
                    String methodName = method.getName();
                    //方法参数类型
                    Class<?>[] parameterTypes = method.getParameterTypes();
                    //抛出的异常
                    Class<?>[] exceptionTypes = method.getExceptionTypes();
                }
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        }

#### 通过反射获取构造方法

        @Test
        public void getConstructorsByReflect() {
    
            try {
                Class<?> clazz = Class.forName("java.lang.String");
                
                //获取构造方法
                Constructor<?>[] constructors = clazz.getConstructors();
                for (Constructor constructor : constructors) {
                    
                    //获取构造方法的参数
                    Class[] parameterTypes = constructor.getParameterTypes();
                    for (Class clazzType : parameterTypes) {
                        System.out.print(clazzType.getSimpleName() + "   ");
                    }
                    System.out.println();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

#### 通过反射机制设置属性

        @Test
        public void oprFieldsByReflect() {
    
            try {
                
                Class<?> clazz = Class.forName("java.lang.String");
                //实例化对象
                String str = new String("String");
                //可以直接对 private 的属性赋值
                Field field = clazz.getDeclaredField("hash");
                //改变属性
                field.setAccessible(true);
                //调用映射属性
                field.set(str, 0);
                
                System.out.println(field.get(str));
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

#### 通过反射机制调用方法

        @Test
        public void oprMethodsByReflect() {
    
            try {
                Class<?> clazz = Class.forName("java.lang.String");
                //实例化一个对象
                String str = new String("String");
                //反射出一个方法
                Method method =  clazz.getMethod("startsWith", String.class);
                //调用映射方法
                Object result = method.invoke(str, "Str");
                
                System.out.println(result);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

### 实例应用

#### 在泛型为Integer的ArrayList中存放一个String类型的对象

        /**
         * 在泛型为Integer的ArrayList中存放一个String类型的对象
         * @throws Exception
         */
        @Test
        public void test() throws Exception {
               ArrayList<Integer> list = new ArrayList<Integer>();
                Method method = list.getClass().getMethod("add", Object.class);
                method.invoke(list, "Java反射机制实例");
                System.out.println(list.get(0));
        }

#### 通过反射取得并修改数组的信息

        /**
         * 通过反射取得并修改数组的信息
         * 
         * @throws Exception
         */
        @Test
        public void test() throws Exception {
            int[] temp = { 1, 2, 3, 4, 5 };
            Class<?> demo = temp.getClass().getComponentType();
            
            System.out.println("数组类型： " + demo.getName());
            
            System.out.println("数组长度  " + Array.getLength(temp));
            
            System.out.println("数组的第一个元素: " + Array.get(temp, 0));
            
            Array.set(temp, 0, 100);
            System.out.println("修改之后数组第一个元素为： " + Array.get(temp, 0));
        }

#### 通过反射机制修改数组的大小

       /**
         * 通过反射机制修改数组的大小
         * 
         * @throws Exception
         */
        @Test
        public void test() throws Exception {
    
            int[] temp = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
            int[] newTemp = (int[]) arrayInc(temp, 15);
            print(newTemp);
            String[] atr = { "a", "b", "c" };
            String[] str1 = (String[]) arrayInc(atr, 8);
            print(str1);
        }
    
        // 修改数组大小
        private static Object arrayInc(Object obj, int len) {
            Class<?> arr = obj.getClass().getComponentType();
            Object newArr = Array.newInstance(arr, len);
            int co = Array.getLength(obj);
            System.arraycopy(obj, 0, newArr, 0, co);
            return newArr;
        }
    
        // 打印
        private static void print(Object obj) {
            Class<?> c = obj.getClass();
            if (!c.isArray()) {
                return;
            }
            System.out.println("数组长度为： " + Array.getLength(obj));
            for (int i = 0; i < Array.getLength(obj); i++) {
                System.out.print(Array.get(obj, i) + " ");
            }
            System.out.println();
        }
{% endraw %}
