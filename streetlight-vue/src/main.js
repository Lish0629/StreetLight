import "ol/ol.css";
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
const app = createApp(App)
import 'element-plus/theme-chalk/dark/css-vars.css'
app.use(router).use(ElementPlus)

app.mount('#app')
