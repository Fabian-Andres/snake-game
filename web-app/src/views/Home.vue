<template>
  <v-container>
    <v-row
      justify="center"
    >
      <v-col
        cols="12"
        md="3"
      >
      <v-card>
        <v-card-text class="text-black">
          <h2>Your score {{ score }}</h2>
        </v-card-text>
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
  </v-container>
</template>

<script>
import { mapState } from 'vuex';
import Game from './Game.vue';
import RatingScore from '../components/RatingScore.vue';

export default {
  name: 'Home',
  components: {
    Game,
    RatingScore,
  },
  data: () => ({
    //
  }),
  created() {
    this.$store.dispatch('getScoreList');
    this.$store.dispatch('setScore');
  },
  computed: {
    ...mapState(['scores', 'score']),
  },
};
</script>
