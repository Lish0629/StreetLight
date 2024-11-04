<template>
  <div class="common-layout">
    <el-container>
      <el-header height="80px">
        <div style="font-size: 32px;top:16px;position: relative;">校园照明管理系统</div>
      </el-header>
      <el-container>
        <el-aside width="250px">
          <el-menu>
            <el-menu-item index="2">
              <el-icon><icon-menu /></el-icon>
              <span>照明设施管理</span>
            </el-menu-item>
            <el-menu-item index="3">
              <el-icon><document /></el-icon>
              <span>照明区域分析</span>
            </el-menu-item>
            <el-menu-item index="4">
              <el-icon><setting /></el-icon>
              <span>照明系统设置</span>
            </el-menu-item>
          </el-menu>
        </el-aside>
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
  color: rgb(240, 248, 255);
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
.el-menu{
  background-color: rgb(57,57,57);
  border-right: 0px;
}
.el-menu-item{
  color: rgb(240, 248, 255);
  height: 72px;
  font-size: 16px;
}
.el-menu-item.is-active{
  color: rgb(240, 248, 255);
  background-color: rgb(110, 110, 124)!important;
}
.el-menu-item:hover{
  background-color: rgb(110, 110, 124);
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