//This is where it's safe for the player to hide in order to avoid Cthulhu's stare
class Cover {
  float xPos, yPos, coverWidth, coverHeight;
  color Color;

  //Constructor
  Cover(float x, float y, float w, float h, color c) {
    xPos = x;
    yPos = y;
    coverWidth = w;
    coverHeight = h;
    Color = c;
  }

  void display() {
    rectMode(CORNER);
    fill(Color);
    rect(xPos, yPos, coverWidth, coverHeight);
  }
};
