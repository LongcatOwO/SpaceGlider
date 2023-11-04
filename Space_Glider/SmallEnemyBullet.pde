class SmallEnemyBullet extends EnemyBullet {
  public static final float DAMAGE = 10;
  public static final float DRAW_SCALE = 1;
  public static final float HITBOX_WIDTH = 10*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 10*DRAW_SCALE;
  public static final float SPEED = 250.0/fr;

  private PVector vel;

  public SmallEnemyBullet(float x, float y, float targetX, float targetY) {
    super(x, y);
    vel = new PVector(targetX - x, targetY - y);
    vel.normalize();
    vel.mult(SPEED);
  }

  public SmallEnemyBullet(PVector pos, PVector target) {
    super(pos);
    vel = new PVector(target.x - pos.x, target.y - pos.y);
    vel.normalize();
    vel.mult(SPEED);
  }
  
  public SmallEnemyBullet(float x, float y, float angle) {
    super(x, y);
    vel = new PVector(cos(angle), sin(angle));
    vel.mult(SPEED);
  }

  public void run(Stage s, int elapsedTime) {
    move(s);
    runCollision(s);
  }
  
  public void move(Stage s){
    pos.add(vel);
    if (outOfBound(pos.x, pos.y, HITBOX_WIDTH , HITBOX_HEIGHT)){
      s.removeEnemyBullets.add(this);
    }
  }
  
  public float collisionDamage(){
    return DAMAGE;
  }
  
  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    scale(DRAW_SCALE);

    strokeWeight(3);
    stroke(255, 0, 0);
    fill(255);
    ellipse(0, 0, 10, 10);

    popMatrix();
  }

  public Hitbox hitbox() {
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public float drawScale() {
    return DRAW_SCALE;
  }
}
