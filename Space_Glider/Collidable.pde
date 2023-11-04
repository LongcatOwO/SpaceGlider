abstract class Collidable{
  protected PVector pos;
  
  public Collidable(float x, float y){
    pos = new PVector(x, y);
  }
  
  public Collidable(PVector pos){
    this.pos = new PVector(pos.x, pos.y);
  }
  
  abstract float drawScale();
  
  abstract float collisionDamage();
  
  abstract void draw();
  
  abstract Hitbox hitbox();
  
  public void drawHitbox(){
    hitbox().draw();
  }
  
  public void drawFillHitbox(){
    hitbox().drawFill();
  }
}
