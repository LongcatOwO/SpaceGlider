class Label {
  public static final float DEFAULT_BORDER_WIDTH = 20;
  
  public PVector pos;
  public float borderWidth;
  public String text;
  public PFont font;
  public float fontSize;
  public color col;
  public color highlightCol;
  
  public Label(String text, PFont font, float x, float y){
    this.text = text;
    this.font = font;
    fontSize = defaultTextSize;
    pos = new PVector(x, y);
    col = defaultFontColor;
    highlightCol = defaultLabelHighlightColor;
    borderWidth = DEFAULT_BORDER_WIDTH;
  }
  
  
  
  public boolean isOn(float x, float y){
    float w = getTextWidth();
    if (x >= pos.x - w/2 - borderWidth && x <= pos.x + w/2 + borderWidth && y >= pos.y - fontSize/2 - borderWidth && y <= pos.y + fontSize/2 + borderWidth){
      return true;
    }
    
    return false;
  }
  
  public void setTextProperty(){
    textFont(font);
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    fill(col);
  }
  
  public float getTextWidth(){
    setTextProperty();
    return textWidth(text);
  }
  
  public void draw(){
    drawBorder(false);
    setTextProperty();
    text(text, pos.x, pos.y);
  }
  
  public void drawHighlight(){
    drawBorder(true);
    setTextProperty();
    text(text, pos.x, pos.y);
  }
  
  public void drawNoBorder(){
    setTextProperty();
    text(text, pos.x, pos.y);
  }
    
    
  
  public void drawBorder(boolean highlight){
    float w = getTextWidth();
    if (highlight){
      fill(highlightCol);
    }
    else{
      noFill();
    }
    strokeWeight(3);
    stroke(col);
    rect(pos.x - w/2 - borderWidth, pos.y - fontSize/2 - borderWidth, w + borderWidth*2, fontSize + borderWidth*2);
  }
}
