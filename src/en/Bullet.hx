package en;

import h3d.Vector;

enum BulletTag {
  Player;
  Enemy;
}

/**
 * Bullet base class used for bullets within the game.
 */
class Bullet extends Entity {
  public var damage:Int;
  public var speed:Int;
  public var tag:BulletTag;

  public function new(x:Int, y:Int, value:Int, tag:BulletTag) {
    super(x, y);
    this.damage = value;
  }

  public function fire(direction:Vector, speed:Int) {
    this.speed = speed;
    this.dx = this.speed * direction.x;
    this.dy = this.speed * direction.y;
  }
}