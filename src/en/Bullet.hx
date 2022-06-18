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
  public var speed:Float;
  public var tag:BulletTag;
  public var available:Bool;
  public var g:h2d.Graphics;

  public function new(x:Int, y:Int, value:Int, tag:BulletTag) {
    super(x, y);
    this.spr.visible = false;
    this.damage = value;
    this.available = true;
    // Set Friction to 1 to prevent the bullet from being stopped
    this.frictX = 1;
    this.frictY = 1;
    this.bumpFrict = 1;
    setupGraphic();
    this.removeEmptyTexture();
  }

  override function removeEmptyTexture() {
    // The tile is being used across multiple rendered elements
    // Clearing it here, clears it for everybody.
    spr.tile.getTexture().clear(0x0, 0);
  }

  public function setupGraphic() {
    g = this.spr.createGraphics();
    g.beginFill(0xffffff);
    g.drawRect(0, 0, 4, 4);
    g.endFill();
    g.visible = false;
  }

  public function fire(direction:Vector, speed:Float, cooldown:Float) {
    this.speed = speed;
    this.g.visible = true;
    this.spr.visible = true;
    this.dx = this.speed * direction.x;
    this.dy = this.speed * direction.y;
    this.available = false;
    cd.setS('bulletCooldown', cooldown, () -> {
      this.dx = 0;
      this.dy = 0;
      this.spr.visible = false;
      g.visible = false;
      this.available = true;
    });
  }

  public function isAvailable() {
    return this.available;
  }
}