<template>
  <div class="equip-container">
    <div class="SA">
        <span>仅显示故障路灯</span>
        <el-switch v-model="va" @change="updateShowAll" style="display: flex;"/>
    </div>
  </div>
</template>

<script setup>
import { defineEmits,ref } from 'vue';
const va=ref(false);
const emit = defineEmits(['switchSA']);

const updateShowAll = () => {
  emit('switchSA');  // 触发事件更新父组件
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

.SA{
  display: flex;
  flex-direction: row;
  padding: 20px;  /* 内边距调整，避免紧贴边缘 */
  padding-bottom: 20px;
  justify-content: center;
  align-items: center;
  gap: 10px
}


</style>