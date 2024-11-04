<template>
  <div class="common-layout">
    <el-container>
      <el-header>
        <div style="font-size: 32px;top:6px;position: relative;">校园照明管理系统</div>
      </el-header>
      <el-container>
        <el-aside width="200px">Aside</el-aside>
        <el-main>
          <MapView></MapView>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import MapView from '@/views/MapView.vue';

</script>

<style scoped lang="scss">
div{
  color: aliceblue;
}
.common-layout{
  height: 100vh;
}
.el-container:nth-child(2) {
    // 使用视口高度减去头部高度来设置容器高度
    height: calc(100vh - 60px);
    // 使用 Flexbox 布局让子元素（侧边栏和主要内容区域）可以伸缩填满空间
    display: flex;
  }
.el-header{
  background-color: rgb(34, 34, 34);
 
}
.el-aside{
  background-color: rgb(48,48,48);
}
.el-main{
  background-color: rgb(62, 61, 61);
}
</style>