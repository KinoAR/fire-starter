package en.enemy;

class Enemy extends BaseEnt {
  /**
   * The depth of the enemy on the screen.
   * this controls where they will appear in the level layout.
   */
  public var depth:Int;

  public function new(x:Int, y:Int, depth:Int = 0) {
    super(x, y);
    this.depth = depth;
  }
}