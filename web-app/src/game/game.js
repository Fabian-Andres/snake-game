import Phaser from 'phaser';
import GameScene from './scenes/gamescene';

function runGame(containerId) {
  return new Phaser.Game({
    type: Phaser.AUTO,
    parent: containerId,
    scene: [
      GameScene,
    ],
    scale: {
      mode: Phaser.Scale.FIT,
      haigth: '100%',
      width: '100%',
    },
  });
}

export default runGame;
export { runGame };
