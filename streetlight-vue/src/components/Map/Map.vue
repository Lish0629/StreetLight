<template>
  <div>
    <div id="map">
      <button class="toggle-menu-btn" @click="toggleMenu" :class="{ 'menu-hidden': !menuVisible }">
        {{ menuVisible ? '<<' : '>>' }}
      </button>
      <div class="lantern-menu-container" v-if="menuVisible">
        <LanternMenu />
        <div id="popup" class="ol-popup">
          <div id="popup-content"></div>
        </div>
      </div>
      <!--<button @click="toggleDraw" class="draw-btn">{{ drawMode ? '停止绘制' : '开始绘制' }}</button>-->
    </div>
  </div>
</template>

<script setup>
import "ol/ol.css";
import Map from 'ol/Map.js';
import View from 'ol/View.js'
import Overlay from 'ol/Overlay';
import LanternMenu from "./LanternMenu.vue";
import { fromLonLat } from 'ol/proj';
import { onMounted,ref,watch } from 'vue';
import { markLayer, tileLayer,lanternLayer,bufferLayer,pathLayer,pointLayer,vectorPoint} from "@/data/layers";
import { Draw } from 'ol/interaction';
import { useStore } from "vuex";
import { Style, Icon } from 'ol/style';
import flagImage from '@/assets/flag.png';
import { useMapCooStore } from "@/store/store";

let map;
let drawInteraction;

//引入Vuex状态管理
const store=useStore();

//存储绘制的起始点
const points = ref({ point1: null, point2: null });

//菜单显示状态
const menuVisible = ref(true);

//绘制模式
const drawMode = ref(false);

//定义Props
const props = defineProps({
  options:{
  }
})

const storepinia=useMapCooStore()

const popup = new Overlay({
  element: document.getElementById('popup'),
  autoPan: true,
  autoPanAnimation: {
    duration: 250,
  },
});

const initPopup=()=>{
  popup.setElement(document.getElementById('popup'));
  map.addOverlay(popup);
  // 为地图绑定单击事件
  map.on('singleclick', (evt) => {
    // 获取点击处的像素和要素
    const feature = map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      return layer === lanternLayer ? feature : null;
    });

    if (feature) {
      const coordinates = feature.getGeometry().getCoordinates();
      const content = `
        <p><strong>序号：</strong> ${feature.get('name') || '未定义'}</p>
        <p><strong>状态：</strong> ${feature.get('status')?'正常':'故障'}</p>
      `;
      
      // 设置 Popup 内容和位置
      document.getElementById('popup-content').innerHTML = content;
      popup.setPosition(coordinates);
    } else {
      // 如果没有点击到要素，则隐藏 Popup
      popup.setPosition(undefined);
    }
  });
};

//初始化地图
const initMap=()=>{
  console.log("ready");
  map=new Map({
    target:'map',
    layers: [tileLayer,markLayer,lanternLayer,pointLayer,bufferLayer,pathLayer],
    view:new View({
      center:fromLonLat([119.725,30.259]),
      zoom:16.5,
      minZoom:15,
      maxZoom:18.5
    }),
  });
}

// 初始化服务
const initServe=async()=>{
  try{
    const response = await axios.get('http://localhost:5000/init');
    console.log(response.data);
  } catch (error) {
    console.log(error);
  }
}

// 切换菜单显示状态
const toggleMenu = () => {
  menuVisible.value = !menuVisible.value;
};

// 小旗样式
const flagIconStyle = new Style({
  image: new Icon({
    src: flagImage,  
    scale: 0.015 // 缩放图标的大小
  })
});

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
      style: flagIconStyle,
      showTemporary: false
    });
    map.addInteraction(drawInteraction);
    drawInteraction.on('drawstart', (event) => {
      const sketch = event.feature;  // 获取临时草图图层
      sketch.setStyle(flagIconStyle);
    });

    // 绘制结束后获取点的坐标
    drawInteraction.on('drawend', (event) => {
      const coordinates = event.feature.getGeometry().getCoordinates();
      console.log('绘制的点坐标:', coordinates);
      // 判断是第一个点还是第二个点
      if (!points.value.point1) {
        points.value.point1 = coordinates;  // 存储第一个点
        store.dispatch('updatePoint',{pointIndex:'point1',coordinates});
        storepinia.setPoint('point1',coordinates);
        console.log('第一个点存储:', points.value.point1);
      } else if (!points.value.point2) {
        points.value.point2 = coordinates;  // 存储第二个点
        store.dispatch('updatePoint',{pointIndex:'point2',coordinates});
        storepinia.setPoint('point2',coordinates);
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

//监听绘制模型
watch(()=>props.options.showDraw,()=>{
  toggleDraw();
})

onMounted(()=>{
  initMap();
  initServe();
  initPopup();
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
/* 矢量底图暗黑样式 */
.blacktile {
  filter:  grayscale(40%) invert(80%) contrast(120%) brightness(1.5); /* 矢量图层暗黑模式 */
}
/* 标注暗黑样式 */
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
.ol-popup {
  position: absolute;
  background-color: rgb(40, 39, 39);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
  padding: 15px;
  border-radius: 10px;
  border: 1px solid #383838;
  bottom: 25px;
  left: -89.5px;
  width: 150px;
  
}

</style>