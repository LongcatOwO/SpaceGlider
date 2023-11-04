class DoppelgangerOrb extends Collectible{
  
  public DoppelgangerOrb(float x, float y){
    super(x, y);
  }
  
  public DoppelgangerOrb(PVector pos){
    super(pos);
  }
  
  public void collected(Player p){
    p.sw = new DoppelgangerSW(p.pos.x, p.pos.y, p.mw.dupe());
  }
  
  public void draw(){
    pushMatrix();
    translate(pos.x, pos.y);

    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(0, 0, 50, 50);

    scale(0.15);
    strokeWeight(5);

    // wings
    fill(255, 0, 0);
    stroke(192, 0, 0);
    beginShape();
    vertex(0, -50);
    vertex(80, 0);
    vertex(90, 60);
    vertex(0, 30);
    vertex(-90, 60);
    vertex(-80, 0);
    vertex(0, -50);
    endShape();

    fill(255, 255, 64);
    stroke(192, 192, 48);
    triangle(82, 12, 84, 24, 46, 0);
    triangle(86, 36, 88, 48, 50, 24);
    triangle(-82, 12, -84, 24, -46, 0);
    triangle(-86, 36, -88, 48, -50, 24);

    // exhaust pipe
    fill(128);
    stroke(96);
    quad(37, 50, 13, 50, 10, 60, 40, 60);
    quad(-37, 50, -13, 50, -10, 60, -40, 60);

    // body
    fill(255, 0, 0);
    stroke(0);
    triangle(0, -70, 50, 50, -50, 50);
    fill(0, 255, 255);
    stroke(0, 192, 192);
    ellipse(0, 0, 20, 40);
    
    popMatrix();
  }
}
