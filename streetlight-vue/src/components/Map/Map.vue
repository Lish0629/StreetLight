<template>
  <div>
    <div id="map">
      <button class="toggle-menu-btn" @click="toggleMenu" :class="{ 'menu-hidden': !menuVisible }">
        {{ menuVisible ? '<<' : '>>' }}
      </button>
      <div class="lantern-menu-container" v-if="menuVisible">
        <LanternMenu />
      </div>
      <button @click="toggleDraw" class="draw-btn">{{ drawMode ? '停止绘制' : '开始绘制' }}</button>
    </div>
  </div>
</template>

<script setup>
import "ol/ol.css";
import axios from 'axios';
import Map from 'ol/Map.js';
import View from 'ol/View.js'
import { fromLonLat } from 'ol/proj';
import { onMounted,ref,watch } from 'vue';
import { markLayer, tileLayer, imgLayer, getStyleFunction,lanternLayer,bufferLayer,pathLayer} from "@/data/layers";
import LanternMenu from "./LanternMenu.vue";
import { Draw } from 'ol/interaction';
import { Vector as VectorSource } from 'ol/source';
import { Vector as VectorLayer } from 'ol/layer';
import { useStore } from "vuex";

let map;
let drawInteraction;
let vectorPoint = new VectorSource();  // 用于存储绘制的点
let pointLayer = new VectorLayer({
  source: vectorPoint,
});
const store=useStore();
const points = ref({ point1: null, point2: null });
//菜单显示状态
const menuVisible = ref(true);

//路灯显示状态
const showAll = ref(true);

//绘制模式
const drawMode = ref(false);

const props = defineProps({
  options:{
    showAll:true
  }
})

const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer,lanternLayer,bufferLayer,pointLayer,pathLayer],
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

//缓冲区显示
const toggleBuffer = () => {
  const layers = map.getLayers().getArray(); // 获取地图图层数组
  let hasBufferLayer = false;

  // 遍历图层数组
  layers.forEach((layer) => {
    if (layer.get('title') === 'bufferlayer') { // 如果找到缓冲区图层
      map.removeLayer(bufferLayer); // 移除图层
      console.log("Buffer layer removed");
      hasBufferLayer = true; // 标志变量设置为 true
    }
  });

  // 如果未找到缓冲区图层，则添加
  if (!hasBufferLayer) {
    bufferLayer.set('title', 'bufferlayer'); // 设置图层的唯一标识
    map.addLayer(bufferLayer); // 添加缓冲区图层
    console.log("Buffer layer added");
  }
};

// 切换菜单显示状态
const toggleMenu = () => {
  menuVisible.value = !menuVisible.value;
};

//Geojson测试函数
const contest=async ()=>{
  const url ='http://localhost:8081/geoserver/streetlight/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=streetlight:lantern&outputFormat=application/json'
  // 使用 axios 发送 GET 请求，并等待响应
  const response = await axios.get(url);
  // 输出 JSON 数据到控制台
  console.log(response.data);
};

//绘制模式
const toggleDraw = () => {

  if (drawMode.value) {
    // 停止绘制模式
    map.removeInteraction(drawInteraction);
  } else {
    // 在开始绘制之前清空之前绘制的点
    vectorPoint.clear(); // 清空所有点
    points.value = {};   // 清空存储的点数据

    // 启用绘制点交互
    drawInteraction = new Draw({
      source: vectorPoint,
      type: 'Point',
    });
    map.addInteraction(drawInteraction);

    // 绘制结束后获取点的坐标
    drawInteraction.on('drawend', (event) => {
      const coordinates = event.feature.getGeometry().getCoordinates();
      console.log('绘制的点坐标:', coordinates);

      // 判断是第一个点还是第二个点
      if (!points.value.point1) {
        points.value.point1 = coordinates;  // 存储第一个点
        store.dispatch('updatePoint',{pointIndex:'point1',coordinates});
        console.log('第一个点存储:', points.value.point1);
      } else if (!points.value.point2) {
        points.value.point2 = coordinates;  // 存储第二个点
        store.dispatch('updatePoint',{pointIndex:'point2',coordinates});
        console.log('第二个点存储:', points.value.point2);
        drawMode.value = false; // 结束绘制模式
        console.log('两个点都已绘制:', points.value);
        map.removeInteraction(drawInteraction); // 停止绘制
      }
    });
  }
  // 切换绘制模式
  drawMode.value = !drawMode.value;
};

onMounted(()=>{
  initMap();
});

//监听路灯显示事件
watch(()=>props.options.showAll,()=>{
  console.log('switchmap');
  toggleStyle();
});

watch(()=>props.options.showBuffer,()=>{
  toggleBuffer();
})
watch(()=>props.options.showDraw,()=>{
  toggleDraw();
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
/* LanternMenu 容器样式 */
.lantern-menu-container {
  position: absolute;
  top: 0;
  right: 0;
  height: 100%; /* 填充地图高度 */
  width: 300px; /* 固定宽度 */
  z-index: 1000; /* 确保在地图之上 */
  background-color: rgba(0, 0, 0, 0.8); /* 半透明背景 */
  overflow: hidden; /* 防止内容溢出 */
  pointer-events: auto; /* 确保可以点击 */
}
/* 切换按钮样式 */
.toggle-menu-btn {
  position: absolute;
  top: 10px; /* 与顶部对齐 */
  right: 310px; /* 初始与菜单宽度一致 */
  width: 40px;
  height: 40px;
  z-index: 1001;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 0px; /* 圆形按钮 */
  cursor: pointer;
  transition: all 0.3s ease;
}

/* 菜单隐藏时调整按钮位置 */
.toggle-menu-btn.menu-hidden {
  right: 10px; /* 菜单隐藏后靠近屏幕右侧 */
}

/* 鼠标悬浮时按钮样式 */
.toggle-menu-btn:hover {
  background-color: rgba(0, 0, 0, 0.9);
}


/* 绘制按钮样式 */
.draw-btn {
  position: absolute;
  top: 60px;
  left: 10px;
  background-color: #007BFF;
  color: white;
  border: none;
  padding: 10px;
  cursor: pointer;
  z-index: 1001;
  border-radius: 5px;
}

.draw-btn:hover {
  background-color: #0056b3;
}
</style>