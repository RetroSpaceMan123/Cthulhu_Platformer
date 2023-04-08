class Coin {
  float xPos, yPos;
  boolean collected;
  Sprite coin;
  int i;

  //Constructor
  Coin(float x, float y) {
    xPos = x;
    yPos = y;
    i = 0;
    collected = false;
    coin = new Sprite("goldCoin", 9);
  }

  //Display Coin
  void display() {
    if(collected == false){
    imageMode(CENTER);
    image(coin.get(i), xPos, yPos, 50, 50);
    }
  }

};
