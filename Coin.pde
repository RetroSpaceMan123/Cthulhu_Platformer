import processing.sound.*;

class Coin {
  float xPos, yPos;
  boolean isCollected;
  Sprite coin;
  int i;

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
    
    boolean collisionCheck = player.xPos - 25 <= xPos && player.xPos + 23 >= xPos;
    collisionCheck &= player.yPos + 37 >= yPos && player.yPos - 34 <= yPos;
    if(player.yPos >= yPos) {
      collisionCheck &= dist(player.xPos, player.yPos, xPos, yPos) <= 35;
    } else {
      collisionCheck &= dist(player.xPos, player.yPos, xPos, yPos) <= 38;
    }
    
    if(collisionCheck) {
      isCollected = true;
      player.coins++;
        coinSound.play();
      }
      
    }
  }
