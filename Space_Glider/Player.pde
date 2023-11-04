class Player extends Collidable implements Explodable{
  public static final float DRAW_SCALE = 0.3;
  public static final float HITBOX_WIDTH = 100*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 80*DRAW_SCALE;
  public static final float SPEED = 350/fr;
  public static final int HIT_INVINCIBILITY_TIME = 2000;
  public static final int BLINK_INTERVAL = 100;
  public static final float COLLISION_DAMAGE = 20;
  public static final float MAX_HP = 100;
  public static final float EXPLOSION_RADIUS = 100;

  private float maxHP = MAX_HP;
  private float hp = maxHP;
  private MainWeapon mw;
  private SpecialWeapon sw;

  private boolean invincibility = false;
  private boolean blink = false;

  private Timer invncTimer = null;
  private Timer blinkTimer = null;



  public Player(float x, float y) {
    super(x, y);
    mw = new MachineGun();

  }

  public void run(Stage s, int elapsedTime) {
    move();
    mw.run(pos, s, elapsedTime);
    if (invncTimer != null && invncTimer.run(elapsedTime)) {
      invncTimer = null;
      blinkTimer = null;
      invincibility = false;
      blink = false;
    }
    if (blinkTimer != null && blinkTimer.run(elapsedTime)) {
      blink = !blink;
    }
    if (sw != null) {
      sw.run(s, elapsedTime);
      if (sw.remainingPower() <= 0){
        sw = null;
      }
    }
    
  }
  
  public float specialRemaining(){
    if (sw == null){
      return 0;
    }
    return sw.remainingPower();
  }

  public boolean checkHit(EnemyBullet b) {
    if (sw != null) {
      boolean hitSW = sw.checkHit(b);
      if (hitSW) {
        return true;
      }
    }
    if (hitbox().intersect(b.hitbox())) {
      return hit(b.collisionDamage());
    }

    return false;
  }

  public boolean checkHit(Enemy e) {
    if (sw != null) {
      boolean hitSW = sw.checkHit(e);
      if (hitSW) {
        return true;
      }
    }
    if (hitbox().intersect(e.hitbox())) {
      return hit(e.collisionDamage());
    }
    return false;
  }

  public boolean hit(float damage) {
    if (!invincibility) {
      hp -= damage;
      invincibility = true;
      blink = true;
      invncTimer = new Timer(HIT_INVINCIBILITY_TIME);
      blinkTimer = new Timer(BLINK_INTERVAL);
      return true;
    }
    return false;
  }

  public boolean isDead() {
    return hp <= 0;
  }
  
  public void explode(Stage s){
    s.addParticles.add(new SmallExplosion(pos, EXPLOSION_RADIUS, s.addParticles));
  }

  public void move() {
    if (keys['w']) { 
      pos.y -= SPEED;
      if (pos.y < 0) {
        pos.y += SPEED;
      }
    }
    if (keys['s']) { 
      pos.y += SPEED;
      if (pos.y > height) {
        pos.y -= SPEED;
      }
    }
    if (keys['a']) { 
      pos.x -= SPEED;
      if (pos.x < 0) {
        pos.x += SPEED;
      }
    }
    if (keys['d']) { 
      pos.x += SPEED;
      if (pos.x > width) {
        pos.x -= SPEED;
      }
    }
  }
  
  

  public float collisionDamage() {
    return COLLISION_DAMAGE;
  }

  public Hitbox hitbox() { 
    return new Hitbox(pos, HITBOX_WIDTH, HITBOX_HEIGHT);
  }

  public float drawScale() { 
    return DRAW_SCALE;
  }

  public void draw(Stage s) {
    if (!blink) {
      drawShip();
    }
    if (sw != null) {
      sw.draw(s);
    }
  }
  
  public void draw() {
    if (!blink) {
      drawShip();
    }
  }
  
  public void drawMiniatureSpecialWeapon(){
    if (sw != null){
      sw.drawMiniature();
    }
  }

  private void drawShip() {
    pushMatrix();

    translate(pos.x, pos.y);
    scale(DRAW_SCALE);

    strokeWeight(5);

    // wings
    fill(255, 0, 0);
    stroke(192, 0, 0);
    beginShape();
    vertex(0, -50);
    vertex(80, 0);
    vertex(90, 60);
    vertex(0, 30);
    vertex(-90, 60);
    vertex(-80, 0);
    vertex(0, -50);
    endShape();

    fill(255, 255, 64);
    stroke(192, 192, 48);
    triangle(82, 12, 84, 24, 46, 0);
    triangle(86, 36, 88, 48, 50, 24);
    triangle(-82, 12, -84, 24, -46, 0);
    triangle(-86, 36, -88, 48, -50, 24);

    // exhaust pipe
    fill(128);
    stroke(96);
    quad(37, 50, 13, 50, 10, 60, 40, 60);
    quad(-37, 50, -13, 50, -10, 60, -40, 60);

    // body
    fill(255, 0, 0);
    stroke(0);
    triangle(0, -70, 50, 50, -50, 50);
    fill(0, 255, 255);
    stroke(0, 192, 192);
    ellipse(0, 0, 20, 40);

    popMatrix();
  }
}
