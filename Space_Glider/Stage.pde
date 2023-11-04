public class Stage implements Program {

  public static final float INTERFACE_MW_BUBBLE_X = 60;
  public static final float INTERFACE_MW_BUBBLE_Y = 740;
  public static final float INTERFACE_MW_BUBBLE_RADIUS = 40;
  public static final float INTERFACE_MW_BUBBLE_TEXT_SIZE = 80;
  public static final float INTERFACE_HP_BAR_X = 120;
  public static final float INTERFACE_HP_BAR_Y = 740;
  public static final float INTERFACE_HP_BAR_WIDTH = 400;
  public static final float INTERFACE_HP_BAR_HEIGHT = 20;
  public static final float INTERFACE_SW_BAR_X = INTERFACE_HP_BAR_X;
  public static final float INTERFACE_SW_BAR_Y = INTERFACE_HP_BAR_Y+INTERFACE_HP_BAR_HEIGHT;
  public static final float INTERFACE_SW_BAR_WIDTH = 300;
  public static final float INTERFACE_SW_BAR_HEIGHT = 10;
  public static final float INTERFACE_SW_BUBBLE_X = 720;
  public static final float INTERFACE_SW_BUBBLE_Y = 720;
  public static final float INTERFACE_SW_BUBBLE_RADIUS = 50;
  public static final float PAUSE_BUTTON_X = 30;
  public static final float PAUSE_BUTTON_Y = 30;
  public static final float PAUSE_MENU_WIDTH = 500;
  public static final float PAUSE_MENU_HEIGHT = 500;
  public static final float PAUSE_MENU_X = 400 - PAUSE_MENU_WIDTH/2;
  public static final float PAUSE_MENU_Y = 80;
  public static final float BOSS_HP_BAR_Y = 50;
  public static final float BOSS_HP_BAR_WIDTH = 600;
  public static final float BOSS_HP_BAR_HEIGHT = 40;

  public static final float COLLECTIBLE_DROP_RATE = 0.075;

  private Set<Button> buttons = new HashSet<Button>();
  private Label pauseMenuHeader;
  private Set<Button> pauseMenuButtons = new HashSet<Button>();
  private Set<Button> wonButtons = new HashSet<Button>();
  private Set<Button> gameoverButtons = new HashSet<Button>();
  private Label messageBox;

  private boolean running = true;
  private boolean gameover = false;
  private boolean won = false;
  private Player p;
  private Queue<EnemyWave> waves = new ArrayDeque<EnemyWave>();

  private List<CollectibleSpawn> colSpawns = new ArrayList<CollectibleSpawn>();

  private Set<Enemy> enemies = new HashSet<Enemy>();
  private Set<AllyBullet> allyBullets = new HashSet<AllyBullet>();
  private Set<EnemyBullet> enemyBullets = new HashSet<EnemyBullet>();
  private Set<Particle> particles = new HashSet<Particle>();
  private Set<Collectible> collectibles = new HashSet<Collectible>();
  private Set<Enemy> addEnemies = new HashSet<Enemy>();
  private Set<AllyBullet> addAllyBullets = new HashSet<AllyBullet>();
  private Set<EnemyBullet> addEnemyBullets = new HashSet<EnemyBullet>();
  private Set<Particle> addParticles = new HashSet<Particle>();
  private Set<Collectible> addCollectibles = new HashSet<Collectible>();
  private Set<Enemy> removeEnemies = new HashSet<Enemy>();
  private Set<AllyBullet> removeAllyBullets = new HashSet<AllyBullet>();
  private Set<EnemyBullet> removeEnemyBullets = new HashSet<EnemyBullet>();
  private Set<Particle> removeParticles = new HashSet<Particle>();
  private Set<Collectible> removeCollectibles = new HashSet<Collectible>();
  private Enemy boss = null;

  private Timer bossDropTimer = new Timer(15000);

  private Background background = new StageBackground1();

  private int time;
  private int totalElapsedTime;
  private int waveElapsedTime;


  public Stage(Program stageInit) {
    initialize(stageInit);
  }

  public Stage(Program stageInit, Program nextStageInit) {
    initialize(stageInit);
    Button nextStage = new Button("NEXT STAGE", candaraBold, width/2, 300);
    nextStage.highlightCol = color(128, 128, 0);
    nextStage.setEvent(nextStageInit);
    wonButtons.add(nextStage);
  }

  private void initialize(Program stageInit) {
    totalElapsedTime = 0;
    waveElapsedTime = 0;
    time = millis();
    p = new Player(width/2, height*7/8);

    initCollectibleSpawns();

    messageBox = new Label("", candaraBoldItalic, width/2, 200);
    messageBox.fontSize = 40;
    messageBox.col = color(255, 128);

    Button pause = new Button("l l", candaraBold, PAUSE_BUTTON_X, PAUSE_BUTTON_Y);
    pause.fontSize = 20;
    pause.borderWidth = 10;
    pause.highlightCol = color(0, 0, 128);
    pause.setEvent(new Program() {
      public Program run(MouseInputs mouseInputs, boolean[] keys) {
        running = !running;
        return null;
      }
    }
    );
    buttons.add(pause);

    pauseMenuHeader = new Label("PAUSED", candaraBold, width/2, 150);
    pauseMenuHeader.fontSize = 50;
    Button cont = new Button("CONTINUE", candaraBold, width/2, 300);
    Button mainmenu = new Button("MAIN MENU", candaraBold, width/2, 500);
    color highlightCol = color(128, 128, 0);
    cont.highlightCol = highlightCol;
    mainmenu.highlightCol = highlightCol;
    cont.setEvent(new Program() {
      public Program run(MouseInputs mouseInputs, boolean[] keys) {
        running = true;
        return null;
      }
    }
    );
    mainmenu.setEvent(mainMenuInitializer);

    pauseMenuButtons.add(cont);
    pauseMenuButtons.add(mainmenu);

    wonButtons.add(mainmenu);
    gameoverButtons.add(mainmenu);

    Button restart = new Button("RESTART", candaraBold, width/2, 400);
    restart.highlightCol = color(128, 128, 0);
    restart.setEvent(stageInit);
    gameoverButtons.add(restart);
    pauseMenuButtons.add(restart);
  }

  private void initCollectibleSpawns() {
    colSpawns.add(new CollectibleSpawn() {
      public Collectible spawn(float x, float y) {
        return new MWLevelUpOrb(x, y);
      }
    }
    );
    colSpawns.add(new CollectibleSpawn() {
      public Collectible spawn(float x, float y) {
        return new DoppelgangerOrb(x, y);
      }
    }
    );
    colSpawns.add(new CollectibleSpawn() {
      public Collectible spawn(float x, float y) {
        return new LightBowOrb(x, y);
      }
    }
    );
  }

  public Program run(MouseInputs mouseInputs, boolean[] keys) {
    Program nextProgram = null;
    int currentTime = millis();
    int elapsedTime = currentTime - time;
    time = currentTime;
    totalElapsedTime += elapsedTime;
    if (running) { 
      waveElapsedTime += elapsedTime;
      EnemyWave currentWave = waves.peek();
      if (currentWave != null && !currentWave.isEmpty()) {
        currentWave.spawnEnemies(waveElapsedTime, enemies);
      } else if (enemies.isEmpty()) {
        if (currentWave != null) {
          waves.poll();
          waveElapsedTime = 0;
        } else {
          won = true;
          messageBox.text = "YOU WON!";
        }
      }

      runObjects(elapsedTime);
      background.run(elapsedTime);
      if (enemies.contains(boss) && bossDropTimer.run(elapsedTime)) {
        spawnDrop();
      }
    }

    background.draw();
    drawObjects();
    drawInterface();
    drawButtons(mouseInputs, buttons);
    messageBox.drawNoBorder();

    if (won) {
      drawButtons(mouseInputs, wonButtons);
    } else if (gameover) {
      drawButtons(mouseInputs, gameoverButtons);
    }

    if (!running) {
      drawPauseMenu(mouseInputs);
    }

    runButtons(mouseInputs, keys, buttons);
    if (keys['p']) {
      running = false;
    }
    if (keys['r']) {
      running = true;
    }
    if (!running) {
      nextProgram = runButtons(mouseInputs, null, pauseMenuButtons);
    } else if (won) {
      nextProgram = runButtons(mouseInputs, null, wonButtons);
    } else if (gameover) {
      nextProgram = runButtons(mouseInputs, null, gameoverButtons);
    }

    mouseInputs.reset(LEFT);
    mouseInputs.reset(RIGHT);
    return nextProgram;
  }

  private void runObjects(int elapsedTime) {
    if (!gameover) {
      p.run(this, elapsedTime);
      addAndRemoveEntities();
      checkGameover();
    }

    for (Collectible c : collectibles) {
      c.run(this);
    }
    addAndRemoveEntities();

    for (Enemy e : enemies) {
      e.run(this, elapsedTime);
    }
    addAndRemoveEntities();

    for (AllyBullet b : allyBullets) {
      b.run(this, elapsedTime);
    }
    addAndRemoveEntities();

    for (EnemyBullet b : enemyBullets) {
      b.run(this, elapsedTime);
    }
    addAndRemoveEntities();

    for (Particle p : particles) {
      p.run(this, elapsedTime);
    }
    addAndRemoveEntities();
  }

  private void addAndRemoveEntities() {
    if (!addEnemies.isEmpty()) {
      enemies.addAll(addEnemies);
      addEnemies.clear();
    }
    if (!removeEnemies.isEmpty()) {
      enemies.removeAll(removeEnemies);
      giveKillDrops(removeEnemies);
      explodeAll(new HashSet<Explodable>(removeEnemies));
      removeEnemies.clear();
    }
    if (!addAllyBullets.isEmpty()) {
      allyBullets.addAll(addAllyBullets);
      addAllyBullets.clear();
    }
    if (!removeAllyBullets.isEmpty()) {
      allyBullets.removeAll(removeAllyBullets);
      removeAllyBullets.clear();
    }
    if (!addEnemyBullets.isEmpty()) {
      enemyBullets.addAll(addEnemyBullets);
      addEnemyBullets.clear();
    }
    if (!removeEnemyBullets.isEmpty()) {
      enemyBullets.removeAll(removeEnemyBullets);
      removeEnemyBullets.clear();
    }
    if (!addParticles.isEmpty()) {
      particles.addAll(addParticles);
      addParticles.clear();
    }
    if (!removeParticles.isEmpty()) {
      particles.removeAll(removeParticles);
      removeParticles.clear();
    }
    if (!addCollectibles.isEmpty()) {
      collectibles.addAll(addCollectibles);
      addCollectibles.clear();
    }
    if (!removeCollectibles.isEmpty()) {
      collectibles.removeAll(removeCollectibles);
      removeCollectibles.clear();
    }
  }

  private void checkGameover() {
    if (p.isDead()) {
      p.explode(this);
      gameover = true;
      messageBox.text = "GAME OVER";
    }
  }

  private Program runButton(MouseInputs mouseInputs, boolean[] keys, Button b) {
    PVector released = mouseInputs.getLeftReleased();
    if (released == null) {
      return null;
    }
    if (b.isOn(released.x, released.y)) {
      return b.doEvent(mouseInputs, keys);
    }

    return null;
  }

  private Program runButtons(MouseInputs mouseInputs, boolean[] keys, Set<Button> buttons) {
    for (Button b : buttons) {
      Program next = runButton(mouseInputs, keys, b);
      if (next != null) {
        return next;
      }
    }

    return null;
  }

  private void explodeAll(Set<Explodable> exps) {
    for (Explodable exp : exps) {
      exp.explode(this);
    }
  }

  private void giveKillDrops(Set<Enemy> enemies) {
    for (Enemy e : enemies) {
      if (random(1.0) <= COLLECTIBLE_DROP_RATE) {
        collectibles.add(colSpawns.get(int(random(colSpawns.size()))).spawn(e.pos.x, e.pos.y));
      }
    }
  }

  private void spawnDrop() {
    collectibles.add(colSpawns.get(int(random(colSpawns.size()))).spawn(random(width), 0));
  }

  private void drawObjects() {

    for (Enemy e : enemies) {
      e.draw();
      //e.drawFillHitbox();
    }
    if (!gameover) {
      p.draw(this);
    }
    //p.drawFillHitbox();

    for (Collectible c : collectibles) {
      c.draw();
    }

    for (Particle p : particles) {
      p.draw();
    }

    for (AllyBullet b : allyBullets) {
      b.draw();
    }

    for (EnemyBullet b : enemyBullets) {
      b.draw();
    }
  }

  private void drawButtons(MouseInputs mouseInputs, Set<Button> buttons) {
    PVector cursor = mouseInputs.getCursor();
    for (Button b : buttons) {
      if (b.isOn(cursor.x, cursor.y)) {
        b.drawHighlight();
      } else {
        b.draw();
      }
    }
  }

  private void drawButton(MouseInputs mouseInputs, Button b) {
    PVector cursor = mouseInputs.getCursor();
    if (b.isOn(cursor.x, cursor.y)) {
      b.drawHighlight();
    } else {
      b.draw();
    }
  }

  private void drawPauseMenu(MouseInputs mouseInputs) {
    strokeWeight(5);
    stroke(192);
    fill(128, 128, 255, 128);
    rect(PAUSE_MENU_X, PAUSE_MENU_Y, PAUSE_MENU_WIDTH, PAUSE_MENU_HEIGHT);

    pauseMenuHeader.drawNoBorder();

    PVector cursor = mouseInputs.getCursor();
    for (Button b : pauseMenuButtons) {
      if (b.isOn(cursor.x, cursor.y)) {
        b.drawHighlight();
      } else {
        b.draw();
      }
    }
  }

  public void drawInterface() {
    float hp = p.hp < 0 ? 0 : p.hp;
    float sw = p.specialRemaining();
    int mwLV = p.mw.level;

    noFill();
    strokeWeight(3);
    stroke(255, 128);
    ellipse(INTERFACE_MW_BUBBLE_X, INTERFACE_MW_BUBBLE_Y, INTERFACE_MW_BUBBLE_RADIUS*2, INTERFACE_MW_BUBBLE_RADIUS*2);

    fill(0, 255, 0, 128);
    noStroke();
    rect(INTERFACE_HP_BAR_X, INTERFACE_HP_BAR_Y-INTERFACE_HP_BAR_HEIGHT/2, INTERFACE_HP_BAR_WIDTH*hp/p.maxHP, INTERFACE_HP_BAR_HEIGHT);
    noFill();
    strokeWeight(3);
    stroke(255, 128);
    rect(INTERFACE_HP_BAR_X, INTERFACE_HP_BAR_Y-INTERFACE_HP_BAR_HEIGHT/2, INTERFACE_HP_BAR_WIDTH, INTERFACE_HP_BAR_HEIGHT);

    fill(0, 0, 255, 128);
    noStroke();
    rect(INTERFACE_SW_BAR_X, INTERFACE_SW_BAR_Y-INTERFACE_SW_BAR_HEIGHT/2, INTERFACE_SW_BAR_WIDTH*sw/100, INTERFACE_SW_BAR_HEIGHT);
    noFill();
    strokeWeight(3);
    stroke(255, 128);
    rect(INTERFACE_SW_BAR_X, INTERFACE_SW_BAR_Y-INTERFACE_SW_BAR_HEIGHT/2, INTERFACE_SW_BAR_WIDTH, INTERFACE_SW_BAR_HEIGHT);

    pushMatrix();
    translate(INTERFACE_SW_BUBBLE_X, INTERFACE_SW_BUBBLE_Y);
    noFill();
    strokeWeight(3);
    stroke(255, 128);
    ellipse(0, 0, INTERFACE_SW_BUBBLE_RADIUS*2, INTERFACE_SW_BUBBLE_RADIUS*2);
    p.drawMiniatureSpecialWeapon();
    popMatrix();



    textFont(candaraBold);
    textSize(INTERFACE_MW_BUBBLE_TEXT_SIZE);
    textAlign(CENTER, CENTER);
    fill(128, 128, 255, 128);
    text(mwLV, INTERFACE_MW_BUBBLE_X, INTERFACE_MW_BUBBLE_Y-INTERFACE_MW_BUBBLE_RADIUS/3);

    if (enemies.contains(boss)) {

      fill(255, 0, 0, 128);
      noStroke();
      rect(width/2-BOSS_HP_BAR_WIDTH/2, BOSS_HP_BAR_Y-BOSS_HP_BAR_HEIGHT/2, BOSS_HP_BAR_WIDTH*boss.hp/boss.maxHP(), BOSS_HP_BAR_HEIGHT);
      noFill();
      strokeWeight(3);
      stroke(255, 128);
      rect(width/2-BOSS_HP_BAR_WIDTH/2, BOSS_HP_BAR_Y-BOSS_HP_BAR_HEIGHT/2, BOSS_HP_BAR_WIDTH, BOSS_HP_BAR_HEIGHT);
    }
  }

  public void addEnemy(Enemy e) {
    enemies.add(e);
  }

  public void addEnemyWave(EnemyWave w) {
    waves.offer(w);
  }

  public void setBackground(Background b) {
    background = b;
  }

  public void setBoss(Enemy e) {
    boss = e;
  }
}
