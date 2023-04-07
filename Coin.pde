//Players need to collect all of the coins to progress to the next level
class Coin {
  float xPos, yPos;
  boolean collected;
  Sprite newCoin;

  //Constructor
  Coin(float x, float y) {
    xPos = x;
    yPos = y;
    collected = false;
  }

  //Display Coin
  void display() {
    imageMode(CENTER);
  }

  //Function to collect coin
  int collect() {
    collected = true;
    return 1;
  }
};
