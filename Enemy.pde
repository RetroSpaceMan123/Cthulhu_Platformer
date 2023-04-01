//Enemies attack the player in order to prevent them from collect all the coins in the level
class Enemy {
  float xPos, yPos, speed;
  PImage sprite;

  Enemy(float x, float y, float s, String path) {
    xPos = x;
    yPos = y;
    sprite = loadImage(path);
  }

  void display() {
    imageMode(CENTER);
    image(sprite, x, y);
  }
};
