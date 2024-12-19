<template>
  <div class="equip-container">
    <div class="switch">
        <span>仅显示故障路灯</span>
        <el-switch v-model="va" @change="updateShowAll" style="display: flex;"/>
    </div>
    <div class="button-container">
      <el-button type="primary" @click="addLight">添加路灯</el-button>
      <el-button type="danger" @click="removeLight">删除路灯</el-button>
    </div>
  </div>

</template>

<script setup>
import { ref } from 'vue';
import { lanternLayer,getStyleFunction } from '@/data/layers';
import { createPointStore} from "@/store/store";
import { ElMessage } from 'element-plus';
const va=ref(false);
const storeCreate=createPointStore();
const updateShowAll = () => {
  lanternLayer.setStyle(getStyleFunction(!va.value)); // 更新样式
}
// 开启 "添加路灯" 模式
const addLight = () => {
  ElMessage.info("请点击地图选择路灯位置");
  storeCreate.handleCreateDraw();
  console.log(storeCreate.drawPointStatus)
};

const removeLight = () => {
  storeCreate.handleDel();
};

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
  gap: 10px;
}
.button-container{
  display: flex;
  flex-direction: row;
  padding: 20px;  /* 内边距调整，避免紧贴边缘 */
  padding-bottom: 20px;
  justify-content: center;
  align-items: center;
  gap: 10px;
}
</style>