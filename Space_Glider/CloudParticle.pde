class CloudParticle extends Particle {
  public static final float MIN_WIDTH = 30;
  public static final float MAX_WIDTH = 100;
  public static final float MIN_HEIGHT = 50;
  public static final float MAX_HEIGHT = 200;
  public static final int MIN_BLOB = 0;
  public static final int MAX_BLOB = 6;
  public static final float MIN_BLOB_SIZE = 20;
  public static final float MAX_BLOB_SIZE = 50;
  public static final float MIN_COLOR_FACTOR = 0.4;
  public static final float MAX_COLOR_FACTOR = 0.5;
  public static final float ALPHA_VALUE = 128;

  private float w, h;
  private int[] col = new int[3];
  private ArrayList<PVector> frontBlobs = new ArrayList<PVector>();
  private ArrayList<Float> frontBlobSizes = new ArrayList<Float>();
  private ArrayList<int[]> frontBlobColors = new ArrayList<int[]>();
  private ArrayList<PVector> backBlobs = new ArrayList<PVector>();
  private ArrayList<Float> backBlobSizes = new ArrayList<Float>();
  private ArrayList<int[]> backBlobColors = new ArrayList<int[]>();
  private float speed;
  private float scaleFactor;

  public CloudParticle(float x, float y, float speed, float scaleFactor, int[] baseColor) {
    super(x, y);
    this.speed = speed/fr;
    this.scaleFactor = scaleFactor;
    initialize(baseColor);
  }

  public CloudParticle(PVector pos, float speed, float scaleFactor, int[] baseColor) {
    super(pos.x, pos.y);
    this.speed = speed/fr;
    this.scaleFactor = scaleFactor;
    initialize(baseColor);
  }

  private void initialize(int[] baseColor) {
    w = random(MIN_WIDTH, MAX_WIDTH);
    h = random(MIN_HEIGHT, MAX_HEIGHT);
    float colorFactor = random(MIN_COLOR_FACTOR, MAX_COLOR_FACTOR);
    for (int i = 0; i < 3; i++) {
      col[i] = int(baseColor[i]*colorFactor);
    }
    int n = int(random(MIN_BLOB, MAX_BLOB+1));
    for (int i = 0; i < n; i++) {
      PVector blob = new PVector(random(-w/2, w/2), random(-h/2, h/2));
      float blobSize = random(MIN_BLOB_SIZE, MAX_BLOB_SIZE);
      int[] blobColor = new int[3];
      colorFactor = random(MIN_COLOR_FACTOR, MAX_COLOR_FACTOR);
      for (int j = 0; j < 3; j++) {
        blobColor[j] = int(baseColor[j]*colorFactor);
      }
      if (random(100) < 50){
        frontBlobs.add(blob);
        frontBlobSizes.add(blobSize);
        frontBlobColors.add(blobColor);
      }
      else {
        backBlobs.add(blob);
        backBlobSizes.add(blobSize);
        backBlobColors.add(blobColor);
      }
    }
  }
  
  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime){
    pos.y += speed;
    if (pos.y > height+200){
      removeParticles.add(this);
    }
  }

  public void draw() {
    pushMatrix();
    
    translate(pos.x, pos.y);
    scale(scaleFactor);
    
    noStroke();
    
    for (int i = 0; i < backBlobs.size(); i++){
      PVector blob = backBlobs.get(i);
      float blobSize = backBlobSizes.get(i);
      int[] blobColor = backBlobColors.get(i);
      fill(blobColor[0], blobColor[1], blobColor[2], ALPHA_VALUE);
      ellipse(blob.x, blob.y, blobSize, blobSize);
    }
    fill(col[0], col[1], col[2]);
    ellipse(0, 0, w, h);
    
    for (int i = 0; i < frontBlobs.size(); i++){
      PVector blob = frontBlobs.get(i);
      float blobSize = frontBlobSizes.get(i);
      int[] blobColor = frontBlobColors.get(i);
      fill(blobColor[0], blobColor[1], blobColor[2], ALPHA_VALUE);
      ellipse(blob.x, blob.y, blobSize, blobSize);
    }
    
    popMatrix();
  }
}
