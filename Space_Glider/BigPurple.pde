class BigPurple extends Enemy {
  public static final float COLLISION_DAMAGE = 50;
  public static final float DRAW_SCALE = 1;
  public static final float HITBOX_WIDTH = 200*DRAW_SCALE;
  public static final float HITBOX_HEIGHT = 40*DRAW_SCALE;
  public static final float MAX_HP = 1000;
  public static final float EXPLOSION_RADIUS = 80;
  public static final float SPEED = 200.0/fr;
  public static final float SHOOT1_SPAN_ANGLE = PI/180*20;
  public static final int SHOOT1_INTERVAL = 200;
  public static final int SHOOT1_TIME = (int)(1.5*fr);
  public static final float SHOOT2_SPAN_ANGLE = PI/3;
  public static final int SHOOT2_INTERVAL = 150;
  public static final int SHOOT2_TIME = 1*fr;

  private int time;
  private PVector vel;
  private String action;
  private Timer timer;

  public BigPurple(float x, float y, float dx, float dy){
    super(x, y);
    setMovement(new PVector(dx, dy));
  }
  
  public void run(Stage s, int elapsedTime) {
    if (action.equals("move")) {
      move();
    }
    else if (action.equals("shoot1")){
      doShoot1(s, elapsedTime);
    }
    else if (action.equals("shoot2")){
      doShoot2(s, elapsedTime);
    }
    
    runCollision(s);
  }

  private void move(){
    pos.add(vel);
    time--;
    if (time <= 0){
      int nextAttack = int(random(2));
      if (nextAttack == 0){
        initShoot1();
      }
      else if (nextAttack == 1){
        initShoot2();
      }
    }
  }
  
  private void doShoot1(Stage s, int elapsedTime){
    if (timer.run(elapsedTime)){
      float angle = HALF_PI + (0.5 - float(time)/SHOOT1_TIME)*SHOOT1_SPAN_ANGLE;
      float angleDif = PI/180*20;
      float angle2 = angle + angleDif;
      for (int i = 0; i < 3; i++){
        s.addEnemyBullets.add(new SmallEnemyBullet(pos.x, pos.y, angle2));
        angle2 -= angleDif;
      }
    }
    time--;
    if (time <= 0) {
      randomizeMovement();
    }
  }
  
  private void doShoot2(Stage s, int elapsedTime){
    if (timer.run(elapsedTime)){
      float angle = random(SHOOT2_SPAN_ANGLE) - SHOOT2_SPAN_ANGLE/2 + PI/2;
      s.addEnemyBullets.add(new SmallEnemyBullet(pos.x, pos.y, angle));
    }
    time--;
    if (time <= 0) {
      randomizeMovement();
    }
  }
  
  private void initShoot1(){
    timer = new Timer(SHOOT1_INTERVAL);
    action = "shoot1";
    time = SHOOT1_TIME;
  }
  
  private void initShoot2(){
    timer = new Timer(SHOOT2_INTERVAL);
    action = "shoot2";
    time = SHOOT2_TIME;
  }
  
  private void randomizeMovement(){
    float lx = constrain(pos.x-100, HITBOX_WIDTH/2, width-HITBOX_WIDTH/2);
    float rx = constrain(pos.x+100, HITBOX_WIDTH/2, width-HITBOX_WIDTH/2);
    float rand = random(lx + width - rx - HITBOX_WIDTH);
    float newX;
    if (rand <= lx-HITBOX_WIDTH/2){
      newX = rand+HITBOX_WIDTH/2;
    }
    else {
      newX = rx+rand-(lx-HITBOX_WIDTH/2);
    }
    setMovement(new PVector(newX, pos.y));
  }
  
  private void setMovement(PVector dest){
    time = int(PVector.dist(pos, dest)/SPEED)+1;
    vel = new PVector(dest.x-pos.x, dest.y-pos.y);
    vel.mult(1.0/time);
    action = "move";
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
    stroke(192, 128, 255);
    fill(128, 0, 255);
    beginShape();
    vertex(-100, -20);
    vertex(100, -20);
    vertex(90, 10);
    vertex(20, 20);
    vertex(-20, 20);
    vertex(-90, 10);
    vertex(-100, -20);
    endShape();

    stroke(0);
    beginShape();
    vertex(-20, -20);
    vertex(20, -20);
    vertex(20, 20);
    vertex(0, 30);
    vertex(-20, 20);
    vertex(-20, -20);
    endShape();
    
    popMatrix();
  }
}
