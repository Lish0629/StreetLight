<template>
  <div>
    <div class="ss">
        <span>仅显示故障路灯</span>

        <el-switch v-model="va" @change="updateShowAll" style="display: flex;"/>

    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits,ref } from 'vue';
const va=ref(true);
const emit = defineEmits(['switchSA']);
const props =defineProps({
  options:{}
})
const updateShowAll = () => {
  emit('switchSA');  // 触发事件更新父组件
}
</script>

<style scoped>
div {
  height: 100%; /* 设置容器高度 */
  width: 100%;  /* 设置容器宽度 */
  background-color: rgb(52,52,52);
  display: flex;
  flex-direction: column;  /* 垂直方向布局 */
  
}

.ss{
    display: flex;
    flex-direction: row;
    padding: 20px;  /* 内边距调整，避免紧贴边缘 */
    padding-bottom: 0px;
    justify-content: flex-start;
    align-items: stretch;
    gap: 5px
}


</style>