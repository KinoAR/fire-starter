package en.enemy;

/**
 * Peeks out the window, firing bullets
 * at the player in order to protect
 *  the building.
 */
class Peeker extends Enemy {
  override function setupGraphics() {
    var g = this.spr.createGraphics();
    g.beginFill(0x2A3CC0);
    var size = Const.GRID;
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 8;
  }
}