abstract class EnemyBullet extends Bullet {
  
  public EnemyBullet(float x, float y){
    super(x, y);
  }
  
  public EnemyBullet(PVector pos){
    super(pos);
  }
  
  
  public void runCollision(Stage s){
    if (s.p.checkHit(this)){
      hit(s);
    }
  } 
  
  public void hit(Stage s){
    s.removeEnemyBullets.add(this);
  }
  
}
