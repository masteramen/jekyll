---
layout: post
title:  "Android自定义万能Canvas画布"
title2:  "Android自定义万能Canvas画布"
date:   2017-01-01 23:56:20  +0800
source:  "http://www.jfox.info/android%e8%87%aa%e5%ae%9a%e4%b9%89%e4%b8%87%e8%83%bdcanvas%e7%94%bb%e5%b8%83.html"
fileName:  "20170101280"
lang:  "zh_CN"
published: true
permalink: "android%e8%87%aa%e5%ae%9a%e4%b9%89%e4%b8%87%e8%83%bdcanvas%e7%94%bb%e5%b8%83.html"
---
{% raw %}
分类：*android进阶的小步伐*

 （361） （2）

一、需求：

1.在自定义的画布中实现可缩放手势，摇一摇可对控件进行整理排序；

2.画布中可以添加位置设定的控件，控件可以响应点击、长按、拖动事件；

3.控件A长按事件会隐藏画布中的控件除了A之外，显示另一个控件B；当A在在底层画布中拖动，拖动结束之后回到原画布；当A移动B的位置范围响应操作（可以添加另方面功能）。

二、实现思想：

1、画布的的手势缩放、控件的添加，在我的[上一篇关于画布文章](http://www.jfox.info/go.php?url=http://blog.csdn.net/wangyongyao1989/article/details/74157556)中已经实现了这个功能，这里不再赘述；

2、要实现上述的几个功能只需要屏幕上添加两层画布，一层画布用于添加控件在这层中可以实现控件的点击、拖动、画布缩放、长按事件、整理排序控件。底层画布用于长按其他控件隐藏之后A控件的拖动和B控件的显示及A拖动到B之后的事件响应。

3、当A控件结束拖动（抬起时）回到第一层画布中。

三、效果展示：

四、具体实现：

1.先添加两层画布用布局可以RelativeLayout包裹着，如：

       <RelativeLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent">
            <com.view.ActionEditorCanvasView
                android:id="@+id/action_editor_canvas_gamepad_test"
                android:visibility="gone"
                android:layout_width="match_parent"
                android:layout_height="match_parent"/>
            <com.view.ActionEditorCanvasView
                android:id="@+id/action_editor_canvas_test"
                android:layout_width="match_parent"
                android:layout_height="match_parent"/>
        </RelativeLayout>

 2.当控件添加到画布中要获取到对应控件的位置信息（将添加的控件添加到一个集合中），判断点击时是否是落在控件之上，这些都是在view中的onTouchEvent(MotionEvent event)进行处理：   
 
     private int getDown2Widget() {
            for (int i = 0; i < mDrawableList.size(); i++) {
                int xcoords = mDrawableList.get(i).getXcoords();
                int ycoords = mDrawableList.get(i).getYcoords();
                double abs = Math.sqrt((DownX - xcoords) * (DownX - xcoords) + (DownY - ycoords) * (DownY - ycoords));
                //点落在控件内
                if (abs < ActionWidget.RADIUS) {
                    return i;
                }
            }
            return -1;
        }

 3、在画布中实现Move、LongPress、Up、Click的接口回调用于对外应用：   
 
        public onWidgetUpListener mOnWidgetUpListener;
        public interface onWidgetUpListener{
            void onWidgetUp(int index,int x,int y);
        }
    
        public void  setOnWidgetUpListener(onWidgetUpListener mOnWidgetUpListener){
            this.mOnWidgetUpListener=mOnWidgetUpListener;
        }
    
        public onWidgetMoveListener mOnWidgetMoveListener;
    
        public interface onWidgetMoveListener{
             void onWidgetMove(int index,int x,int y);
        }
    
        public void  setOnWidgetMoveListener(onWidgetMoveListener moveListener){
            this.mOnWidgetMoveListener=moveListener;
        }
    
        public onWidgetLongPressListener mOnWidgetLongPressListener;
    
        public interface onWidgetLongPressListener{
            void onWidgetLongPress(int index,int x,int y);
        }
    
        public void setOnWidgetLongPressListener(onWidgetLongPressListener mOnWidgetLongPressListener){
            this.mOnWidgetLongPressListener=mOnWidgetLongPressListener;
        }
    
    
        public onWidgetClickListener mOnWidgetClickListener;
    
        public interface onWidgetClickListener{
            void onWidgetClick(int index,int x,int y);
        }
    
        public void setOnWidgetClickListener(onWidgetClickListener mOnWidgetClickListener){
            this.mOnWidgetClickListener=mOnWidgetClickListener;
        }

 4.接下来就是处理拖动、点击、长按、抬起的事件的处理： 
 

     public boolean onTouchEvent(MotionEvent event) {       
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN: {
                    mDownTime = System.currentTimeMillis();
                    DownX = event.getX();//float DownX
                    DownY = event.getY();//float DownY
                    //判断点击的坐标范围是否在控件上
                    mDown2Widget = getDown2Widget();
                    moveX = 0;
                    moveY = 0;
                    moveX1 = 0;
                    moveY1 = 0;
                }
                break;
                case MotionEvent.ACTION_MOVE: {
                    moveX += Math.abs(event.getX() - DownX);//X轴距离
                    moveY += Math.abs(event.getY() - DownY);//y轴距离
                    moveX1 = event.getX();
                    moveY1 = event.getY();
                    if (moveX == 0 && moveY == 0) {
                        mMoveTime = System.currentTimeMillis();
                        long DValueTime = mMoveTime - mDownTime;//计算点击下去是否有移动及事件是否符合长按的时间值，这样可以判断是否是长按事件
                        if (DValueTime>200){
                            if (mOnWidgetLongPressListener!=null){
                                mOnWidgetLongPressListener.onWidgetLongPress(mDown2Widget,(int)moveX1,(int)moveY1);
                            }
                        }
                        return true;
                    } else {
                        if (mDown2Widget > -1) {
                            if (mOnWidgetMoveListener!=null){
                                mOnWidgetMoveListener.onWidgetMove(mDown2Widget,(int)moveX1,(int)moveY1);
                            }
                            mDrawableList.get(mDown2Widget).setXcoords((int) moveX1);//点击在控件之上进行的move则把控件坐标值重置，从而是实现控件拖动
                            mDrawableList.get(mDown2Widget).setYcoords((int) moveY1);
                            invalidate();
                        }
                    }
                    DownX = event.getX();
                    DownY = event.getY();
                }
                break;
                case MotionEvent.ACTION_UP: {
                    long moveTime = System.currentTimeMillis() - currentMS;//移动时间
                    mUpTime = System.currentTimeMillis();
                    long DValueTime = mUpTime - mDownTime;//判断从按下到抬起的实现，从而实现判断是否是点击
                    if (mDown2Widget > -1) {
                        //判断是否为拖动事件
                        if (!(moveTime > 1000 && (moveX > 100 || moveY > 100))) {
                            if (DValueTime < 200) {
                                if (mOnWidgetClickListener!=null){
                                    mOnWidgetClickListener.onWidgetClick(mDown2Widget,(int)moveX1,(int)moveY1);
                                }
                            }
                        }
                    }
                    if (mOnWidgetUpListener!=null){//判断是否是抬起事件
                        mOnWidgetUpListener.onWidgetUp(mDown2Widget,(int)moveX1,(int)moveY1);
                    }
                }
                break;
            }
            return true;
    
        }

 5、在底层画布添加控件B，并获取位置信息存起来：   
 
            mBitmap= BitmapFactory.decodeResource(getResources(),R.drawable.ic_launcher);
            mGamePadBitmap=new CBitmap(mBitmap,200,1000);
            mXcoords = mGamePadBitmap.getXcoords();
            mYcoords = mGamePadBitmap.getYcoords();
            mGamePadCanvasView.addCanvasDrawable(mGamePadBitmap);

 6、处理长按事件，隐藏第一层画布显示底层画布，并获取A控件位置在底层画布中画出来：   
 
           mCanvasView.setOnWidgetLongPressListener(new ActionEditorCanvasView.onWidgetLongPressListener() {
                @Override
                public void onWidgetLongPress(int index, int x, int y) {
                    ActionWidget actionWidget = (ActionWidget) mCanvasView.mDrawableList.get(index);
                    mCanvasView.setV
{% endraw %}
