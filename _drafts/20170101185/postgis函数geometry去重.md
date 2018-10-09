---
layout: post
title:  "postgis函数geometry去重"
title2:  "postgis函数geometry去重"
date:   2017-01-01 23:54:45  +0800
source:  "https://www.jfox.info/postgis%e5%87%bd%e6%95%b0geometry%e5%8e%bb%e9%87%8d.html"
fileName:  "20170101185"
lang:  "zh_CN"
published: true
permalink: "2017/postgis%e5%87%bd%e6%95%b0geometry%e5%8e%bb%e9%87%8d.html"
---
{% raw %}
postgis中多边形相交去重：

    create or replace function difference(geom1 geometry , geom2 geometry ) returns geometry as
    $$
    declare
    
    begin
    	if st_intersects(geom1 , geom2) then
    		return st_difference(geom1 , geom2);
    	else
    		return geom1 ;
    	end if;
    
    
    end;
    $$
    language plpgsql ;

该函数判断第二个参数和第一个参数是否有重合，有重合的话以第一个参数为模板去掉重合部分，没有重合则返回第一个参数。

postgis，根据两个经纬度返回矩形：

    create or replace function points_to_polygon(lon1 numeric , lat1 numeric , lon2 numeric , lat2 numeric ) returns geometry as
    $$
    
    	select  st_geomfromtext('POLYGON((' || lon1  || ' ' || lat1
    		|| ',' || lon2  || ' ' || lat1
    		|| ',' || lon2  || ' ' || lat2
    		|| ',' || lon1  || ' ' || lat2
    		|| ',' || lon1  || ' ' || lat1  || '))' , 4326);
    
    $$
    language sql immutable ;
{% endraw %}
