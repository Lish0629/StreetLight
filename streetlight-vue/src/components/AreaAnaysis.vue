<template>
  <div class="equip-container">
    <div class="create-buffer">
      <div class="slider-container">
        <span>建筑照明范围</span>
        <el-slider v-model="dist.bulid_dist" :step="5" :max="50" style="width: 50px;" />
      </div>
      <div class="slider-container">
        <span>路灯照明范围</span>
        <el-slider v-model="dist.lantern_dist" :step="5" :max="50" style="width: 50px;" />
      </div>
      <el-button @click="generateBuffer">生成</el-button> <!-- 将按钮单独放到下一行 -->
    </div>
    <div class="switch">
      <span>显示照明区域</span>
      <el-switch v-model="va0" @change="updateShowBuffer" style="display: flex;width: 50px;"/>
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import { defineEmits,ref } from 'vue';
const va0=ref(false);

const dist = ref({
  bulid_dist: 10,
  lantern_dist: 10
});

const generateBuffer = async () => {
  try {
    const response = await axios.post('http://127.0.0.1:5000/generate-lantern-buffer', dist.value, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
    console.log(response.data); 
  } catch (error) {
    console.error('Error:', error);  // 捕获错误
  }
};

const emit = defineEmits(['switchSB']);

const updateShowBuffer = () => {
  emit('switchSB');  // 触发事件更新父组件
}
</script>

<style scoped lang="scss">

.equip-container {
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

.create-buffer {
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

.create-buffer el-button {
  align-self: center; /* 确保按钮居中 */
}
</style>