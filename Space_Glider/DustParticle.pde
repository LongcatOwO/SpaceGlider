class DustParticle extends Particle {
  public static final int BASE_COLOR_VALUE = 192;
  public static final int VERTEX_COUNT = 3;
  public static final float SIZE = 3;

  private int[] col = new int[3];
  private float speed;
  private float angle;
  private float scaleFactor;

  public DustParticle(float x, float y, float speed, float scaleFactor) {
    super(x, y);
    this.speed = speed/fr;
    this.scaleFactor = scaleFactor;
    initialize();
  }

  public DustParticle(PVector pos, float speed, float scaleFactor) {
    super(pos);
    this.speed = speed/fr;
    this.scaleFactor = scaleFactor;
    initialize();
  }

  private void initialize() {
    col[0] = BASE_COLOR_VALUE + int(random(256-BASE_COLOR_VALUE));
    col[1] = BASE_COLOR_VALUE + int(random(256-BASE_COLOR_VALUE));
    col[2] = BASE_COLOR_VALUE + int(random(256-BASE_COLOR_VALUE));
    angle = random(TWO_PI);
  }

  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime) {
    pos.y += speed;
    if (pos.y > height) {
      removeParticles.add(this);
    }
  }

  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    scale(scaleFactor);

    noStroke();
    fill(col[0], col[1], col[2]);

    float currentAngle = angle;
    beginShape();
    for (int i = 0; i < VERTEX_COUNT; i++) {
      vertex(cos(currentAngle)*SIZE, sin(currentAngle)*SIZE);
      currentAngle += TWO_PI/VERTEX_COUNT;
    }
    endShape();

    popMatrix();
  }
}
