class EnemyCrasher extends Enemy {
  public static final float MAX_HP = 4;
  public static final float COLLISION_DAMAGE = 20;
  public static final float DRAW_SCALE = 0.3;
  public static final float HITBOX_WIDTH = 90*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 90*DRAW_SCALE;
  public static final float SPEED = 350.0/fr;
  public static final float EXPLOSION_RADIUS = 60;

  private PVector vel;
  private float turnRate;

  public EnemyCrasher(float x, float y, float angle, float turnPerSec){
    super(x, y);
    vel = new PVector(cos(angle), sin(angle));
    vel.mult(SPEED);
    turnRate = turnPerSec/fr;
  }

  public void run(Stage s, int elapsedTime) {
    pos.add(vel);
    vel.rotate(turnRate);
    runCollision(s);
    if (outOfBound(pos.x, pos.y, 100, 100)){
      s.removeEnemies.add(this);
    }
  }

  public void explode(Stage s) {
    s.addParticles.add(new SmallExplosion(pos, EXPLOSION_RADIUS, s.addParticles));
  }
  
  public float moveAngle(){
    return atan2(vel.y, vel.x)-PI/2;
  }

  public float collisionDamage() {
    return COLLISION_DAMAGE;
  }

  public float maxHP() {
    return MAX_HP;
  }

  public Hitbox hitbox() {
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public float drawScale() {
    return DRAW_SCALE;
  }

  public void draw() {
    pushMatrix();
    
    translate(pos.x, pos.y);
    rotate(moveAngle());
    scale(DRAW_SCALE);

    fill(96, 96, 192);
    stroke(64, 64, 128);
    strokeWeight(5);
    beginShape();
    vertex(-60, -40);
    vertex(60, -40);
    vertex(50, 0);
    vertex(30, 10);
    vertex(-30, 10);
    vertex(-50, 0);
    vertex(-60, -40);
    endShape();

    fill(128, 128, 255);
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
