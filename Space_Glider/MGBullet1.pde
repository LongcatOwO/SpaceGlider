class MGBullet1 extends AllyBullet {
  public static final float DAMAGE = 2;
  public static final float DRAW_SCALE = 1;
  public static final float HITBOX_WIDTH = 5*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 20*DRAW_SCALE;
  public static final float SPEED = 2000/fr;
  
  public MGBullet1(PVector pos){
    super(pos);
  }
  
  public MGBullet1(float x, float y){
    super(x, y);
  }

  public void run(Stage s, int elapsedTime) {
    move(s);
    runCollision(s);
  }
  
  public void move(Stage s){
    pos.y -= SPEED;
    if (pos.y < -20){
      s.removeAllyBullets.add(this);
    }
  }

  public float collisionDamage() {
    return DAMAGE;
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

    fill(0, 128, 255);
    noStroke();
    ellipse(0, 0, 5, 20);
    fill(128, 128, 255);
    ellipse(0, 0, 3, 15);

    popMatrix();
  }
}
