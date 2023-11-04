class MachineGun extends MainWeapon {

  public static final int SHOOT_INTERVAL = 100;

  public MachineGun() {
    super(SHOOT_INTERVAL);
  }

  public void shoot(PVector pos, Stage s) {
    if (level >= 1 && level <= 3) {
      float startX = pos.x - level/2.0*8;
      for (int i = 0; i <= level; i++){
        s.addAllyBullets.add(new MGBullet1(startX, pos.y));
        startX += 8;
      }
    }
  }

  public MainWeapon dupe() {
    MainWeapon dupe = new MachineGun();
    dupe.setLevel(level);
    return dupe;
  }
}
