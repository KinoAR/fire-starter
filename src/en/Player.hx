package en;

import h2d.col.Point;
import h3d.Vector;
import en.Bullet.BulletTag;
import dn.legacy.Controller.ControllerAccess;

class Player extends BaseEnt {
  public var ct:ControllerAccess;

  public static inline var INVINCIBLE_TIME:Float = 3;

  public static inline var MOVE_SPD:Float = .1;
  public static inline var JUMP_FORCE:Float = 1;
  public static inline var HEALTH_CAP:Int = 3;

  public static inline var BULLET_AMT:Int = 20;
  public static inline var BULLET_CD:Float = 0.3;

  public var isInvincible(get, null):Bool;

  public var bulletPool:Group<Bullet>;

  public inline function get_isInvincible() {
    return cd.has('invincbleTime');
  }

  public function new(x:Int, y:Int) {
    super(x, y);
    setup();
  }

  public function setup() {
    ct = Main.ME.controller.createAccess('player');

    this.bulletPool = new Group<Bullet>();

    for (i in 0...BULLET_AMT) {
      this.bulletPool.add(new Bullet(this.cx, this.cy, 1, BulletTag.Player));
    }
    setupStats();
    setupGraphic();
  }

  public function setupStats() {
    this.health = 3;
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    g.beginFill(0x0000ff);
    g.drawRect(0, 0, size, size);
    g.endFill();
  }

  override function onPreStepX() {
    super.onPreStepX();

    if (level.hasAnyCollision(cx + 1,
      cy - 1) && xr >= 0.7) // Handle squash and stretch for entities in the game
    {
      xr = 0.5;
      dx = 0;
      setSquashY(0.6);
    }

    if (level.hasAnyCollision(cx - 1, cy - 1) && xr <= 0.3) {
      xr = 0.3;
      dx = 0;
      setSquashY(0.6);
    }
  }

  override function onPreStepY() {
    super.onPreStepY();

    if (level.hasAnyCollision(cx, cy)
      && yr >= 0.5
      || level.hasAnyCollision(cx + M.round(xr), cy)
      && yr >= 0.5) {
      // Handle squash and stretch for entities in the game
      if (level.hasAnyCollision(cx, cy + M.round(yr + 0.3))) {
        // setSquashY(0.6);
        dy = 0;
      }
      yr = 0.5;
      dy = 0;
    }

    // if (level.hasAnyCollision(cx, cy + 1)) {
    //   // setSquashY(0.6);
    //   yr = -0.1;
    //   dy = -0.1;
    // }

    // if (level.hasAnyCollision(cx, cy - 1)) {
    //   yr = 1.01;
    //   dy = .1;
    //   // setSquashY(0.6);
    // }
  }

  public function isDead() {
    return this.health <= 0;
  }

  override function update() {
    super.update();
    updateInvincibility();
    updateCollision();
    handleMovement();
    handleFiring();
  }

  public function updateInvincibility() {
    if (isInvincible) {
      if (!cd.has('invincible')) {
        cd.setF('invincible', 5, () -> {
          spr.alpha = 0;
        });
      } else {
        spr.alpha = 0;
      }
    } else {
      spr.alpha = 1;
    }
  }

  function updateCollision() {
    handleCollectible();
    handleEnemyCollision();
  }

  function handleCollectible() {
    var collectible = level.getCollectible(cx, cy);
    if (collectible != null) {
      var collectibleType = Type.getClass(collectible);
      switch (collectibleType) {
        case en.collectibles.FlameUp:
          // Adds flame up to the player
          collectible.destroy();
        case en.collectibles.Gems:
          // Increases the player score when they collide with
          // the element.
          level.score += 1000;
          collectible.destroy();
        case en.collectibles.Heart:
          this.health = M.iclamp(this.health + 1, 0, HEALTH_CAP);
      }
    }
  }

  function handleEnemyCollision() {
    if (level.hasAnyEnemyCollision(cx, cy)) {
      takeDamage();
    }
  }

  override function postUpdate() {
    super.postUpdate();
  }

  public function handleMovement() {
    var left = ct.leftDown();
    var right = ct.rightDown();

    if (left || right) {
      if (left) {
        dx = -MOVE_SPD;
      } else if (right) {
        dx = MOVE_SPD;
      }
    }
  }

  public function handleFiring() {
    var fire = ct.aDown();
    var coords = Boot.ME.s2d.mouseCoords();
    var curX = this.spr.getAbsPos().x;
    var curY = this.spr.getAbsPos().y;
    var res = coords.sub(new Point(curX, curY));
    res.normalize();
    if (fire && !cd.has('Fired')) {
      // Naive Implementation
      // Instead we should just use a queue
      var liveBullet = bulletPool.shift();
      if (liveBullet != null) {
        liveBullet.setPosPixel(this.spr.x, this.spr.y);
        liveBullet.fire(res.toVec(), 0.2, BULLET_CD);
        cd.setS('Fired', 0.1);
        bulletPool.add(liveBullet);
      }
    }
  }

  public function triggerInvincibility() {
    cd.setS('invincibleTime', INVINCIBLE_TIME);
  };

  override function takeDamage(value:Int = 1) {
    if (!isInvincible) {
      Game.ME.camera.shakeS(0.5, 0.5);
      super.takeDamage(value);
      triggerInvincibility();
      this.knockback(0.1, 0.2);
      Assets.damageSnd.play();
    }
  }
}