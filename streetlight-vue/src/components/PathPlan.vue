<template>
  <div class="path-container">
    <div class="create-path">
      <el-button @click="updateShowDraw">🚩绘制起始点</el-button> 
      <!-- 输入框，用于显示坐标 -->
      <div class="coordinates" width="80%" align-items="center">
        <span>起点:</span>
        <el-input v-model="point1text" placeholder="起点坐标" readonly></el-input>
        <span>终点:</span>
        <el-input v-model="point2text" placeholder="终点坐标" readonly></el-input>
      </div>
    </div>
    <el-button @click="generatePath">🗺️生成最短路径</el-button> <!-- 将按钮单独放到下一行 -->
    <div class="switch">
      <span>显示最短路径</span>
      <el-switch v-model="showPath" @change="updateShowPath" style="display: flex;"/>
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import { defineEmits,ref,computed } from 'vue';
import { useStore } from "vuex";
import { pathLayer} from "@/data/layers";


//路径图层显示属性
const showPath = ref(false);

//起始点经纬度坐标
const coordinates=ref({});

//Vuex存储
const store=useStore();

//获取Vuex存储的point值
const points=computed(()=>store.state.pathpoints.points);

//起点文本格式化
const point1text = computed(() => {
  if (points.value.point1[0]) {
    const lon = points.value.point1[0]?.toFixed(3) || "0.000";
    const lat = points.value.point1[1]?.toFixed(3) || "0.000";
    return `${lon}, ${lat}`;
  }
  return "起点坐标";
});

//终点文本格式化
const point2text = computed(() => {
  if (points.value.point2[0]) {
    const lon = points.value.point2[0]?.toFixed(3) || "0.000";
    const lat = points.value.point2[1]?.toFixed(3) || "0.000";
    return `${lon}, ${lat}`;
  }
  return "终点坐标";
});

//测试函数
const test1=()=>{
  console.log(points.point1);
}

//生产路径端口
const generatePath = async () => {
  showPath.value=true;
  updateShowPath();
  //console.log(points.value);
  coordinates.value = {
    lon1: points.value.point1[0],
    lat1: points.value.point1[1],
    lon2: points.value.point2[0],
    lat2: points.value.point2[1]
  };
  console.log(coordinates.value);
  try {
    const response = await axios.post('http://127.0.0.1:5000/generate-path', coordinates.value, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
    console.log(response.data); 
  } catch (error) {
    console.error('Error:', error);  // 捕获错误
  }
};

//定义emit
const emit = defineEmits(['switchSC']);

//路径图层显示控制
const updateShowPath = () => {
  pathLayer.setVisible(showPath.value)
}

const updateShowDraw = () => {
  emit('switchSC');  // 触发事件更新父组件
}

</script>

<style scoped lang="scss">

.path-container {
  height: 100%; /* 设置容器高度 */
  background-color: rgb(52, 52, 52);
  display: flex;
  flex-direction: column; /* 垂直方向布局 */
  align-items: center; /* 居中对齐 */
  justify-content: space-around; /* 均匀分布子元素 */
  gap: 20px; /* 元素之间间距 */
}

.switch {
  display: flex;
  flex-direction: row; /* 水平方向布局 */
  align-items: center;
  gap: 25px; /* 元素间距 */
}

.create-path {
  display: flex;
  flex-direction: column; /* 垂直方向布局 */
  align-items: center; /* 居中对齐 */
  gap: 20px; /* 元素之间的间距 */
  width: 100%; /* 占满容器宽度 */
}

.slider-container {
  display: flex;
  flex-direction: row; /* 水平方向布局 */
  align-items: center; /* 垂直居中对齐 */
  gap: 25px; /* 元素间的水平间距 */
}

.create-path el-button {
  align-self: center; /* 确保按钮居中 */
}

.coordinates {
  display: flex;
  flex-direction: column; /* 垂直排列输入框 */
  align-items: center; /* 居中对齐 */
  width: 100%; /* 确保宽度填满父容器 */
}

.coordinates el-input__wrapper {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center;     /* 垂直居中 */
  width: 83%!important  ;            /* 控制输入框的宽度 */
  margin: 8px;
}
.coordinates span{
  display: flex;
  flex-direction: column; /* 垂直排列输入框 */
  align-items: left; /* 居中对齐 */
  width: 83%; /* 确保宽度填满父容器 */
}
.el-input {
  width: 83%; /* 确保输入框宽度占满父容器 */
  margin: 8px;
}

</style>