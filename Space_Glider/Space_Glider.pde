import java.util.*;

PFont candara, candaraBold, candaraBoldItalic;
float defaultTextSize = 30;
color defaultFontColor = color(255);
color defaultLabelHighlightColor = color(0);

Program currentProgram;
boolean[] keys = new boolean[128]; // keys pressed
MouseInputs mouseInputs = new MouseInputs(); // mouse inputs
static final int fr = 60; // frame rate

Program mainMenuInitializer;
Program stageSelectionMenuInitializer;

ArrayList<Program> stageInitializers = new ArrayList<Program>();

void setup() {

  candara = createFont("Candara.ttf", defaultTextSize);
  candaraBold = createFont("Candarab.ttf", defaultTextSize);
  candaraBoldItalic = createFont("Candaraz.ttf", defaultTextSize);

  frameRate(fr);
  size(800, 800);

  mainMenuInitializer = new Program() {
    public Program run(MouseInputs mouseInputs, boolean[] keys) {
      return new MainMenu();
    }
  };

  stageSelectionMenuInitializer = new Program() {
    public Program run(MouseInputs mouseInputs, boolean[] keys) {
      return new StageSelectionMenu();
    }
  };

  setupStageInitializers();

  currentProgram = new MainMenu();
}

void setupStageInitializers() {
  stageInitializers.add(new Program() {
    public Program run(MouseInputs mouseInputs, boolean[] keys) {
      return initStage0();
    }
  }
  );
  stageInitializers.add(new Program() {
    public Program run(MouseInputs mouseInputs, boolean[] keys) {
      return initStage1();
    }
  }
  );
  stageInitializers.add(new Program() {
    public Program run(MouseInputs mouseInputs, boolean[] keys) {
      return initStage2();
    }
  }
  );
}

Stage initStage0() {
  Stage s = new Stage(stageInitializers.get(0), stageInitializers.get(1));
  EnemyWave wave = new EnemyWave();
  wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(400, -50, 400, 150), 2000));
  wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(-50, 50, 300, 100), 3000));
  wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(850, 50, 500, 100), 3000));
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 4; i++) {
    float x = random(100, 700);
    float y = random(100, 300);
    wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(x, -50, x, y), 2000+i*1500));
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 6; i++) {
    float x = random(100, 700);
    float y = random(100, 300);
    wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(x, -50, x, y), 2000+i*1000));
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 10; i++) {
    float x = random(100, 700);
    float y = random(100, 300);
    wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(x, -50, x, y), 2000+i*500));
  }
  s.addEnemyWave(wave);



  return s;
}

Stage initStage1() {
  Stage s = new Stage(stageInitializers.get(1), stageInitializers.get(2));

  EnemyWave wave = new EnemyWave();
  for (int i = 0; i < 5; i++) {
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(300, -50, PI/2, -radians(10)), 2000+i*200));
  }
  for (int i = 0; i < 5; i++) {
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(500, -50, PI/2, radians(15)), 6000+i*200));
  }
  for (int i = 0; i < 6; i++) {
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(-50, 50, 0, radians(30)), 10000+i*150));
  }
  for (int i = 0; i < 5; i++) {
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(-50, 100, PI/4, -radians(30)), 13000+i*300));
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(850, 250, PI*3/4, radians(30)), 13000+i*300));
  }
  for (int i = 0; i < 8; i++) {
    float x = random(150, 650);
    float y = random(100, 300);
    wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(x, -50, x, y), 2000+i*3000));
  }

  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 5; i++) {
    EnemyShooter e1 = new EnemyShooter(-50, -50, 350-i*50, 100);
    EnemyShooter e2 = new EnemyShooter(850, -50, 450+i*50, 100);
    e1.setMoveRadius(0);
    e2.setMoveRadius(0);
    wave.addEnemySpawn(new EnemySpawn(e1, 2000+i*200));
    wave.addEnemySpawn(new EnemySpawn(e2, 2000+i*200));
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(-50, -50, PI/2, -radians(45)), 3000+i*400));
    wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(850, -50, PI/2, radians(45)), 3200+i*400));
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  Enemy boss = new BigPurple(400, -100, 400, 120);
  wave.addEnemySpawn(new EnemySpawn(boss, 3000));
  s.addEnemyWave(wave);
  s.setBoss(boss);
  return s;
}

Stage initStage2() {
  Stage s = new Stage(stageInitializers.get(2));

  EnemyWave wave = new EnemyWave();
  for (int i = 0; i < 3; i++) {
    float x = 250+i*150;
    wave.addEnemySpawn(new EnemySpawn(new EnemyShielder(x, -50, x, 200), 2000));
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 2; i++) {
    float x = 300+200*i;
    int t = 2000+i*5000;
    wave.addEnemySpawn(new EnemySpawn(new EnemyShielder(x, -50, x, 200), t));
    for (int j = 0; j < 5; j++) {
      wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(x, -50, PI/2, 0), t+500+j*200));
    }
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 1; i <= 5; i++) {
    float x = i*800.0/6;
    EnemyShooter shooter = new EnemyShooter(x, -50, x, 150);
    shooter.setMoveRadius(0);
    wave.addEnemySpawn(new EnemySpawn(shooter, 1000));
    wave.addEnemySpawn(new EnemySpawn(new EnemyShielder(x, -50, x, 200), 1500));
  }
  s.addEnemyWave(wave);

  wave = new EnemyWave();
  for (int i = 0; i < 2; i++) {
    for (int j = 1; j <= 7; j++) {
      float x = j*100;
      wave.addEnemySpawn(new EnemySpawn(new EnemyShielder(x, -50, x, 200+i*50), 1500+200*j+1600*i));
    }
  }
  for (int i = 0; i < 10; i++) {
    float x = random(100, 700);
    wave.addEnemySpawn(new EnemySpawn(new EnemyShooter(x, -50, x, 120), 5000+1500*i));
  }
  for (int i = 0; i < 4; i++) {
    int rand = int(random(2));
    if (rand == 1) {
      for (int j = 0; j < 3; j++) {
        wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(-50, 300, 0, 0), 6000+j*200+i*4000));
      }
    } else {
      for (int j = 0; j < 3; j++) {
        wave.addEnemySpawn(new EnemySpawn(new EnemyCrasher(850, 300, PI, 0), 6000+j*200+i*4000));
      }
    }
  }
  s.addEnemyWave(wave);  

  wave = new EnemyWave();
  Enemy boss = new Mothership();
  wave.addEnemySpawn(new EnemySpawn(boss, 2000));
  s.setBoss(boss);
  s.addEnemyWave(wave);

  return s;
}

boolean outOfBound(float x, float y, float w, float h) {
  return x+w/2 < 0 || x-w/2 > width || y+h/2 < 0 || y-h/2 > height;
}

void draw() {
  background(0);

  Program nextProgram = currentProgram.run(mouseInputs, keys);
  if (nextProgram != null) {
    currentProgram = nextProgram;
  }
}

void keyPressed() {
  if (key >= 0 && key < 128) {
    keys[key] = true;
  }
}

void keyReleased() {
  if (key >= 0 && key < 128) {
    keys[key] = false;
  }
}

void mousePressed() {
  mouseInputs.pressed(mouseX, mouseY, mouseButton);
}

void mouseReleased() {
  mouseInputs.released(mouseX, mouseY, mouseButton);
}

void mouseMoved() {
  mouseInputs.setCursor(mouseX, mouseY);
}

void mouseDragged() {
  mouseInputs.setCursor(mouseX, mouseY);
}
