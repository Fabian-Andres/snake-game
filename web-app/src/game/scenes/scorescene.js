import Phaser from 'phaser';

export default class ScoreScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'ScoreScene',
      active: false,
    });
  }

  // preload() {

  // }

  create() {
    this.add.text(20, 20, 'Score', { color: '#fff', fontSize: 30 });
    this.score = this.add.text(115, 20, '0', { color: '#fff', fontSize: 30 });

    this.registry.events.on('Score', (score) => {
      this.score.setText(score);
    });
  }
  // update() {

  // }
}
