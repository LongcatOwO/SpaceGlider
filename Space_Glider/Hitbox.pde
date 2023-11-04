class Hitbox{
  private PVector topLeft;
  private PVector botRight;
  
  public Hitbox(PVector topLeft, PVector botRight){
    this.topLeft = topLeft;
    this.botRight = botRight;
  }
  
  public Hitbox(PVector center, float w, float h){
    topLeft = new PVector(center.x - w/2, center.y - h/2);
    botRight = new PVector(center.x + w/2, center.y + h/2);
  }
  
  public boolean intersect(Hitbox b){
    float lx = topLeft.x > b.topLeft.x ? topLeft.x : b.topLeft.x;
    float rx = botRight.x < b.botRight.x ? botRight.x : b.botRight.x;
    float ty = topLeft.y > b.topLeft.y ? topLeft.y : b.topLeft.y;
    float by = botRight.y < b.botRight.y ? botRight.y : b.botRight.y;
    return (lx <= rx) && (ty <= by);
  }
  
  public void draw(){
    stroke(0);
    noFill();
    strokeWeight(1);
    rect(topLeft.x, topLeft.y, botRight.x-topLeft.x, botRight.y-topLeft.y);
  }
  
  public void drawFill(){
    noStroke();
    fill(255, 0, 0, 128);
    rect(topLeft.x, topLeft.y, botRight.x-topLeft.x, botRight.y-topLeft.y);
  }
}
