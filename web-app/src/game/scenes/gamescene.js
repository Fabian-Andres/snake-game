import Phaser from 'phaser';
import snakeImg from '../../assets/game/snake.png';

export default class GameScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'GameScene',
    });
  }

  preload() {
    this.load.image('snake', snakeImg);
  }

  create() {
    this.snake = this.add.image(50, 100, 'snake');
  }

  update() {
    console.log(this);

  }
}
