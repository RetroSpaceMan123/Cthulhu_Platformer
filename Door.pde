//Opens when a button is pressed, allowing for access to certain areas of a level
class Door {
  float xPos, yPos, doorWidth, doorHeight;
  color Color;
  boolean closed;

  //Constructor
  Platform(float x, float y, float w, float h, color c) {
    xPos = x;
    yPos = y;
    doorWidth = w;
    doorHeight = h;
    Color = c;
    closed = false;
  }

  void toggle() {
    closed = !closed;
  }

  void display() {
    if (!closed) {
      rectMode(CENTER);
      fill(Color);
      rect(x, y, w, h);
    }
  }
};
