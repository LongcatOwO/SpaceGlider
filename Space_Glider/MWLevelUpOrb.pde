class MWLevelUpOrb extends Collectible {

  public MWLevelUpOrb(float x, float y) {
    super(x, y);
  }

  public MWLevelUpOrb(PVector pos) {
    super(pos);
  }

  public void collected(Player p) {
    p.mw.levelUp();
    if (p.sw instanceof DoppelgangerSW) {
      DoppelgangerSW dpg = (DoppelgangerSW)p.sw;
      dpg.mw.levelUp();
    }
  }

  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);

    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(0, 0, 50, 50);

    stroke(128, 128, 255);
    strokeWeight(5);
    line(-15, 0, 0, -10);
    line(0, -10, 15, 0);
    translate(0, 10);
    line(-15, 0, 0, -10);
    line(0, -10, 15, 0);
    
    popMatrix();
  }
}
