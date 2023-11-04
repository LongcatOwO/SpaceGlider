abstract class Background {
  
  ArrayList<Set<Particle>> layers = new ArrayList<Set<Particle>>();

  public Background() {
    initialize();
  }

  protected abstract void initialize();

  public void run(int elapsedTime) {
    
    for (Set<Particle> layer : layers) {
      Set<Particle> removeParticles = new HashSet<Particle>();
      Set<Particle> addParticles = new HashSet<Particle>();
      for (Particle p : layer) {
        p.run(removeParticles, addParticles, elapsedTime);
      }
      layer.removeAll(removeParticles);
      layer.addAll(addParticles);
    }
  }

  public void draw() {
    for (Set<Particle> layer : layers) {
      for (Particle p : layer) {
        p.draw();
      }
    }
  }
}
