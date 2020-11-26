import Phaser from 'phaser';

export default class Barrier extends Phaser.GameObjects.Sprite {
  constructor(scene, x, y, type) {
    super(scene, x, y, type);
    this.setDisplaySize(16, 48);
    this.setPosition(x * 16, y * 16);
    this.setOrigin(0);

    scene.add.existing(this);
    scene.physics.world.enable(this);
  }
}
