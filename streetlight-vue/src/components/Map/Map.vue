<template>
  <div id="map"></div>
</template>

<script setup>
import "ol/ol.css";
import axios from 'axios';
import Map from 'ol/Map.js';
import View from 'ol/View.js'
import { fromLonLat } from 'ol/proj';
import { onMounted } from 'vue';
import { markLayer,tileLayer,imgLayer,lantern } from "@/data/layers";

var map;
const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer,lantern],
    view:new View({
      center:fromLonLat([119.725,30.259]),
      zoom:16.5,
      minZoom:15,
      maxZoom:18.5
    }),
    
  });
}
//Geojson测试函数
const contest=async ()=>{
  const url ='http://localhost:8081/geoserver/streetlight/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=streetlight:lantern&outputFormat=application/json'
  // 使用 axios 发送 GET 请求，并等待响应
  const response = await axios.get(url);
  // 输出 JSON 数据到控制台
  console.log(response.data);
  console.log(lantern);
}
onMounted(()=>{
  initMap();
  //contest();
})
</script>

<style lang="scss">
#map {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  height:100%;
  width:100%;
}
.blacktile {
  filter:  grayscale(40%) invert(80%) contrast(120%) brightness(1.5); /* 矢量图层暗黑模式 */
}
.blackmark{
  filter:  grayscale(40%) invert(80%) brightness(1.2);
}
</style>