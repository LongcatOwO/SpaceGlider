class MainMenu implements Program {

  private Label header;
  private Set<Button> buttons;

  public MainMenu() {
    header = new Label("SPACE GLIDER", candaraBoldItalic, width/2, 100);
    header.fontSize = 80;
    buttons = new HashSet<Button>();

    Button play = new Button("PLAY", candaraBold, width/2, 500);
    play.setEvent(stageSelectionMenuInitializer);
    buttons.add(play);

    Button quit = new Button("QUIT", candaraBold, width/2, 600);
    quit.setEvent(new Program() {
      public Program run(MouseInputs mouseInputs, boolean[] keys) {
        exit();
        return null;
      }
    }
    );
    buttons.add(quit);
  }

  public Program run(MouseInputs mouseInputs, boolean[] keys) {

    Program nextProgram = checkButtons(mouseInputs, keys);

    draw(mouseInputs);

    mouseInputs.reset(LEFT);
    mouseInputs.reset(RIGHT);
    return nextProgram;
  }

  public Program checkButtons(MouseInputs mouseInputs, boolean[] keys) {
    PVector released = mouseInputs.getLeftReleased();
    if (released == null) {
      return null;
    }
    for (Button b : buttons) {
      if (b.isOn(released.x, released.y)) {
        return b.doEvent(mouseInputs, keys);
      }
    }

    return null;
  }

  public void draw(MouseInputs mouseInputs) {
    PVector cursor = mouseInputs.getCursor();

    drawBackground();

    header.drawNoBorder();
    for (Button b : buttons) {
      if (b.isOn(cursor.x, cursor.y)) {
        b.drawHighlight();
      } else {
        b.draw();
      }
    }
  }

  public void drawBackground() {
    pushMatrix();

    translate(width/2, 600);
    scale(5);
    strokeWeight(5);

    // wings
    fill(255, 0, 0, 128);
    stroke(192, 0, 0, 128);
    beginShape();
    vertex(0, -50);
    vertex(80, 0);
    vertex(90, 60);
    vertex(0, 30);
    vertex(-90, 60);
    vertex(-80, 0);
    vertex(0, -50);
    endShape();

    fill(255, 255, 64, 128);
    stroke(192, 192, 48, 128);
    triangle(82, 12, 84, 24, 46, 0);
    triangle(86, 36, 88, 48, 50, 24);
    triangle(-82, 12, -84, 24, -46, 0);
    triangle(-86, 36, -88, 48, -50, 24);

    // exhaust pipe
    fill(128, 128);
    stroke(96, 128);
    quad(37, 50, 13, 50, 10, 60, 40, 60);
    quad(-37, 50, -13, 50, -10, 60, -40, 60);

    // body
    fill(255, 0, 0, 128);
    stroke(0);
    triangle(0, -70, 50, 50, -50, 50);
    fill(0, 255, 255, 128);
    stroke(0, 192, 192, 128);
    ellipse(0, 0, 20, 40);

    popMatrix();
  }
}
