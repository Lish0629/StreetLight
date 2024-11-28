import "ol/ol.css";
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import store from './store/index.js'
const app = createApp(App)

app.use(router).use(ElementPlus).use(store)

app.mount('#app')
