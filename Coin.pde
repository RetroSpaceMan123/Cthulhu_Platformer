import processing.sound.*;


class Coin {
  float xPos, yPos;
  boolean isCollected;
  Sprite coin;
  int i;
  boolean play;

  //Constructor
  Coin(float x, float y) {
    xPos = x;
    yPos = y;
    i = 0;
    isCollected = false;
    coin = new Sprite("goldCoin", 10);
  }

  //Display Coin
  void display() {
    if(!isCollected){
    imageMode(CENTER);
    image(coin.get(i), xPos, yPos, 50, 50);
    collect();
    }
  }

  void collect(){
      coinSound = new SoundFile(Cthulhu_Platformer.this, "coin_collect.wav");
      if((abs(player.xPos - xPos) <= 10 && abs(player.yPos - yPos) <= 10)) {
        isCollected = true;
        if(!coinSound.isPlaying()){
        coinSound.play();
        }
        player.coins++;
      }
  }
}
