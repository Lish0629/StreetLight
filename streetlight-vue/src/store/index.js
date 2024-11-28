// store/index.js
import { createStore } from 'vuex';
import points from './modules/points';  // 引入默认导出的 points 模块

export default createStore({
  state :() => ({
    points: {
      point1: {},
      point2: {}
    }
  }),
  
  mutations :{
    setPoint(state, { pointIndex, coordinates }) {
      state.points[pointIndex] = coordinates;
    }
  },
  
  actions : {
    updatePoint({ commit }, { pointIndex, coordinates }) {
      commit('setPoint', { pointIndex, coordinates });
    }
  },
  
  getters : {
    getPoints(state) {
      return state.points;
    }
  }
});

