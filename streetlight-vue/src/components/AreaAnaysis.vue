<template>
  <div class="equip-container">
    <div class="buffer">
      
    </div>
    <div class="switch">
      <span>显示照明区域</span>
      <el-switch v-model="va" @change="updateShowBuffer" style="display: flex;"/>
    </div>
  </div>
</template>

<script setup>
import { defineEmits,ref } from 'vue';
const va=ref(false);
const emit = defineEmits(['switchSB']);

const updateShowBuffer = () => {
  emit('switchSB');  // 触发事件更新父组件
}
</script>

<style scoped lang="scss">
.equip-container{
  height: 100%; /* 设置容器高度 */
  background-color: rgb(52,52,52);
  display: flex;
  align-items: center;
  flex-direction: column;  /* 垂直方向布局 */
}

.switch{
  display: flex;
  flex-direction: row;
  padding: 20px;  /* 内边距调整，避免紧贴边缘 */
  padding-bottom: 20px;
  justify-content: center;
  align-items: center;
  gap: 10px
}


</style>