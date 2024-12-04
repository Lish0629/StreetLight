<template>
  <div class="path-ccontainer">
    <div class="create-path">
      <el-button @click="updateShowDraw">绘制起始点</el-button> <!-- 将按钮单独放到下一行 -->
    </div>
    <div class="switch">
      <span>显示最短路径</span>
      <el-button @click="generatePath">生成</el-button> <!-- 将按钮单独放到下一行 -->
      <el-button @click="test1">生成</el-button> <!-- 将按钮单独放到下一行 -->
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import { defineEmits,ref,computed } from 'vue';
import { useStore } from "vuex";
const va0=ref(true);
const va1=ref(true);
const coordinates=ref({});
const store=useStore();
const points=computed(()=>store.state.pathpoints.points).value;
const test1=()=>{
  console.log(points.point1);
}
const generatePath = async () => {
  //console.log(points.value);
  coordinates.value = {
    lon1: points.value.point1[0],
    lat1: points.value.point1[1],
    lon2: points.value.point2[0],
    lat2: points.value.point2[1]
  };
  //console.log(coordinates.value);
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

const emit = defineEmits(['switchSC']);

const updateShowDraw = () => {
  va1.value=!va1.value;
  emit('switchSC');  // 触发事件更新父组件
}
</script>

<style scoped lang="scss">

.path-ccontainer {
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
</style>