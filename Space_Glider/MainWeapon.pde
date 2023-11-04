abstract class MainWeapon {
  public static final int MAX_LEVEL = 3;
  
  private Timer timer;
  protected int level = 1;
  
  public MainWeapon(int interval){
    timer = new Timer(interval);
  }
  public void run(PVector pos, Stage s, int elapsedTime){
    if (timer.run(elapsedTime)){
      shoot(pos, s);
    }
      
  }
  
  public int getLevel(){
    return level;
  }
  
  public void levelUp(){
    level++;
    if (level > MAX_LEVEL){
      level = MAX_LEVEL;
    }
  }
  
  public void setLevel(int lv){
    level = constrain(lv, 1, MAX_LEVEL);
  }
  
  abstract void shoot(PVector pos, Stage s);
  
  abstract MainWeapon dupe();
}
