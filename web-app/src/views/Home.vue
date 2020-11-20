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
        tile
      >
        <v-card-text>
          <h1 class="h2">Snake Game</h1>
          <h3>Nickname: </h3>
        </v-card-text>
       </v-card>
      <rating-score/>
      </v-col>
      <v-col
        cols="12"
        md="6"
      >
        <game/>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
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
};
</script>
