class EnemyShielder extends Enemy {
  public static final float MAX_HP = 50;
  public static final float COLLISION_DAMAGE = 20;
  public static final float DRAW_SCALE = 0.35;
  public static final float HITBOX_WIDTH = 200*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 100*DRAW_SCALE;
  public static final float SPEED = 100.0/fr;
  public static final float EXPLOSION_RADIUS = 80;

  int time;
  PVector vel;

  public EnemyShielder (float x, float y, float dx, float dy) {
    super(x, y);
    hp = MAX_HP;
    float d = dist(x, y, dx, dy);
    time = (int)(d/(SPEED*5))+1;
    vel = new PVector((dx - x)/time, (dy - y)/time);
  }

  public void run(Stage s, int elapsedTime) {
    if (time > 0) {
      pos.add(vel);
      time--;
    }
    runCollision(s);
  }

  public void explode(Stage s) {
    s.addParticles.add(new SmallExplosion(pos, EXPLOSION_RADIUS, s.addParticles));
  }

  public float collisionDamage() {
    return COLLISION_DAMAGE;
  }

  public float maxHP() {
    return MAX_HP;
  }

  public float drawScale() {
    return DRAW_SCALE;
  }

  public Hitbox hitbox() {
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public void draw() {
    pushMatrix();
    
    translate(pos.x, pos.y);
    scale(DRAW_SCALE);
    stroke(128);
    strokeWeight(10);
    line(-100, -50, 100, 50);
    line(-100, 50, 100, -50);
    strokeWeight(10);
    stroke(196);
    line(-100, -50, -100, -20);
    line(100, 50, 100, 20);
    line(-100, 50, -100, 20);
    line(100, -50, 100, -20);
    line(-100, -50, 100, -50);
    line(-100, 50, 100, 50);

    fill(255, 0, 0);
    strokeWeight(3);
    stroke(128, 0, 0);
    ellipse(0, 0, 80, 80);
    
    popMatrix();
  }
}
