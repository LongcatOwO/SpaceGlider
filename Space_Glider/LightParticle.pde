class LightParticle extends Particle {
  public static final float DECAY_PHASE_SPEED = PI/fr;
  
  
  private float radius;
  private float decayPhase = 0;
  private int time;
  private PVector vel;
  
  public LightParticle(PVector start, PVector stop, float radius, float speed){
    super(start);
    float d = dist(pos.x, pos.y, stop.x, stop.y);
    time = (int)(d/(speed*5))+1;
    vel = new PVector((stop.x-start.x)/time, (stop.y-start.y)/time);
    this.radius = radius;
  }
  
  public void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime){
    if (time > 0) {
      pos.add(vel);
      time--;
    } else {
      decayPhase += DECAY_PHASE_SPEED;
      if (decayPhase >= PI/2){
        removeParticles.add(this);
      }
    }
  }
  public void draw(){
    pushMatrix();
    
    translate(pos.x, pos.y);
    
    noStroke();
    fill(255, int(255*cos(decayPhase)));
    ellipse(0, 0, radius*2, radius*2);
    
    popMatrix();
    
  }
}
