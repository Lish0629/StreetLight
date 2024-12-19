<template>
  <div>
    <el-dialog></el-dialog>
    <div id="map">
      <button class="toggle-menu-btn" @click="toggleMenu" :class="{ 'menu-hidden': !menuVisible }">
        {{ menuVisible ? '>>' : '<<' }}
      </button>
      <div class="lantern-menu-container" v-if="menuVisible">
        <LanternMenu />
      </div>
      <div id="popup" class="ol-popup">
        <div id="popup-content"></div>
      </div>
    </div>
    <el-dialog v-model="dialogVisible" title="Tips" width="300">
      <div style="margin-bottom: 8px;">
        <span id="status-label">状态：</span>
        <el-select v-model="lanternStatus" placeholder="请选择状态">
          <el-option label="正常" value="true"></el-option>
          <el-option label="故障" value="false"></el-option>
        </el-select>
      </div>
      <!-- 路灯 ID 输入框 -->
      <span id="status-label">序号：</span>
      <el-input v-model="newLanternId" placeholder="请输入路灯序号"></el-input>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="addLantern">确定</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog v-model="dialogDelVisible" title="Tips" width="300">
      <span id="status-label">序号：</span>
      <el-input v-model="dellanternid" placeholder="请输入删除路灯序号"></el-input>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogDelVisible = false">取消</el-button>
          <el-button type="danger" @click="delLantern">删除</el-button>
        </div>
      </template>
    </el-dialog>
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
import { WKT } from 'ol/format';
import { Style, Icon } from 'ol/style';
import flagImage from '@/assets/flag.png';
import { useMapCooStore,useSelectStore,createPointStore } from "@/store/store";
import axios from "axios";
import { ElMessage } from "element-plus";
import Point from 'ol/geom/Point';

let map;
let drawInteraction;
const newLanternId=ref();
const lanternStatus=ref(true);
const dellanternid=ref();
//存储绘制的起始点
const points = ref({ point1: null, point2: null });

//菜单显示状态
const menuVisible = ref(false);

//绘制模式
const drawMode = ref(false);

//定义Props
const props = defineProps({
  options:{}
})

const dialogVisible=ref(false)
const dialogDelVisible=ref(false)
//引入Pinia状态管理
const storeMapCoo=useMapCooStore();
const storeSelect=useSelectStore();
const storeCreate=createPointStore();


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
        storeMapCoo.setPoint('point1',coordinates);
        console.log('第一个点存储:', points.value.point1);
      } else if (!points.value.point2) {
        points.value.point2 = coordinates;  // 存储第二个点
        storeMapCoo.setPoint('point2',coordinates);
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

watch(()=>storeSelect.selectPoint,(newPoint)=>{
  console.log(storeSelect.selectPoint.geom);
  //创建WKT格式的对象
  const wktFormat = new WKT();
  //创建要素点
  const point = wktFormat.readGeometry(storeSelect.selectPoint.geom);
  //设置中心点和缩放级别
  map.getView().setCenter(fromLonLat(point.getCoordinates()));
  map.getView().setZoom(20);
  console.log(point)
  if (newPoint && newPoint.id) {
    // 遍历 lanternLayer 的所有要素，找到匹配的 id
    console.log(newPoint.id)
    const feature = lanternLayer.getSource().getFeatures().find((f) => f.get('name') === newPoint.name);

    console.log(feature)
    if (feature) {
      // 获取要素的坐标
      const coordinates = feature.getGeometry().getCoordinates();
      // 设置 Popup 内容
      const content = `
        <p><strong>序号：</strong> ${feature.get('name') || '未定义'}</p>
        <p><strong>状态：</strong> ${feature.get('status') ? '正常' : '故障'}</p>
      `;
      document.getElementById('popup-content').innerHTML = content;
      // 设置 Popup 的位置
      popup.setPosition(coordinates);
      // 平移视图到目标位置
    } else {
      console.log('未找到匹配的要素');
      popup.setPosition(undefined); // 如果没有匹配要素，则隐藏 Popup
    }
  }
})

watch(()=>storeCreate.drawPointStatus,()=>{
  console.log("!");
  map.on("click", handleMapClick); // 监听地图点击事件
})
let clickCoordinate;
// 处理地图点击事件
const handleMapClick = (event) => {
  clickCoordinate = event.coordinate; // 获取点击位置的坐标（EPSG:3857）
  console.log(clickCoordinate)
  dialogVisible.value = true; // 显示弹窗输入路灯 ID
  console.log(dialogVisible.value)
};
// 添加路灯
const addLantern = async () => {
  if (!newLanternId.value) {
    ElMessage.error("路灯ID不能为空");
    return;
  }
  const coordinateWithZ = [...clickCoordinate, 0]; // 添加Z=0
  const wktFormat = new WKT();
  const geom = wktFormat.writeGeometry(
    new Point(coordinateWithZ), // 使用点击坐标生成几何
    {
      dataProjection: 'EPSG:4326', // 数据投影
      featureProjection: 'EPSG:3857', // 地图投影
    }
  );
  
  const lanternData = {
    id: newLanternId.value,
    status:lanternStatus.value,
    geom, // WKT 格式的几何
  };
  console.log(lanternData)
  try {
    const response = await axios.post("http://localhost:5000/add-lantern", lanternData); // 调用后端 API
    if (response.status === 201) {
      ElMessage.success("路灯添加成功");
      dialogVisible.value = false;
      lanternLayer.getSource().refresh(); // 重新加载图层源
      // 在地图上显示新增路灯点
    }
  } catch (error) {
    ElMessage.error("路灯添加失败");
    console.error(error);
  }
};

watch(()=>storeCreate.delPointStatus,()=>{

  dialogDelVisible.value=true;
})

// 添加路灯
const delLantern = async () => {
  
  try {
    const response = await axios.delete(`http://localhost:5000/del-lantern/${dellanternid.value}`); // 调用后端 API
    if (response.status === 200) {
      ElMessage.success("路灯删除成功");
      dialogDelVisible.value = false;
      // 假设你有一个图层对象 'layer'
      lanternLayer.getSource().refresh(); // 重新加载图层源

      // 这里可以加入逻辑来更新地图上的数据
    } else {
      ElMessage.error("路灯删除失败，未找到该路灯");
    }
  } catch (error) {
    ElMessage.error("路灯删除失败，请检查网络或联系管理员");
    console.error(error);
  }
};

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
  border: none; /* 去除边框 */
  bottom: 25px;
  left: -89.5px;
  width: 150px;
  z-index: 9999;
}

/* 增加箭头的样式 */
.ol-popup::after {
  content: ''; /* 创建一个空内容的伪元素 */
  position: absolute;
  bottom: -13px; /* 设置箭头的位置 */
  left: 50%;
  transform: translateX(-50%); /* 水平居中 */
  width: 0;
  height: 0;
  
  /* 创建箭头的透明边框 */
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-top: 20px solid rgb(40, 39, 39); /* 箭头颜色与背景一致 */
}
.el-dialog {
  z-index: 2000 !important; /* 确保高于地图或其他元素 */
}

</style>