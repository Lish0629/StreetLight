const state = () => ({
  points: {}
});

const mutations = {
  setPoint(state, { id }) {
    state.points= id;
  }
};

const actions = {
  updatePoint({ commit }, { id }) {
    commit('setPoint', { id });
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
