class ExplosionParticle extends Particle{
 
  public static final int VERTEX_COUNT = 4;
  public static final int TRACE_EMISSION_INTERVAL = 50;
  public static final float ACCELERATION = 15.0/fr;
  public static final float VELOCITY_FACTOR = 10;
  public static final float MIN_ANGLE_SPEED = PI/3/fr;
  public static final float MAX_ANGLE_SPEED = TWO_PI/fr;
  public static final float MIN_RADIUS_FACTOR = 0.05;
  public static final float MAX_RADIUS_FACTOR = 0.08;
  
  private Timer traceTimer;
  private float angle = 0;
  private float angleSpeed;
  private float radius;
  private PVector vel;
  
  public ExplosionParticle(float x, float y, float explosionRadius){
    super(x, y);
    initialize(explosionRadius);
  }
  
  public ExplosionParticle(PVector pos, float explosionRadius){
    super(pos);
    initialize(explosionRadius);
  }
  
  private void initialize(float explosionRadius){
    traceTimer = new Timer(TRACE_EMISSION_INTERVAL);
    vel = new PVector(random(2*explosionRadius)-explosionRadius, random(2*explosionRadius)-explosionRadius);
    vel.mult(VELOCITY_FACTOR/fr);
    angleSpeed = random(MIN_ANGLE_SPEED, MAX_ANGLE_SPEED);
    radius = explosionRadius*random(MIN_RADIUS_FACTOR, MAX_RADIUS_FACTOR);
  }
  
  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime){
    pos.add(vel);
    vel.y += ACCELERATION;
    angle += angleSpeed;
    if (traceTimer.run(elapsedTime)){
      addParticles.add(new ExplosionParticleTrace(pos, radius, VERTEX_COUNT, angle));
    }
    if (pos.y-radius > height || pos.x+radius < 0 || pos.x-radius > width){
     removeParticles.add(this);
    }
  }
  
  public void draw(){
    pushMatrix();
    
    translate(pos.x, pos.y);
    
    noStroke();
    fill(255, 255, 0);
    float currentAngle = angle;
    beginShape();
    for (int i = 0; i < VERTEX_COUNT; i++){
      vertex(cos(currentAngle)*radius, sin(currentAngle)*radius);
      currentAngle += TWO_PI/VERTEX_COUNT;
    }
    endShape();
    
    popMatrix();
  }
}
