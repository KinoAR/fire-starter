package en;

class Collectible extends Entity {
  public function new(x:Int, y:Int) {
    super(x, y);
    setupGraphic();
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    g.beginFill(0x0aff);
    g.drawRect(0, 0, size, size);
    g.endFill();
  }
}