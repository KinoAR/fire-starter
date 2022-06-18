import en.collectibles.FlameUp;
import en.collectibles.Gems;
import hxd.Timer;
import scn.GameOver;
import scn.Pause;
import en.enemy.Collector;
import en.enemy.Peeker;
import en.enemy.Enemy;
import en.Player;
import en.Collectible;

class Level extends dn.Process {
  var game(get, never):Game;

  inline function get_game()
    return Game.ME;

  var fx(get, never):Fx;

  inline function get_fx()
    return Game.ME.fx;

  /** Level grid-based width**/
  public var cWid(get, never):Int;

  inline function get_cWid()
    return 16;

  /** Level grid-based height **/
  public var cHei(get, never):Int;

  inline function get_cHei()
    return 16;

  /** Level pixel width**/
  public var pxWid(get, never):Int;

  inline function get_pxWid()
    return cWid * Const.GRID;

  /** Level pixel height**/
  public var pxHei(get, never):Int;

  inline function get_pxHei()
    return cHei * Const.GRID;

  var invalidated = true;

  public var scnPause:Pause;
  public var collectibles:Group<Collectible>;
  public var enemies:Group<Enemy>;
  public var player:Player;

  public var score:Int;
  public var highScore:Int;

  public var timer:Float;
  public var bg:h2d.Graphics;
  public var data:LDTkProj_Level;

  // public var data:Ldtk

  public function new(?level:LDTkProj_Level) {
    super(Game.ME);
    if (level != null) {
      this.data = level;
    }
    createRootInLayers(Game.ME.scroller, Const.DP_BG);
    createGroups();
    createEntities();
  }

  /** TRUE if given coords are in level bounds **/
  public inline function isValid(cx, cy)
    return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

  /** Gets the integer ID of a given level grid coord **/
  public inline function coordId(cx, cy)
    return cx + cy * cWid;

  /** Ask for a level render that will only happen at the end of the current frame. **/
  public inline function invalidate() {
    invalidated = true;
  }

  // Setup Functions

  public function createGroups() {
    collectibles = new Group<Collectible>();
    enemies = new Group<Enemy>();
  }

  public function createEntities() {
    for (ePlayer in data.l_Entities.all_Player) {
      player = new Player(ePlayer.cx, ePlayer.cy);
    }

    // Collectibles
    for (eFlameUp in data.l_Entities.all_FlameUp) {
      collectibles.add(new FlameUp(eFlameUp.cx, eFlameUp.cy));
    }

    for (eGem in data.l_Entities.all_Gems) {
      collectibles.add(new Gems(eGem.cx, eGem.cy));
    }

    // Enemies
    for (eEnemy in data.l_Entities.all_BasicEnemy) {
      enemies.add(new Enemy(eEnemy.cx, eEnemy.cy, eEnemy.f_Depth));
    }

    for (eCollector in data.l_Entities.all_Collector) {
      enemies.add(new Collector(eCollector.cx, eCollector.cy,
        eCollector.f_Depth));
    }

    for (ePeeker in data.l_Entities.all_Peeker) {
      enemies.add(new Peeker(ePeeker.cx, ePeeker.cy, ePeeker.f_Depth));
    }
  }

  // Collision Functions

  public function hasAnyCollision(cx:Int, cy:Int) {
    return false;
  }

  public function hasAnyEnemyCollision(cx:Int, cy:Int) {
    for (enemy in enemies) {
      if (enemy.cx == cx && enemy.cy == cy && enemy.isAlive()) {
        return true;
      }
    }
    return false;
  }

  public function getCollectible(cx:Int, cy:Int) {
    for (collectible in collectibles) {
      if (collectible.cx == cx && collectible.cy == cy && collectible.isAlive()) {
        return collectible;
      }
    }
    return null;
  }

  /**
   * Handles pausing the game
   */
  public function handlePause() {
    if (game.ca.isKeyboardPressed(K.ESCAPE)) {
      Assets.pauseIn.play();
      this.pause();
      scnPause = new Pause();
    }
  }

  public function handleGameOver() {
    if (player.isDead() && Game.ME.gameLives <= 0) {
      this.pause();
      new GameOver();
    } else if (player.isDead()) {
      Game.ME.gameLives--;
      // Revive Player;
      player.triggerInvincibility();
      player.health = 3;
    }
  }

  public function handleTimer() {
    timer += Timer.elapsedTime;
    game.invalidateHud();
  }

  function render() {
    // Placeholder level render
    root.removeChildren();
    for (cx in 0...cWid)
      for (cy in 0...cHei) {
        var g = new h2d.Graphics(root);
        if (cx == 0
          || cy == 0
          || cx == cWid - 1
          || cy == cHei - 1) g.beginFill(0xffcc00); else
          g.beginFill(Color.randomColor(rnd(0, 1), 0.5, 0.4));
        g.drawRect(cx * Const.GRID, cy * Const.GRID, Const.GRID, Const.GRID);
      }
  }

  override function update() {
    super.update();
    handlePause();
    handleGameOver();
  }

  override function postUpdate() {
    super.postUpdate();

    if (invalidated) {
      invalidated = false;
      render();
    }
  }

  override function onDispose() {
    player.dispose();

    for (collectible in collectibles) {
      collectible.destroy();
    }

    for (enemy in enemies) {
      enemy.destroy();
    }
  }
}