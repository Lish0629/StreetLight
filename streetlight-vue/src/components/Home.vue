<template>
  <div class="common-layout">
    <el-container>
      <el-header height="80px">
        <div style="position: relative;">
          <img src='@/assets/title.png' style="top:32px" height="84"/>
        </div>
      </el-header>
      <el-container>
        <el-aside width="250px">
          <el-menu>
            <el-sub-menu index="1">
              <template #title class="asidemenu">
                <div class="menu-title" >照明设施管理</div>
              </template>
              <div style="height: 200px;width: 100%;">
                  <EquipManager></EquipManager>
              </div>
            </el-sub-menu>
            <el-sub-menu index="2">
              <template #title>
                <div class="menu-title">照明区域分析</div>
              </template>
              <div style="height: 400px;width: 100%;">
                  <AreaAnaysis></AreaAnaysis>
              </div>
            </el-sub-menu>
            <el-sub-menu index="3">
              <template #title>
                <div class="menu-title">夜行路线规划</div>
              </template>
              <div style="height: 400px;width: 100%;">
                  <PathPlan @switchSC="handleShowDraw"></PathPlan>
              </div>
            </el-sub-menu>
          </el-menu>
        </el-aside>
        <el-main>
          <div class="mapdiv">
            <Map :options="options"></Map>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>

import Map from './map/Map.vue';
import { ref } from 'vue';
import EquipManager from './EquipManager.vue';
import AreaAnaysis from './AreaAnaysis.vue';
import PathPlan from './PathPlan.vue';

const options =ref({
  showDraw:false
});


//切换绘制模式
const handleShowDraw=()=>{
  console.log('ss')
  options.value.showDraw=!options.value.showDraw
}
</script>

<style  lang="scss">

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
  border-right: 0px;
  --el-menu-item-height: 72px; /* 新值 */
}

.el-header{
  background-color: rgb(34, 34, 34);
}
.el-aside{
  background-color: rgb(48,48,48);
  overflow: hidden !important;
}
.el-main{
  background-color: rgb(62, 61, 61);
}
.mapdiv{
  width: 100%;
  height: 100%;
  position: relative;
  bottom: 10px;
}

.menu-title{
  font-size: 18px;
}

</style>