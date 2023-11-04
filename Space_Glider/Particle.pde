abstract class Particle {
  PVector pos;
  
  public Particle(float x, float y){
    pos = new PVector(x, y);
  }
  
  public Particle(PVector pos){
    this.pos = new PVector(pos.x, pos.y);
  }
  
  public void run(Stage s, int elapsedTime){
    run(s.removeParticles, s.addParticles, elapsedTime);
  }
  
  abstract void run(Set<Particle> removeParticles, Set<Particle> addParticles, int elapsedTime);
  abstract void draw();
}
