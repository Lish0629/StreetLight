<template>
  <div id="map"></div>
</template>

<script setup>
import "ol/ol.css";

import Map from 'ol/Map.js';
import View from 'ol/View.js'
import { fromLonLat } from 'ol/proj';
import { onMounted } from 'vue';

import { markLayer,tileLayer,imgLayer } from "@/data/layers";
var map;
const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer],
    view:new View({
      center:fromLonLat([119.725,30.259]),
      zoom:16.5
    })
  });
}

onMounted(initMap)
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
  filter:  grayscale(40%) invert(80%) contrast(120%) brightness(1.5); /* 这里是你想要的样式效果 */
  
}
.blackmark{
  filter:  grayscale(40%) invert(80%) brightness(1.2);
}
</style>