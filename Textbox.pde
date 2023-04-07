class Textbox {
  float x, y, size;
  PFont font;
  String Text;
  
  Textbox(float nx, float ny, float nsize,String fontPath, String ntext) {
    x = nx;
    y = ny;
    size = nsize;
    font = loadFont(fontPath);
    Text = ntext;
  }
  
  void display() {
    textFont(font, size);
    textMode(CENTER);
    text(Text, x, y);
  }
};
