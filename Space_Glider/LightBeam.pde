class LightBeam extends AllyBullet {
  public static final float BASE_DAMAGE = 20;
  public static final float WIDTH_DAMAGE_RATIO = 1.0/20;
  public static final float PHASE_SPEED = 3.0/fr;
  public static final float INNER_OUTER_RATIO = 2.0/3;

  private float phase = 0;
  private float maxWidth;
  private float angle;

  public LightBeam(PVector start, float angle, float maxWidth) {
    super(start);
    this.angle = angle;
    this.maxWidth = maxWidth;
  }

  private Set<Enemy> ignoredEnemies = new HashSet<Enemy>();

  public void run(Stage s, int elapsedTime) {
    runPhase(s);
    runCollision(s);
  }
  
  public void runPhase(Stage s){
    phase += PHASE_SPEED;
    if (phase >= PI/2){
      s.removeAllyBullets.add(this);
    }
  }
  
  @Override
  public void runCollision(Stage s){
    Set<Enemy> hitEnemies = checkHit(s);
    for (Enemy e : hitEnemies){
      e.hit(s, this);
    } 
  }

  @Override
  public Set<Enemy> checkHit(Stage s) {
    Set<Enemy> hitEnemies = new HashSet<Enemy>();
    for (Enemy e : s.enemies) {
      if (!ignoredEnemies.contains(e) && checkHit(e)) {
        hitEnemies.add(e);
        ignoredEnemies.add(e);
      }
    }

    return hitEnemies;
  }
  
  @Override
  public void hit(Stage s){
    
  }

  public boolean checkHit(Enemy e) {
    Hitbox enemyHitbox = e.hitbox();
    if (!inRange(enemyHitbox)){
      return false;
    }
    PVector anglePoint = new PVector(pos.x+cos(angle), pos.y+sin(angle));
    PVector span = getLeftSpanVector();
    boolean[] leftHitCode = getHitCode(PVector.add(pos, span), PVector.add(anglePoint, span), enemyHitbox);
    span = getRightSpanVector();
    boolean[] rightHitCode = getHitCode(PVector.add(pos, span), PVector.add(anglePoint, span), enemyHitbox);
    
    for (int i = 0; i < 4; i++){
      if (leftHitCode[i] && rightHitCode[i]){
        return false;
      }
    }
    
    return true;
  }

  private boolean inRange(Hitbox hitbox) {
    PVector left = new PVector(pos.x, pos.y);
    left.add(getLeftSpanVector());
    PVector right = new PVector(pos.x, pos.y);
    right.add(getRightSpanVector());
    float lx = hitbox.topLeft.x;
    float rx = hitbox.botRight.x;
    float ty = hitbox.topLeft.y;
    float by = hitbox.botRight.y;
    float a = left.y - right.y;
    float b = right.x - left.x;
    float c = left.x*right.y - right.x*left.y;
    boolean leftTop = calculateLineEquation(a, b, c, lx, ty) <= 0;
    boolean rightTop = calculateLineEquation(a, b, c, rx, ty) <= 0;
    boolean leftBot = calculateLineEquation(a, b, c, lx, by) <= 0;
    boolean rightBot = calculateLineEquation(a, b, c, rx, by) <= 0;
    if (!leftTop && !rightTop && !leftBot && !rightBot) {
      return false;
    }
    return true;
  }

  private boolean[] getHitCode(PVector p1, PVector p2, Hitbox hitbox) {
    float a = p1.y - p2.y;
    float b = p2.x - p1.x;
    float c = p1.x*p2.y - p2.x*p1.y;
    float lx = hitbox.topLeft.x;
    float rx = hitbox.botRight.x;
    float ty = hitbox.topLeft.y;
    float by = hitbox.botRight.y;
    float tlx = findTOfIntersection(a, b, c, lx, ty, lx, by);
    float trx = findTOfIntersection(a, b, c, rx, ty, rx, by);
    float tty = findTOfIntersection(a, b, c, lx, ty, rx, ty);
    float tby = findTOfIntersection(a, b, c, lx, by, rx, by);
    boolean[] code = new boolean[]{false, false, false, false}; // left, right, up, down
    if (tty < 0 && tby < 0) {
      code[0] = true;
    }
    if (tty > 1 && tby > 1) {
      code[1] = true;
    }
    if (tlx < 0 && trx < 0) {
      code[2] = true;
    }
    if (tlx > 1 && trx > 1) {
      code[3] = true;
    }

    return code;
  }

  private float calculateLineEquation(float a, float b, float c, float x, float y){
    return a*x + b*y + c;
  }
  
  private PVector getLeftSpanVector() {
    PVector span = new PVector(currentWidth()/2, 0);
    span.rotate(angle-PI/2);
    return span;
  }

  private PVector getRightSpanVector() {
    PVector span = new PVector(currentWidth()/2, 0);
    span.rotate(angle+PI/2);
    return span;
  }

  private float findTOfIntersection(float a, float b, float c, float x0, float y0, float x1, float y1) {
    return -1*(a*x0+b*y0+c)/(a*(x1-x0)+b*(y1-y0));
  }

  public Hitbox hitbox() {
    return null;
  }

  public float collisionDamage() {
    return BASE_DAMAGE*currentWidth()*WIDTH_DAMAGE_RATIO;
  }

  public float currentWidth() {
    return maxWidth*cos(phase);
  }

  public float drawScale() {
    return 1;
  }

  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    rotate(angle);

    float currentWidth = currentWidth();
    noStroke();
    fill(128, 128, 255, 192);
    rect(0, -currentWidth/2, width+height, currentWidth);
    fill(255);
    rect(0, -currentWidth/2*INNER_OUTER_RATIO, width+height, currentWidth*INNER_OUTER_RATIO);

    popMatrix();
  }
}
