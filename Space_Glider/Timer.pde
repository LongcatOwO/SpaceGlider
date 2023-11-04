class Timer {
  //private int time;
  private int interval;
  private int timer;
  
  public Timer(int interval){
    //time = millis();
    this.interval = interval;
    timer = 0;
  }
  
  public Timer(int interval, int startTimer){
    //time = millis();
    this.interval = interval;
    timer = startTimer;
  }
  
  public boolean run(int elapsedTime){
    timer += elapsedTime;
    if (timer >= interval){
      timer = timer%interval;
      return true;
    }
    
    return false;
  }
  
  
  /*private int elapseTime(){
    int currentTime = millis();
    int elapsedTime = currentTime - time;
    time = currentTime;
    
    return elapsedTime;
  }*/
}
