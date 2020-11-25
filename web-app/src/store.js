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
    user: {
      nickname: '',
      score: 0,
    },
  },
  actions: {
    setScore(context, payload) {
      context.commit('SET_SCORE', payload);
    },
    async getScoreList({ commit }) {
      try {
        const response = await axiosConf.get('/scores');
        if (response.status === 200) {
          commit('SET_SCORE_LIST', response.data.score_list);
        }
      } catch (error) {
        // eslint-disable-next-line
        console.log(error);
      }
    },
    async postScore(context, score) {
      try {
        const data = JSON.stringify({ nickname: 'Anonymous', total_score: score });
        const config = {
          method: 'post',
          url: 'http://localhost:3000/api/scores',
          headers: {
            'Content-Type': 'application/json',
          },
          data,
        };

        const response = await axios(config);
        if (response.status === 201) {
          console.log(response.data);
          return;
        }
      } catch (error) {
        // eslint-disable-next-line
        console.log(error);
      }
    },
  },
  mutations: {
    SET_USER(state, payload) {
      state.user.nickname = payload.nickname;
      state.user.score = payload.score;
    },
    SET_SCORE(state, score) {
      state.user.score = score;
    },
    SET_SCORE_LIST(state, scores) {
      state.scores = scores;
    },
  },
  getters: {
    getScore: (state) => state.user.score,
    getScoreList: (state) => state.scores,
    getLastScore: (state) => state.scores.slice(-1).pop(),
  },
  modules: {
    getScore(state) {
      return state.user.score;
    },
    getScoreList(state) {
      return state.scores;
    },
  },
});
