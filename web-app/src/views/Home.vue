<template>
  <v-container>
    <v-row
      justify="center"
    >
      <v-col
        cols="12"
        md="3"
      >
      <v-card
        class="mx-auto"
        max-width="400"
        color="#dedede"
        tile
        v-if="user.nickname != ''"
      >
          <v-card-title>
            <h2>{{ user.nickname }}</h2>
          </v-card-title>
          <v-card-subtitle>
            Your score: {{ user.score }}
          </v-card-subtitle>
      </v-card>
      <rating-score
        :score_list="scores"
      />
      </v-col>
      <v-col
        cols="12"
        md="7"
      >
        <game/>
      </v-col>
    </v-row>
    <modal-register/>
  </v-container>
</template>

<script>
import { mapState } from 'vuex';
import Game from './Game.vue';
import RatingScore from '../components/RatingScore.vue';
import ModalRegister from '../components/ModalRegister.vue';

export default {
  name: 'Home',
  components: {
    Game,
    RatingScore,
    ModalRegister,
  },
  data: () => ({
    //
  }),
  created() {
    this.$store.dispatch('getScoreList');
    this.$store.dispatch('setScore');
  },
  computed: {
    ...mapState(['scores', 'user']),
  },
};
</script>
