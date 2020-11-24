<template>
  <v-card
    class="mx-auto"
    max-width="400"
    tile
  >
    <v-list dense>
      <v-card-text>
        <h3>Ranking score</h3>
      </v-card-text>
      <v-list-item-group
        color="primary"
      >
        <v-list-item
          v-for="(score, i) in score_list"
          :key="i"
        >
          <v-list-item-icon
            class="number-icon"
          >
            {{i + 1}}
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title v-text="score.nickname" class="text-capitalize"></v-list-item-title>
            <v-list-item-subtitle>Score: {{ score.total_score }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-card>
</template>
<script>
export default {
  name: 'RatingScore',
  props: {
    score_list: {},
  },
};
</script>

<style lang="scss">
.v-list--dense {
  .v-list-item--link {
    .number-icon:first-child {
      justify-content: center;
      font-size: 18px;
      font-weight: bold;
      min-width: 30px;
      margin-right: 20px;
    }
  }
}
</style>
