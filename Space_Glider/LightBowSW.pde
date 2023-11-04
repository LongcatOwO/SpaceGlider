class LightBowSW implements SpecialWeapon {
  public static final float MAX_CAPACITY = 80;
  public static final float MAX_DISTANCE = 200;
  public static final float CHARGE_RATE = MAX_CAPACITY/1/fr;
  public static final float MOUSE_DOT_DIAMETER = 50;
  public static final float DRAW_SCALE = 0.5;
  public static final float OFFSET = 50;
  public static final float BOUNCE_BACK_IMPACT = 30;
  public static final float IMPACT_RECOVERY = 100.0/fr;
  public static final float FLICKER_RATIO = 0.25;
  public static final float FLICKER_RATE = 10*PI/fr;
  public static final float LIGHT_PARTICLE_MIN_RADIUS = 4;
  public static final float LIGHT_PARTICLE_MAX_RADIUS = 8;
  public static final float LIGHT_PARTICLE_SPEED = 50.0/fr;
  public static final int USABLE_TIME = 20*fr;

  private Set<Particle> particles = new HashSet<Particle>();
  private Set<Particle> indepParticles = new HashSet<Particle>();

  private int remainingTime = USABLE_TIME;

  private Timer lightParticleTimer = new Timer(50);
  private float capacity = 0;
  private float chargedPower = 0;
  private float chargeFlickerPhase = 0;
  private PVector impact = new PVector();
  private float angle = -PI/2;

  public void run(Stage s, int elapsedTime) {
    doMouse(s, elapsedTime);

    Set<Particle> removeParticles = new HashSet<Particle>();
    for (Particle p : particles) {
      p.run(removeParticles, null, elapsedTime);
    }
    particles.removeAll(removeParticles);

    removeParticles = new HashSet<Particle>();
    for (Particle p : indepParticles) {
      p.run(removeParticles, null, elapsedTime);
    }
    indepParticles.removeAll(removeParticles);

    remainingTime--;
  }

  private void doMouse(Stage s, int elapsedTime) {
    PVector cursor = mouseInputs.getCursor();
    PVector pressed = mouseInputs.getLeftPressed();
    PVector released = mouseInputs.getLeftReleased();

    if (pressed == null) {
      capacity = 0;
      chargedPower = 0;
    } else if (released == null) {
      setCapacity(pressed, cursor);
      charge();
      chargeFlickerPhase += FLICKER_RATE;
      angle = atan2(pressed.y - cursor.y, pressed.x - cursor.x);
      if (chargeFlickerPhase >= TWO_PI) {
        chargeFlickerPhase = 0;
      }
      if (chargedPower < capacity && lightParticleTimer.run(elapsedTime)) {
        float distance = random(chargedPower*2, chargedPower*3);
        PVector start = new PVector(distance, 0);
        start.rotate(random(TWO_PI));
        particles.add(new LightParticle(start, new PVector(0, 0), random(LIGHT_PARTICLE_MIN_RADIUS, LIGHT_PARTICLE_MAX_RADIUS), LIGHT_PARTICLE_SPEED));
      }
    } else {
      float shootAngle = atan2(pressed.y-released.y, pressed.x-released.x);
      PVector offset = new PVector(OFFSET, 0);
      offset.rotate(shootAngle);
      PVector origin = PVector.add(s.p.pos, offset);
      s.addAllyBullets.add(new LightBeam(origin, shootAngle, chargedPower));
      angle = shootAngle;
      impact.x = chargedPower/2;
      impact.y = BOUNCE_BACK_IMPACT + chargedPower/4;
      indepParticles.add(new LightParticle(origin, origin, chargedPower/2, LIGHT_PARTICLE_SPEED));
    }
    
    recoverImpact();
  }

  private void recoverImpact() {
    impact.x -= IMPACT_RECOVERY;
    impact.y -= IMPACT_RECOVERY;
    if (impact.x < 0) {
      impact.x = 0;
    }
    if (impact.y < 0) {
      impact.y = 0;
    }
  }

  private void setCapacity(PVector pressed, PVector cursor) {
    float pulledDistance = dist(pressed.x, pressed.y, cursor.x, cursor.y);
    if (pulledDistance > MAX_DISTANCE) {
      pulledDistance = MAX_DISTANCE;
    }
    capacity = pulledDistance/MAX_DISTANCE*MAX_CAPACITY;
  }

  private void charge() {
    chargedPower += CHARGE_RATE;
    if (chargedPower > capacity) {
      chargedPower = capacity;
    }
  }

  public boolean checkHit(EnemyBullet b) {
    return false;
  }

  public boolean checkHit(Enemy e) {
    return false;
  }

  public float remainingPower() {
    return remainingTime*100.0/USABLE_TIME;
  }

  public void draw(Stage s) {
    PVector cursor = mouseInputs.getCursor();
    PVector pressed = mouseInputs.getLeftPressed();

    if (pressed != null) {

      pushMatrix();

      translate(s.p.pos.x, s.p.pos.y);
      rotate(angle);
      translate(OFFSET, 0);


      // laser indicator
      noStroke();
      fill(255, 64);
      rect(0, -chargedPower/2, width+height, chargedPower);

      fill(255);
      ellipse(0, 0, (1+sin(chargeFlickerPhase)*FLICKER_RATIO)*chargedPower, (1+sin(chargeFlickerPhase)*FLICKER_RATIO)*chargedPower);

      pushMatrix();
      scale(DRAW_SCALE);

      // bow
      noStroke();

      // left part
      pushMatrix();
      translate(-impact.y, -chargedPower/2/DRAW_SCALE);
      fill(192, 192, 255);
      triangle(30, -40, -20, -150, -10, -60);
      fill(255);
      quad(30, -40, -10, -60, -40, -30, 20, -30);
      popMatrix();

      //right part
      pushMatrix();
      translate(-impact.y, chargedPower/2/DRAW_SCALE);
      fill(192, 192, 255);
      triangle(30, 40, -20, 150, -10, 60);
      fill(255);
      quad(30, 40, -10, 60, -40, 30, 20, 30);
      popMatrix();

      popMatrix();

      for (Particle p : particles) {
        p.draw();
      }

      popMatrix();

      // mouse indicator
      fill(0, 255, 0, 64);
      ellipse(pressed.x, pressed.y, MOUSE_DOT_DIAMETER, MOUSE_DOT_DIAMETER);
      ellipse(cursor.x, cursor.y, MOUSE_DOT_DIAMETER, MOUSE_DOT_DIAMETER);
      strokeWeight(MOUSE_DOT_DIAMETER/2);
      stroke(0, 255, 0, 64);
      line(pressed.x, pressed.y, cursor.x, cursor.y);
    } else {
      pushMatrix();

      translate(s.p.pos.x, s.p.pos.y);
      rotate(angle);
      translate(OFFSET, 0);
      scale(DRAW_SCALE);

      // bow
      noStroke();

      // left part
      pushMatrix();
      translate(-impact.y, -impact.x/DRAW_SCALE);
      fill(192, 192, 255);
      triangle(30, -40, -20, -150, -10, -60);
      fill(255);
      quad(30, -40, -10, -60, -40, -30, 20, -30);
      popMatrix();

      //right part
      pushMatrix();
      translate(-impact.y, impact.x/DRAW_SCALE);
      fill(192, 192, 255);
      triangle(30, 40, -20, 150, -10, 60);
      fill(255);
      quad(30, 40, -10, 60, -40, 30, 20, 30);
      popMatrix();

      popMatrix();
    }

    for (Particle p : indepParticles) {
      p.draw();
    }
  }

  public void drawMiniature() {
    pushMatrix();
    scale(0.3);
    noStroke();
    fill(192, 192, 255);
    triangle(-40, -30, -150, 20, -60, 10);
    triangle(40, -30, 150, 20, 60, 10);
    fill(255);
    quad(-40, -30, -60, 10, -30, 40, -30, -20);
    quad(40, -30, 60, 10, 30, 40, 30, -20);

    popMatrix();
  }
}
