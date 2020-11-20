<template>
  <v-card
    class="mx-auto"
    max-width="400"
    tile
  >
    <v-card-text>
      <h3>Ranking score</h3>
    </v-card-text>
    <v-list-item two-line
      v-for="(n, index) in 3"
      :key="index"
    >
      <v-list-item-content>
        <v-list-item-title>anonymous{{ index }}</v-list-item-title>
        <v-list-item-subtitle>Score 12{{ index }}</v-list-item-subtitle>
      </v-list-item-content>
    </v-list-item>
  </v-card>
</template>
<script>
export default {
  name: 'rating-score',
};
</script>
