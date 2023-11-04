abstract class Bullet extends Collidable{
  
  public Bullet(PVector pos){
    super(pos);
  }
  
  public Bullet(float x, float y){
    super(x, y);
  }
  
  abstract void run(Stage s, int elapsedTime);
  
  abstract void hit(Stage s);
  
  abstract void runCollision(Stage s);
}
