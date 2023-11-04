class LightBowOrb extends Collectible {

  public LightBowOrb(float x, float y) {
    super(x, y);
  }

  public LightBowOrb(PVector pos) {
    super(pos);
  }

  public void collected(Player p) {
    p.sw = new LightBowSW();
  }

  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);

    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(0, 0, 50, 50);

    scale(0.15);
    noStroke();
    fill(192, 192, 255);
    triangle(-40, -30, -150, 20, -60, 10);
    triangle(40, -30, 150, 20, 60, 10);
    fill(255);
    quad(-40, -30, -60, 10, -30, 40, -30, -20);
    quad(40, -30, 60, 10, 30, 40, 30, -20);

    popMatrix();
  }
}
