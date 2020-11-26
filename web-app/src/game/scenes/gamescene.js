import Phaser from 'phaser';
import Snake from '@/game/gameObjects/snake';
import Food from '@/game/gameObjects/food';
import Barrier from '@/game/gameObjects/barrier';
import appleRed from '@/assets/game/apple-red.svg';
import applePoison from '@/assets/game/apple-poison.svg';
import snakeHead from '@/assets/game/snake-head.svg';
import snakeBody from '@/assets/game/snake-body.svg';
import barrierBambu from '@/assets/game/barrier-bambu.svg';
import store from '@/store';

export default class GameScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'GameScene',
      active: true,
    });
  }

  preload() {
    this.load.image('appleRed', appleRed);
    this.load.image('applePoison', applePoison);
    this.load.image('head', snakeHead);
    this.load.image('body', snakeBody);
    this.load.image('barrierBambu', barrierBambu);
  }

  create() {
    this.add.grid(320, 240, 640, 480, 16, 16, 0xa2d148).setAltFillStyle(0xaad751).setOutlineStyle();
    this.food = new Food(this, 20, 20);
    this.snake = new Snake(this, 13, 13);
    this.snake.grow();
    this.snake.grow();
    this.barrier = new Barrier(this, 30, 10, 'barrierBambu');

    // Init keyboard controls
    this.cursors = this.input.keyboard.createCursorKeys();

    // Init physics to collider snake and barrier
    this.physics.add.collider(
      this.barrier, this.snake.head,
      this.collideWithBrrier,
      null, this,
    );

    this.registry.events.on('SetScore', (score) => {
      store.dispatch('setScore', score);
    });
    this.registry.events.on('SaveScore', () => {
      store.dispatch('postScore');
    });
  }

  update(time) {
    if (!this.snake.alive) {
      this.gameOver();
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
        this.setScore();
        this.repositionFood();
      }
    }
  }

  collideWithBrrier() {
    this.snake.die();
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

  setScore() {
    this.registry.events.emit('SetScore', this.food.total);
  }

  saveScore() {
    const lastPosition = store.getters.getLastScore.total_score;
    if (this.food.total >= lastPosition) {
      this.registry.events.emit('SaveScore');
    } else {
      console.log('Try again');
    }
  }

  gameOver() {
    this.scene.pause(this);
    this.saveScore();
  }
}
