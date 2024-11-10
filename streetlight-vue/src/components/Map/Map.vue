<template>
  <div>
    <div id="map"></div>
  </div>
</template>

<script setup>
import "ol/ol.css";
import axios from 'axios';
import Map from 'ol/Map.js';
import View from 'ol/View.js'
import { fromLonLat } from 'ol/proj';
import { onMounted,ref,watch } from 'vue';
import { markLayer, tileLayer, imgLayer, getStyleFunction,lanternLayer } from "@/data/layers";

let map;
// 初始状态为显示全部
const showAll = ref(true);
const props = defineProps({
  options:{
    showAll:true
  }
})

const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer,lanternLayer],
    view:new View({
      center:fromLonLat([119.725,30.259]),
      zoom:16.5,
      minZoom:15,
      maxZoom:18.5
    }),
    
  });
}

// 切换lantern样式
const toggleStyle = () => {
  showAll.value = !showAll.value; // 切换状态
  console.log(showAll.value);
  lanternLayer.setStyle(getStyleFunction(showAll)); // 更新样式
};

//Geojson测试函数
const contest=async ()=>{
  const url ='http://localhost:8081/geoserver/streetlight/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=streetlight:lantern&outputFormat=application/json'
  // 使用 axios 发送 GET 请求，并等待响应
  const response = await axios.get(url);
  // 输出 JSON 数据到控制台
  console.log(response.data);
};


onMounted(()=>{
  initMap();

});

watch(()=>props.options.showAll,()=>{
  console.log('switchmap');
  toggleStyle();
});
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