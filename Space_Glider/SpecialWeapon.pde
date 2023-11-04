interface SpecialWeapon {
  
  public void run(Stage s, int elapsedTime);
  
  public boolean checkHit(EnemyBullet b);

  public boolean checkHit(Enemy e);
  
  public float remainingPower();
  
  public void draw(Stage s);
  
  public void drawMiniature();
}
