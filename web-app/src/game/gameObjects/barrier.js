import Phaser from 'phaser';

export default class Barrier extends Phaser.GameObjects.Sprite {
  constructor(scene, x, y, type) {
    super(scene, x, y, type);
    this.setDisplaySize(16, 40);

    scene.add.existing(this);
    scene.physics.world.enable(this);
  }
}
