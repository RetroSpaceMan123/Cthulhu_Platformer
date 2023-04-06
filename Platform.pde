//This is a platform for the player to stand on
class Platform {
  float xPos, yPos, platformWidth, platformHeight;
  color Color;

  //Constructor
  Platform(float x, float y, float w, float h, color c) {
    xPos = x;
    yPos = y;
    platformWidth = w;
    platformHeight = h;
    Color = c;
  }

  void display() {
    rectMode(CENTER);
    fill(Color);
    rect(xPos, yPos, platformWidth, platformHeight);
  }
};
