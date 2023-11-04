class DoppelgangerSW extends Collidable implements SpecialWeapon {
  public static final float HP_DECAY = 3.0/fr;
  
  private float maxHP = Player.MAX_HP;
  private float hp = maxHP;
  private MainWeapon mw;

  private boolean invincibility = false;
  private boolean blink = false;

  private Timer invncTimer = null;
  private Timer blinkTimer = null;
  
  
  public DoppelgangerSW(float x, float y, MainWeapon mainWeapon){
    super(x, y);
    mw = mainWeapon.dupe();
    hit(0);
  }
  
  public DoppelgangerSW(PVector pos, MainWeapon mainWeapon){
    super(pos);
    mw = mainWeapon.dupe();
    hit(0);
  }
  
  public void run(Stage s, int elapsedTime){
    move(mouseInputs);
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
    hp -= HP_DECAY;
  }
  
  public void move(MouseInputs mouseInputs){
    PVector cursor = mouseInputs.getCursor();
    pos.x = cursor.x;
    pos.y = cursor.y;
    
    if (pos.x < 0) {
      pos.x = 0;
    }
    else if (pos.x > width) {
      pos.x = width;
    }
    
    if (pos.y < 0) {
      pos.y = 0;
    }
    else if (pos.y > height) {
      pos.y = height;
    }
  }
  
  public boolean checkHit(EnemyBullet b) {
    if (hitbox().intersect(b.hitbox())) {
      return hit(b.collisionDamage());
    }

    return false;
  }

  public boolean checkHit(Enemy e) {
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
      invncTimer = new Timer(Player.HIT_INVINCIBILITY_TIME);
      blinkTimer = new Timer(Player.BLINK_INTERVAL);
      return true;
    }
    return false;
  }
  
  public boolean isDead() {
    return hp <= 0;
  }
  
  public float remainingPower(){
    return hp;
  }
  
  public Hitbox hitbox(){
    return new Hitbox(pos, Player.HITBOX_WIDTH, Player.HITBOX_HEIGHT);
  }
  
  public float drawScale(){
    return Player.DRAW_SCALE;
  }
  
  public float collisionDamage(){
    return Player.COLLISION_DAMAGE;
  }
   
  public void draw(Stage s){
    draw();
  }
  
  public void draw(){
    if (!blink) {
      drawShip();
    }
  }
  
  public void drawMiniature(){
    pushMatrix();
    scale(Player.DRAW_SCALE);

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
    //triangle(82, 12, 84, 24, 48, 12, 46, 0);
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
  
  private void drawShip() {
    pushMatrix();

    translate(pos.x, pos.y);
    scale(Player.DRAW_SCALE);

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
    //triangle(82, 12, 84, 24, 48, 12, 46, 0);
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
