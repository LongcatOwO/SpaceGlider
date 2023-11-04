class Mothership extends Enemy {
  public static final float COLLISION_DAMAGE = 40;
  public static final float DRAW_SCALE = 1;
  public static final float HITBOX_WIDTH = 600;
  public static final float HITBOX_HEIGHT = 200;
  public static final float MAX_HP = 3000;
  public static final float TURRET1_X = -200;
  public static final float TURRET2_X = 200;
  public static final int TURRET1_INTERVAL = 400;
  public static final int TURRET2_INTERVAL = 600;
  public static final int TURRET1_FIRE_TIME = 2*fr;
  public static final int TURRET2_FIRE_TIME = 4*fr;
  public static final int TURRET1_REST_TIME = 6*fr;
  public static final int TURRET2_REST_TIME = 8*fr;
  public static final int MINION_SPAWN_INTERVAL = 5000;
  public static final float EXPLOSION_RADIUS = 150;

  private int moveTime;
  private Timer t1Timer = new Timer(TURRET1_INTERVAL);
  private Timer t2Timer = new Timer(TURRET2_INTERVAL);
  private boolean t1Firing = false;
  private boolean t2Firing = false;
  private int t1Time;
  private int t2Time;
  private float t1Angle = 0;
  private float t2Angle = 0;
  private Timer spawnMinionTimer = new Timer(MINION_SPAWN_INTERVAL);
  private PVector vel;

  public Mothership() {
    super(400, -150);
    moveTime = (int)(250/(150.0/fr))+1;
    vel = new PVector(0, 250.0/moveTime);
  }

  public void run(Stage s, int elapsedTime) {
    if (moveTime > 0) {
      pos.add(vel);
      moveTime--;
    } else {
      if (spawnMinionTimer.run(elapsedTime)){
        for (int i = 0; i < 3; i++){
          spawnMinion(s);
        }
      }
      if (t1Firing && t1Timer.run(elapsedTime)) {
        fireTurret1(s);
        t1Angle -= radians(3);
      }
      if (t2Firing && t2Timer.run(elapsedTime)) {
        fireTurret2(s);
        t2Angle += radians(10);
      }

      t1Time--;
      t2Time--;
      
      if (t1Time <= 0) {
        if (t1Firing) {
          t1Time = TURRET1_REST_TIME;
        } else {
          t1Time = TURRET1_FIRE_TIME;
          t1Angle = PI/2;
          t1Timer = new Timer(TURRET1_INTERVAL);
        }
        t1Firing = !t1Firing;
      }
      if (t2Time <= 0) {
        if (t2Firing) {
          t2Time = TURRET2_REST_TIME;
        } else {
          t2Time = TURRET2_FIRE_TIME;
          t2Angle = 0;
          t2Timer = new Timer(TURRET2_INTERVAL);
        }
        t2Firing = !t2Firing;
      }
    }
    runCollision(s);
  }
  
  private void spawnMinion(Stage s){
    int rand = int(random(2));
    float x = random(200, 600);
    if (rand == 0){
      s.addEnemies.add(new EnemyShooter(pos.x, pos.y, x, 250));
    }
    else if (rand == 1){
      s.addEnemies.add(new EnemyShielder(pos.x, pos.y, x, 300));
    }
  }

  private void fireTurret1(Stage s) {
    int n = 4;
    float angleDif = radians(20);
    float bulletAngle = t1Angle - angleDif*(n-1)/2;
    for (int i = 0; i < 4; i++) {
      s.addEnemyBullets.add(new SmallEnemyBullet2(pos.x+TURRET1_X, pos.y, bulletAngle));
      bulletAngle += angleDif;
    }
  }

  private void fireTurret2(Stage s) {
    int n = 6;
    for (int i = 0; i < 6; i++) {
      s.addEnemyBullets.add(new SmallEnemyBullet2(pos.x+TURRET2_X, pos.y, t2Angle+i*TWO_PI/n));
    }
  }

  public void explode(Stage s) {
    s.addParticles.add(new SmallExplosion(pos, EXPLOSION_RADIUS, s.addParticles));
  }

  public float collisionDamage() {
    return COLLISION_DAMAGE;
  }

  public Hitbox hitbox() {
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public float maxHP() {
    return MAX_HP;
  }

  public float drawScale() {
    return DRAW_SCALE;
  }

  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    strokeWeight(5);
    stroke(128);
    fill(196);
    beginShape();
    vertex(-300, -70);
    vertex(-250, -100);
    vertex(250, -100);
    vertex(300, -70);
    vertex(300, 70);
    vertex(250, 100);
    vertex(-250, 100);
    vertex(-300, 70);
    vertex(-300, -70);
    endShape();
    
    noStroke();
    fill(0);
    rect(-30, -30, 60, 60);

    pushMatrix();
    translate(TURRET1_X, 0);
    strokeWeight(8);
    stroke(0, 128, 0);
    fill(0, 255, 0);
    ellipse(0, 0, 50, 50);
    noStroke();
    fill(0);
    ellipse(0, 0, 30, 30);
    popMatrix();
    
    pushMatrix();
    translate(TURRET2_X, 0);
    strokeWeight(8);
    stroke(128, 128, 0);
    fill(255, 255, 0);
    ellipse(0, 0, 50, 50);
    noStroke();
    fill(0);
    ellipse(0, 0, 30, 30);
    popMatrix();
    
    popMatrix();
  }
}
