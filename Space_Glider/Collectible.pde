abstract class Collectible{
  public static final float WIDTH = 50;
  public static final float SPEED = 200.0/fr;
  public static final int FLOAT_TIME = 20*fr;
  
  protected PVector pos;
  protected PVector vel;
  private int time = FLOAT_TIME;
  
  public Collectible(float x, float y){
    pos = new PVector(x, y);
    initVelocity();
  }
  
  public Collectible(PVector pos){
    this.pos = new PVector(pos.x, pos.y);
    initVelocity();
  }
  
  private void initVelocity(){
    float angle = random(TWO_PI);
    vel = new PVector(cos(angle)*SPEED, sin(angle)*SPEED);
  }
  
  public void run(Stage s){
    move();
    if (hitbox().intersect(s.p.hitbox())){
      collected(s.p);
      s.removeCollectibles.add(this);
    }
    if (--time <= 0){
      s.removeCollectibles.add(this);
    }
  }
  
  public void move(){
    pos.add(vel);
    if (pos.x < 0){
      pos.x = 0;
      vel.x = abs(vel.x);
    }
    else if (pos.x > width){
      pos.x = width;
      vel.x = -abs(vel.x);
    }
    if (pos.y < 0){
      pos.y = 0;
      vel.y = abs(vel.y);
    }
    else if (pos.y > height){
      pos.y = height;
      vel.y = -abs(vel.y);
    }
  }
  
  abstract void collected(Player p);
  
  abstract void draw();
  
  public Hitbox hitbox(){
    return new Hitbox(pos, WIDTH, WIDTH);    
  }
  
  public void drawHitbox(){
    hitbox().draw();
  }
  
  public void drawFillHitbox(){
    hitbox().drawFill();
  }
}
