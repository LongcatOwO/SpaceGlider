abstract class AllyBullet extends Bullet{
  
  public AllyBullet(PVector pos){
    super(pos);
  }
  
  public AllyBullet(float x, float y){
    super(x, y);
  }
  
  public Set<Enemy> checkHit(Stage s){
    Set<Enemy> hitEnemies = new HashSet<Enemy>();
    for (Enemy e : s.enemies){
      if (this.hitbox().intersect(e.hitbox())){
        hitEnemies.add(e);
      }
    }
    
    return hitEnemies;
  }
  
  public void hit(Stage s){
    s.removeAllyBullets.add(this);
  }
  
  public void runCollision(Stage s){
    Set<Enemy> hitEnemies = checkHit(s);
    for (Enemy e : hitEnemies){
      hit(s);
      e.hit(s, this);
      return;
    } 
  }
}
