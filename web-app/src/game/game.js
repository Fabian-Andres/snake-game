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
      arcade: {
        debug: true,
      },
    },
    scale: {
      mode: Phaser.Scale.FIT,
      width: 644,
      height: 484,
    },
  });
}

export default runGame;
export { runGame };
