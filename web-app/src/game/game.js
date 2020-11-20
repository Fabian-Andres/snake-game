import Phaser from 'phaser';
import GameScene from './scenes/gamescene';
import ScoreScene from './scenes/scorescene';

function runGame(containerId) {
  return new Phaser.Game({
    type: Phaser.AUTO,
    parent: containerId,
    backgroundColor: '#aad751',
    scene: [
      ScoreScene,
      GameScene,
    ],
    physics: {
      default: 'arcade',
    },
    scale: {
      // mode: Phaser.Scale.FIT,
      width: 644,
      height: 484,
    },
  });
}

export default runGame;
export { runGame };
