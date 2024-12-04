// store/index.js
import { createStore } from 'vuex';
import pathpoints from './modules/pathpoints';  // 引入默认导出的 points 模块

export default createStore({
  modules: {
    pathpoints, // 注册模块
  },
});

