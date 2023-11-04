class ExplosionParticleTrace extends Particle {
  
  public static final float RADIUS_REDUCTION = 20.0/fr;
  
  private float radius;
  private int vertexCount;
  private float angle;
  
  public ExplosionParticleTrace(float x, float y , float radius, int vertexCount, float angle){
    super(x, y);
    this.radius = radius;
    this.vertexCount = vertexCount;
    this.angle = angle;
  }
  
  public ExplosionParticleTrace(PVector pos, float radius, int vertexCount, float angle){
    super(pos);
    this.radius = radius;
    this.vertexCount = vertexCount;
    this.angle = angle;
  }
  
  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime){
    radius -= RADIUS_REDUCTION;
    if (radius <= 0){
      removeParticles.add(this);
    }
  }
  
  public void draw(){
    pushMatrix();
    
    translate(pos.x, pos.y);
    
    noStroke();
    fill(255, 128, 0, 128);
    float currentAngle = angle;
    beginShape();
    for (int i = 0; i < vertexCount; i++){
      vertex(cos(currentAngle)*radius, sin(currentAngle)*radius);
      currentAngle += TWO_PI/vertexCount;
    }
    endShape();
    
    popMatrix();
  }
  
  
}
