import Vue from 'vue';
import Vuex from 'vuex';
import axios from 'axios';

const axiosConf = axios.create({
  baseURL: 'http://localhost:3000/api',
});

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    scores: {},
  },
  actions: {
    async getScoreList({ commit }) {
      try {
        const response = await axiosConf.get('/scores');
        if (response.status === 200) {
          commit('SET_SCORE_LIST', response.data.score_list);
        }
      } catch (error) {
        console.log(error);
      }
    },
  },
  mutations: {
    SET_SCORE_LIST(state, scores) {
      state.scores = scores;
    },
  },
  getters: {
    getScoreList: (state) => state.scores,
  },
  modules: {
    getScoreList(state) {
      return state.scores;
    },
  },
});
