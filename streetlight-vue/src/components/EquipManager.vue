<template>
  <div class="equip-container">
    <div class="switch">
        <span>仅显示故障路灯</span>
        <el-switch v-model="va" @change="updateShowAll" style="display: flex;"/>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { lanternLayer,getStyleFunction } from '@/data/layers';
const va=ref(false);

const updateShowAll = () => {
  lanternLayer.setStyle(getStyleFunction(!va.value)); // 更新样式
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