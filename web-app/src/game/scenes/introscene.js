import Phaser from 'phaser';

export default class IntroScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'IntroScene',
      active: false,
    });
  }

  // preload() {

  // }

  create() {
    const graphics = this.add.graphics();

    graphics.fillStyle(0xff3300, 1);
    graphics.fillRect(100, 100, 300, 200);
    graphics.fillRect(100, 50, 90, 100);

    this.add.text(125, 50, 'A', { font: '60px Courier', fill: '#000000' });

    this.registry.events.on('nickname', (nickname) => {
      console.log(nickname);
    });
    this.registry.events.emit('nickname', 'Fabian');
  }

  // update() {

  // }
}
