//This is a platform for the player to stand on
class Platform {
  float xPos, yPos, platformWidth, platformHeight;
  PImage platformImage;

  //Constructor
  Platform(float x, float y, float w, float h, color c) {
    xPos = x;
    yPos = y;
    platformWidth = w;
    platformHeight = h;
    platformImage = loadImage("platform.png");
  }

  void display() {
    imageMode(CENTER);
    image(platformImage, xPos, yPos, platformWidth, platformHeight);
    /*rect(xPos, yPos, platformWidth, platformHeight);
    */
  }
};
