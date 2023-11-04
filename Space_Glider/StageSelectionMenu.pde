class StageSelectionMenu implements Program {
  
  
  private Label header;
  private Set<Button> buttons;
  
  public StageSelectionMenu(){
    header = new Label("SELECT STAGE", candaraBold, width/2, 100);
    header.fontSize = 40;
    
   
    
    buttons = new HashSet<Button>();
    color highlightCol = color(128, 128, 0);
    for (int i = 0; i < stageInitializers.size(); i++){
      Button b = new Button("Stage "+i, candara, width/2, 200+i*75);
      b.fontSize = 20;
      b.highlightCol = highlightCol;
      b.setEvent(stageInitializers.get(i));
      buttons.add(b);
    } 
    Button back = new Button("BACK", candara, width/2, 700);
    back.highlightCol = highlightCol;
    back.setEvent(mainMenuInitializer);
    buttons.add(back);
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

    header.drawNoBorder();
    for (Button b : buttons) {
      if (b.isOn(cursor.x, cursor.y)) {
        b.drawHighlight();
      } else {
        b.draw();
      }
    }
    
  }
  
}
