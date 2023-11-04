class MouseInputs {
  private PVector cursor = new PVector();
  private PVector leftPressed = null;
  private PVector leftReleased = null;
  private PVector rightPressed = null;
  private PVector rightReleased = null;
  
  public void setCursor(float x, float y){
    cursor.x = x;
    cursor.y = y;
  }
  
  public void pressed(float x, float y, int button){
    if (button == LEFT){
      leftReleased = null;
      leftPressed = new PVector(x, y);
    }
    else if (button == RIGHT){
      rightReleased = null;
      rightPressed = new PVector(x, y);
    }
  }
  
  public void released(float x, float y, int button){
    if (button == LEFT){
      leftReleased = new PVector(x, y);
    }
    else if (button == RIGHT){
      rightReleased = new PVector(x, y);
    }
  }
  
  public void reset(int button){
    if (button == LEFT && leftPressed != null && leftReleased != null){
      leftPressed = null;
      leftReleased = null;
    }
    else if (button == RIGHT && rightPressed != null && rightReleased != null){
      rightPressed = null;
      rightReleased = null;
    }
  }
  
  public PVector getCursor(){
    return cursor.copy();
  }
  
  public PVector getLeftPressed(){
    return leftPressed == null ? null : leftPressed.copy();
  }
  
  public PVector getLeftReleased(){
    return leftReleased == null ? null : leftReleased.copy();
  }
  
  public PVector getRightPressed(){
    return rightPressed == null ? null : rightPressed.copy();
  }
  
  public PVector getRightReleased(){
    return rightReleased == null ? null : rightReleased.copy();
  }
}
