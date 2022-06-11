package en.enemy;

/**
 * While the place is burning,
 * they grab whatever they can in order
 * to make sure the items are preserved before
 * everything goes up in smoke.
 * 
 * Moves back and forth collecting stuff
 */
class Collector extends Enemy {
  public static inline var MOVE_SPD:Float = .1;

  /**
   * Whether the enemy should flip their direction or not.
   * This value is set to 1 or - 1.
   */
  public var flip:Int = 1;

  override function setupGraphics() {
    var g = this.spr.createGraphics();
    g.beginFill(0xA859EF);
    var size = Const.GRID;
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 8;
  }

  override function update() {
    // handleGravity();
    super.update();
    handleMovement();
  }

  public function handleGravity() {
    dy += .098;
  }

  override function onPreStepX() {
    super.onPreStepX();
    var flippable = false;
    if (level.hasAnyCollision(cx + 1,
      cy - 1) && xr >= 0.7) // Handle squash and stretch for entities in the game
    {
      xr = 0.5;
      dx = 0;
      setSquashY(0.6);
      flippable = true;
    }

    if (level.hasAnyCollision(cx - 1, cy - 1) && xr <= 0.3) {
      xr = 0.3;
      dx = 0;
      setSquashY(0.6);
      flippable = true;
    }
    if (flippable) {
      flipX();
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
  }

  public function handleMovement() {
    dx = MOVE_SPD * flip;
  }

  public function flipX() {
    flip *= -1;
  }
}