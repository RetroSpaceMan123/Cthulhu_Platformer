//Appears in random intervals in order to force player into cover
class Cthulhu {
  float xPos, yPos;
  boolean active;
  PImage[] sprites;
  PImage sprite;

  Cthulhu(float x, float y) {
    xPos = x;
    yPos = y;
    active = false;
    sprites = new PImage[2];
    sprites[0] = loadImage("cthulhu_rise.gif");
    sprites[1] = loadImage("cthulhu_fall.gif");
    sprite = sprites[0];
  }

  void display() {
    imageMode(CENTER);
    image(sprite, xPos, yPos);
  }
};
