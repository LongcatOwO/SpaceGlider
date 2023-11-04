class EnemyShooter extends Enemy {
  public static final float MAX_HP = 10;
  public static final float DRAW_SCALE = 0.2;
  public static final float HITBOX_WIDTH = 200*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 100*DRAW_SCALE;
  public static final int SHOOT_INTERVAL = 2000;
  public static final float EXPLOSION_RADIUS = 60;
  public static final float COLLISION_DAMAGE = 20;

  private float movePhase = PI/2;
  private float moveRadius = 50;
  private float speed = 100/frameRate;
  private PVector vel;
  private PVector loc;
  private int time;
  private Timer shootTimer;


  public EnemyShooter(PVector start, PVector stop) {
    super(start);
    float d = dist(pos.x, pos.y, stop.x, stop.y);
    time = (int)(d/(speed*5))+1;
    vel = new PVector((stop.x-start.x)/time, (stop.y-start.y)/time);
    loc = stop;
    shootTimer = new Timer(SHOOT_INTERVAL);
  }
  
  public EnemyShooter(float x, float y, float dx, float dy){
    super(x, y);
    float d = dist(x, y, dx, dy);
    time = (int)(d/(speed*5))+1;
    vel = new PVector((dx - x)/time, (dy - y)/time);
    loc = new PVector(dx, dy);
    shootTimer = new Timer(SHOOT_INTERVAL);
  }

  public float drawScale() { 
    return DRAW_SCALE;
  }

  public Hitbox hitbox() { 
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public float collisionDamage(){
    return COLLISION_DAMAGE;
  }

  public float maxHP() { 
    return MAX_HP;
  }

  public void setSpeed(float speed) {
    this.speed = speed/frameRate;
  }

  public void setMoveRadius(float radius) {
    moveRadius = radius;
  }

  public void run(Stage s, int elapsedTime) {
    if (time > 0) {
      pos.add(vel);
      time--;
    } else {
      if (shootTimer.run(elapsedTime)){
        shoot(s);
      }
      if (moveRadius!=0) {
        movePhase += speed/moveRadius;
        if (movePhase >= TWO_PI) {
          movePhase -= TWO_PI;
        }
        pos.x = cos(movePhase)*moveRadius+loc.x;
      }
    }
    runCollision(s);
  }
  
  public void explode(Stage s){
    s.addParticles.add(new SmallExplosion(pos, EXPLOSION_RADIUS, s.addParticles));
  }
  
  public void shoot(Stage s){
    s.addEnemyBullets.add(new SmallEnemyBullet(pos, s.p.pos));
  }

  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    scale(DRAW_SCALE);

    fill(96, 192, 96);
    stroke(64, 128, 64);
    strokeWeight(5);
    beginShape();
    vertex(-100, -40);
    vertex(100, -40);
    vertex(90, -20);
    vertex(30, 10);
    vertex(-30, 10);
    vertex(-90, -20);
    vertex(-100, -40);
    endShape();

    fill(128, 255, 128);
    stroke(0);
    beginShape();
    vertex(-30, -40);
    vertex(30, -40);
    vertex(30, 10);
    vertex(0, 60);
    vertex(-30, 10);
    vertex(-30, -40);
    endShape();
    popMatrix();
  }
}
