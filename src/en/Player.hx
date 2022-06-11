package en;

import dn.legacy.Controller.ControllerAccess;

class Player extends BaseEnt {
  public var ct:ControllerAccess;

  public static inline var INVINCIBLE_TIME:Float = 3;

  public static inline var MOVE_SPD:Float = .1;
  public static inline var JUMP_FORCE:Float = 1;

  public var isInvincible(get, null):Bool;

  public inline function get_isInvincible() {
    return cd.has('invincbleTime');
  }

  public function new(x:Int, y:Int) {
    super(x, y);
    setup();
  }

  public function setup() {
    ct = Main.ME.controller.createAccess('player');

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

  override function update() {
    super.update();
    updateInvincibility();
    updateCollision();
    handleMovement();
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

  function updateCollision() {}

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

  override function takeDamage(value:Int = 1) {
    if (!isInvincible) {
      Game.ME.camera.shakeS(0.5, 0.5);
      super.takeDamage(value);
      cd.setS('invincibleTime', INVINCIBLE_TIME);
      this.knockback(0.1, 0.2);
      Assets.damageSnd.play();
    }
  }
}