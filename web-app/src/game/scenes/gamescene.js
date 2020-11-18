import Phaser from 'phaser';
import foodImg from '@/assets/game/food.svg';
import snakeHead from '@/assets/game/snake-head.svg';
import snakeBody from '@/assets/game/snake.svg';

// Keys controls
const UP = 0;
const DOWN = 1;
const LEFT = 2;
const RIGHT = 3;

export default class GameScene extends Phaser.Scene {
  constructor() {
    super({
      key: 'GameScene',
    });
  }

  preload() {
    this.load.image('food', foodImg);
    this.load.image('head', snakeHead);
    this.load.image('body', snakeBody);
  }

  create() {
    const Food = new Phaser.Class({
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

    const Snake = new Phaser.Class({
      initialize:
      function Snake(scene, x, y) {
        this.headPosition = new Phaser.Geom.Point(x, y);
        this.body = scene.add.group();
        this.head = this.body.create(x * 16, y * 16, 'head');
        this.head.setDisplaySize(20, 20);
        this.head.setOrigin(0);
        this.alive = true;
        this.speed = 100;
        this.moveTime = 0;
        this.tail = new Phaser.Geom.Point(x, y);
        this.heading = RIGHT;
        this.direction = RIGHT;
      },

      update(time) {
        if (time >= this.moveTime) {
          return this.move(time);
        }
        return time;
      },

      faceLeft() {
        if (this.direction === UP || this.direction === DOWN) {
          this.heading = LEFT;
        }
      },

      faceRight() {
        if (this.direction === UP || this.direction === DOWN) {
          this.heading = RIGHT;
        }
      },

      faceUp() {
        if (this.direction === LEFT || this.direction === RIGHT) {
          this.heading = UP;
        }
      },

      faceDown() {
        if (this.direction === LEFT || this.direction === RIGHT) {
          this.heading = DOWN;
        }
      },

      move(time) {
        // Update headPosition of snake
        switch (this.heading) {
          case LEFT:
            this.headPosition.x = Phaser.Math.Wrap(this.headPosition.x - 1, 0, 40);
            break;
          case RIGHT:
            this.headPosition.x = Phaser.Math.Wrap(this.headPosition.x + 1, 0, 40);
            break;
          case UP:
            this.headPosition.y = Phaser.Math.Wrap(this.headPosition.y - 1, 0, 30);
            break;
          case DOWN:
            this.headPosition.y = Phaser.Math.Wrap(this.headPosition.y + 1, 0, 30);
            break;
          default:
            break;
        }

        this.direction = this.heading;

        // Update the body segments
        Phaser.Actions.ShiftPosition(
          this.body.getChildren(),
          this.headPosition.x * 16,
          this.headPosition.y * 16, 1,
          this.tail,
        );

        // Update the timer ready for the next movement
        this.moveTime = time + this.speed;

        return true;
      },

      grow() {
        const newPart = this.body.create(this.tail.x, this.tail.y, 'body');
        newPart.setDisplaySize(20, 20);
        newPart.setOrigin(0);
      },

      collideWithFood(food) {
        if (this.head.x === food.x && this.head.y === food.y) {
          this.grow();
          food.eat();
          return true;
        }
        return false;
      },
    });

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
      this.snake.collideWithFood(this.food);
    }
  }
}
