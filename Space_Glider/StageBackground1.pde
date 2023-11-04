class StageBackground1 extends Background {
  public static final int CLOUD_PARTICLE_INTERVAL = 500;
  public static final float CLOUD_PARTICLE_SPEED = 150;
  public static final int CLOUD_BASE_COLOR_VALUE = 64;
  public static final int CLOUD_EXTRA_COLOR_VALUE = 32;
  public static final int DUST_PARTICLE_INTERVAL = 50;
  public static final float DUST_PARTICLE_SPEED = 200;

  private Timer cloudTimer;
  private Timer dustTimer;

  protected void initialize() {
    cloudTimer = new Timer(CLOUD_PARTICLE_INTERVAL);
    dustTimer = new Timer(DUST_PARTICLE_INTERVAL);
    layers.add(new HashSet<Particle>());
    layers.add(new HashSet<Particle>());
    layers.add(new HashSet<Particle>());
  }

  @Override
    public void run(int elapsedTime) {
    super.run(elapsedTime);

    if (cloudTimer.run(elapsedTime)) {
      int index = int(random(layers.size()));
      int colorValue = CLOUD_BASE_COLOR_VALUE+CLOUD_EXTRA_COLOR_VALUE*(index);
      layers.get(index).add(new CloudParticle(random(width), -200, CLOUD_PARTICLE_SPEED*(index+1), 1.0/(layers.size()-index), new int[]{colorValue, colorValue, colorValue}));
    }

    if (dustTimer.run(elapsedTime)) {
      int index = int(random(layers.size()));
      layers.get(index).add(new DustParticle(random(width), 0, DUST_PARTICLE_SPEED*(index+1), 1.0/(layers.size()-index)));
    }
  }
}
