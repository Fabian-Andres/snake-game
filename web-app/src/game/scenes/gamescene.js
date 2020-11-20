import Phaser from 'phaser';
import Snake from '@/game/gameObjects/snake';
import Food from '@/game/gameObjects/food';
import foodImg from '@/assets/game/food.svg';
import snakeHead from '@/assets/game/snake-head.svg';
import snakeBody from '@/assets/game/snake.svg';

export default class GameScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'GameScene',
      active: true,
    });
  }

  preload() {
    this.load.image('food', foodImg);
    this.load.image('head', snakeHead);
    this.load.image('body', snakeBody);
  }

  create() {
    this.food = new Food(this, 3, 4);
    this.snake = new Snake(this, 8, 8);

    // Init keyboard controls
    this.cursors = this.input.keyboard.createCursorKeys();
  }

  update(time) {
    if (!this.snake.alive) {
      return;
    }

    // Check which key is pressed
    if (this.cursors.left.isDown) {
      this.snake.faceLeft();
    } else if (this.cursors.right.isDown) {
      this.snake.faceRight();
    } else if (this.cursors.up.isDown) {
      this.snake.faceUp();
    } else if (this.cursors.down.isDown) {
      this.snake.faceDown();
    }

    if (this.snake.update(time)) {
      if (this.snake.collideWithFood(this.food)) {
        this.addScore(this.food.total);
        this.repositionFood();
      }
    }
  }

  repositionFood() {
    const testGrid = [];

    for (let y = 0; y < 30; y += 1) {
      testGrid[y] = [];
      for (let x = 0; x < 40; x += 1) {
        testGrid[y][x] = true;
      }
    }

    this.snake.updateGrid(testGrid);

    const validLocations = [];
    for (let y = 0; y < 30; y += 1) {
      for (let x = 0; x < 40; x += 1) {
        if (testGrid[y][x] === true) {
          validLocations.push({ x, y });
        }
      }
    }

    if (validLocations.length > 0) {
      const pos = Phaser.Math.RND.pick(validLocations);
      this.food.setPosition(pos.x * 16, pos.y * 16);

      return true;
    }
    return false;
  }

  addScore(score) {
    this.registry.events.emit('Score', score);
  }
}
