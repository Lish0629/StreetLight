<template>
  <div class="common-layout">
    <el-container>
      <el-header height="80px">
        <div style="font-size: 32px;top:16px;position: relative;">校园照明管理系统</div>
        <!--<el-button @click="options.showAll=!options.showAll">{{ options.showAll }}</el-button>-->
      </el-header>
      <el-container>
        <el-aside width="250px">
          <el-menu>
            <el-sub-menu index="1">
              <template #title class="asidemenu">
                <div class="menu-title" style="height: 72px;">照明设施管理</div>
              </template>
              <div style="height: 400px;width: 100%;">
                  <EquipManager @switchSA="handleShowAll" :options="options"></EquipManager>
              </div>
            </el-sub-menu>
            <el-sub-menu index="2">
              <template #title class="asidemenu">
                <div class="menu-title">照明区域分析</div>
              </template>
            </el-sub-menu>
            <el-menu-item index="3">
              <span>照明区域分析</span>
            </el-menu-item>
            <el-menu-item index="4" >
              <span>照明系统设置</span>
            </el-menu-item>
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
import EquipManager from './EquipManager.vue';
import { ref } from 'vue';

const options =ref({
  showAll:true
});


const handleShowAll=()=>{
  options.value.showAll=!options.value.showAll
}
</script>

<style scoped lang="scss">

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
}
.el-menu-item{
  
  height: 72px;
  font-size: 16px;
}

:v-deep .el-sub-menu__title:hover {
	color: #940909;
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
.mapdiv{
  width: 100%;
  height: 100%;
  position: relative;
}
</style>