class Button extends Label {

  private Program event = null;

  public Button(String text, PFont font, float x, float y) {
    super(text, font, x, y);
  }

  public void setEvent(Program event) {
    this.event = event;
  }

  public Program doEvent(MouseInputs mouseInputs, boolean[] keys) {
    if (event != null) {
      return event.run(mouseInputs, keys);
    }
    return null;
  }
  
}
