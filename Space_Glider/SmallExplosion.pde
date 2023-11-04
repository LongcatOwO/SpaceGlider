class SmallExplosion extends Particle {
  
  public static final int MIN_EXPLOSION_PARTICLES = 4;
  public static final int MAX_EXPLOSION_PARTICLES = 6;
  public static final float PHASE_SPEED = PI/0.5/fr;
  
  private float phase = 0;
  private float radius;
  
  
  public SmallExplosion(float x, float y, float radius, Set<Particle> addParticles){
    super(x, y);
    this.radius = radius;
    addExplosionParticles(addParticles);
  }
  
  public SmallExplosion(PVector pos, float radius, Set<Particle> addParticles){
    super(pos);
    this.radius = radius;
    addExplosionParticles(addParticles);
  }
  
  private void addExplosionParticles(Set<Particle> addParticles){
    int n = int(random(MIN_EXPLOSION_PARTICLES, MAX_EXPLOSION_PARTICLES+1));
    for (int i = 0; i < n; i++){
      addParticles.add(new ExplosionParticle(pos, radius));
    }
  }
  
  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime){
    phase += PHASE_SPEED;
    if (phase > PI){
      removeParticles.add(this);
    }
  }
  
  public void draw(){
    pushMatrix();
    
    translate(pos.x, pos.y);
    
    strokeWeight(radius/3);
    stroke(255, 128, 0, 128);
    fill(255, 255, 0, 192);
    ellipse(0, 0, radius*sin(phase), radius*sin(phase));
    
    popMatrix();
  }
}
