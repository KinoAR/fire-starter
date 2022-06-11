package en;

class BaseEnt extends Entity {
  public var health:Int = 3;

  public function setupGraphics() {}

  public function takeDamage(value:Int = 1) {
    this.health -= value;
  }
}