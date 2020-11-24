<template><v-app>
  <v-app-bar
    app
    color="black"
    dark
  >
    <game-score/>

    <v-spacer></v-spacer>

    <v-btn
      href="https://github.com/Fabian-Andres/snake-game"
      target="_blank"
      text
    >
      <span class="mr-2">View on github</span>
      <v-icon>mdi-github</v-icon>
    </v-btn>
  </v-app-bar>

  <v-main>
  <router-view />
  </v-main>
  </v-app>
</template>

<script>
import GameScore from './components/GameScore.vue';

export default {
  name: 'App',
  components: {
    GameScore,
  },
};
</script>
