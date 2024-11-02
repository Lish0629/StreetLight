<template>
  <div class="common-layout">
    <el-container>
      <el-header>Header</el-header>
      <el-container>
        <el-aside width="200px">Aside</el-aside>
        <el-main>Main</el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
</script>

<style scoped>
.common-layout{
  height: auto;
  width: 100vw;
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