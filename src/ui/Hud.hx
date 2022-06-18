package ui;

import ext.HTools.smallText;

class Hud extends dn.Process {
  public var game(get, never):Game;

  inline function get_game()
    return Game.ME;

  public var fx(get, never):Fx;

  inline function get_fx()
    return Game.ME.fx;

  public var level(get, never):Level;

  inline function get_level()
    return Game.ME.level;

  var flow:h2d.Flow;
  var invalidated = true;

  var livesText:h2d.Text;
  var timerText:h2d.Text;
  var scoreText:h2d.Text;
  var highScoreText:h2d.Text;

  public function new() {
    super(Game.ME);

    createRootInLayers(game.root, Const.DP_UI);
    root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering

    flow = new h2d.Flow(root);
    setupFlow();
  }

  public function setupFlow() {
    flow.horizontalAlign = Middle;
    flow.layout = Horizontal;
    flow.paddingLeft = 12;
    flow.horizontalSpacing = 12;
    setupLives();
    setupScore();
    setupTimer();
  }

  function setupLives() {
    livesText = smallText('Lives ${Game.ME.gameLives}', flow);
  }

  function setupScore() {
    scoreText = smallText('Score 0', flow);
    highScoreText = smallText('High Score 0', flow);
  }

  function setupTimer() {
    timerText = smallText('Time 0', flow);
  }

  override function onResize() {
    super.onResize();
    root.setScale(Const.UI_SCALE);
  }

  public inline function invalidate()
    invalidated = true;

  function render() {
    if (level != null) {
      renderScore();
      renderTime();
    }
  }

  function renderLives() {
    livesText.text = 'Lives ${Game.ME.gameLives}';
  }

  function renderScore() {
    scoreText.text = 'Score ${level.score}';
    highScoreText.text = 'High Score ${level.highScore}';
  }

  function renderTime() {
    timerText.text = 'Time ${level.timer}';
  }

  override function postUpdate() {
    super.postUpdate();

    if (invalidated) {
      invalidated = false;
      render();
    }
  }

  public function hide() {
    flow.visible = false;
  }

  public function show() {
    flow.visible = true;
  }
}