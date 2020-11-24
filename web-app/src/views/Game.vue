<template>
  <div
    :id="containerId"
    v-if="downloaded"
    class="game"
  />
  <div
    class="placeholder"
    v-else
  >
    Downloading...
  </div>
</template>
<script>
export default {
  name: 'Game',
  data() {
    return {
      downloaded: false,
      gameInstance: null,
      containerId: 'snake-container',
    };
  },
  async mounted() {
    const game = await import('../game/game');
    this.downloaded = true;
    this.$nextTick(() => {
      this.gameInstance = game.runGame(this.containerId);
    });
  },
  destroyed() {
    this.gameInstance.destroy(false);
  },
};
</script>
<style lang="scss">
  .game {
    background: #578a34;
    padding: 20px;
    display: inline-block;
  }
</style>
