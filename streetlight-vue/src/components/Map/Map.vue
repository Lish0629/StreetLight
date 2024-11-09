<template>
  <div>
    <!-- 切换按钮 -->
    <button @click="toggleStyle" style="position: absolute; z-index: 10; top: 10px; left: 10px; padding: 10px; background-color: white; border-radius: 5px;">
      {{ showAll ? '显示只包含 false 的要素' : '显示全部要素' }}
    </button>
    <div id="map"></div>
  </div>
</template>

<script setup>
import "ol/ol.css";
import axios from 'axios';
import Map from 'ol/Map.js';
import View from 'ol/View.js'
import { fromLonLat } from 'ol/proj';
import { onMounted,ref } from 'vue';
//import { markLayer,tileLayer,imgLayer,lantern } from "@/data/layers";
import { markLayer, tileLayer, imgLayer, createLanternLayer } from "@/data/layers";
let map;
let lanternLayer = null;
const showAll = ref(true); // 初始状态为显示全部
const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer,createLanternLayer(true)],
    view:new View({
      center:fromLonLat([119.725,30.259]),
      zoom:16.5,
      minZoom:15,
      maxZoom:18.5
    }),
    
  });
}

// 切换样式
const toggleStyle = () => {
  showAll.value = !showAll.value; // 切换状态
    // 先移除现有的图层
    if (lanternLayer) {
    map.removeLayer(lanternLayer);
  }

  // 创建新的图层并添加

  lanternLayer = createLanternLayer(showAll.value); // 重新生成图层
  map.addLayer(lanternLayer); // 更新地图上的图层
};

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