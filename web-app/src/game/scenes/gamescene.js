import Phaser from 'phaser';

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
    this.load.image('body', '../../assets/game/snake.png');
  }

  create() {
    const Snake = new Phaser.Class({
      initialize:
      function Snake(scene, x, y) {
        this.headPosition = new Phaser.Geom.Point(x, y);
        this.body = scene.add.group();
        this.head = this.body.create(x * 16, y * 16, 'body');
        this.head.setOrigin(0);
        this.alive = true;
        this.speed = 100;
        this.moveTime = 0;
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
        );

        // Update the timer ready for the next movement
        this.moveTime = time + this.speed;

        return true;
      },

    });

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

    this.snake.update(time);
  }
}
