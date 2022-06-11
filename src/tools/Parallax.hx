package tools;

import h2d.Tile;

/**
 * Utility class for creating parallax
 * scrolling backgrounds at a specified width
 * and height.
 */
class Parallax extends h2d.Graphics {
  public var width:Int;
  public var height:Int;

  public function new(?parent:h2d.Object, tile:Tile, width:Int, height:Int) {
    super(parent);
    this.tile = tile;
    tileWrap = true;
    this.width = width;
    this.height = height;
  }

  /**
   * Renders the parallax into the container
   */
  public function render() {
    beginTileFill(tile);
    var xStep = Std.int(width / tile.width);
    var yStep = Std.int(height / tile.height);
    var sizeX = tile.width;
    var sizeY = tile.height;
    for (x in 0...xStep) {
      for (y in 0...yStep) {
        drawTile(x * sizeX, y * sizeY, tile);
      }
    }
    endFill();
  }

  /**
   * Scrolls the texture by the specified amount.
   * @param dx 
   * @param dy 
   */
  public function scrollDiscrete(dx:Float, dy:Float) {
    this.tile.scrollDiscrete(dx, dy);
  }
}