import Phaser from 'phaser';
import GameScene from './scenes/gamescene';

function runGame(containerId) {
  return new Phaser.Game({
    type: Phaser.AUTO,
    parent: containerId,
    backgroundColor: '#aad751',
    scene: [
      GameScene,
    ],
    physics: {
      default: 'arcade',
    },
    scale: {
      // mode: Phaser.Scale.FIT,
      width: 640,
      height: 480,
    },
  });
}

export default runGame;
export { runGame };
