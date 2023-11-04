abstract class Enemy extends Collidable implements Explodable{
  protected float hp;
  
  public Enemy(PVector pos){
    super(pos);
    hp = maxHP();
  }
  
  public Enemy(float x, float y){
    super(x, y);
    hp = maxHP();
  }
  
  public void hit(Stage s, Collidable c){
    hp -= c.collisionDamage();
    if (isDead()){
      s.removeEnemies.add(this);
    }
  }
  
  public boolean isDead(){
    return hp <= 0;
  }
  
  abstract void run(Stage s, int elapsedTime);
    
  public void runCollision(Stage s){
    if (s.p.checkHit(this)){
      hit(s, s.p);
    }
  }
  
  abstract float maxHP();
}
