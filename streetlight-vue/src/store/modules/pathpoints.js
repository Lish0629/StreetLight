const state = () => ({
  points: {
    point1: {},
    point2: {}
  }
});

const mutations = {
  setPoint(state, { pointIndex, coordinates }) {
    state.points[pointIndex] = coordinates;
  }
};

const actions = {
  updatePoint({ commit }, { pointIndex, coordinates }) {
    commit('setPoint', { pointIndex, coordinates });
  }
};

const getters = {
  getPoints(state) {
    return state.points;
  }
};

export default {
  state,
  mutations,
  actions,
  getters
};
