<script setup>
import { RouterLink, RouterView } from 'vue-router'

</script>

<template>
  <div class="main">
    <RouterView />
  </div>
  
</template>

<style scoped>
body{
  margin:0px;
  overflow: hidden;
}
.main{
  position: absolute;
  top:0;
  right:0;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 100vh;
}
</style>
