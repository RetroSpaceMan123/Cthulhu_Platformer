//This is a platform for the player to stand on
class Platform {
  float xPos, yPos, platformWidth, platformHeight;
  PImage platformImage;

  //Constructor
  Platform(float x, float y, float w, float h, int num) {
    xPos = x;
    yPos = y;
    platformWidth = w;
    platformHeight = h;
    platformImage = loadImage("wall"+num+".png");
  }

  void display() {
    imageMode(CENTER);
    image(platformImage, xPos, yPos, platformWidth, platformHeight);
  }
};
