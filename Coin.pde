//Players need to collect all of the coins to progress to the next level
class Coin {
  float xPos, yPos;
  boolean collected;
  PImage sprite;

  //Constructor
  Coin(float x, float y) {
    xPos = x;
    yPos = y;
    collected = false;
    sprite = loadImage("coin.gif");
  }

  //Display Coin
  void display() {
    imageMode(CENTER);
    image(sprite, xPos, yPos);
  }

  //Function to collect coin
  int collect() {
    collected = true;
    return 1;
  }
};
