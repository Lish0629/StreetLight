import { createStore } from 'vuex';

// 引入导出的 points 模块
import pathpoints from './modules/pathpoints';

export default createStore({
  modules: {
    pathpoints, // 注册模块
  },
});

