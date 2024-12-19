import "ol/ol.css";
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'

const app = createApp(App)

//引入Pinia状态管理
const pinia = createPinia()

app.use(router).use(ElementPlus).use(pinia)

app.mount('#app')
