<template>
  <div class="common-layout">
    <el-container>
      <el-header>校园照明管理系统</el-header>
      <el-container>
        <el-aside width="200px">Aside</el-aside>
        <el-main>Main</el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
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
.el-header{
  background-color: aqua;
}
.el-aside{
  background-color: blueviolet;
}
.el-main{
  background-color: brown;
}
</style>