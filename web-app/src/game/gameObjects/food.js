import Phaser from 'phaser';

export default new Phaser.Class({
  Extends: Phaser.GameObjects.Image,
  initialize:
  function Food(scene, x, y) {
    Phaser.GameObjects.Image.call(this, scene);

    this.setTexture('food');
    this.setDisplaySize(20, 20);
    this.setPosition(x * 16, y * 16);
    this.setOrigin(0);

    this.total = 0;

    scene.children.add(this);
  },
  eat() {
    this.total += 1;

    const x = Phaser.Math.Between(0, 39);
    const y = Phaser.Math.Between(0, 29);

    this.setPosition(x * 16, y * 16);
  },
});
