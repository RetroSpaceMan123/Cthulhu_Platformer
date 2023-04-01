//This class is the representation of the game's levels in code
class Level {
  Coin[] coins;
  Platform[] platforms;
  Cover[] covers;
  ButtonItem[] buttonItems;
  Enemy[] enemies;
  Player player;
  Cthulhu cthulhu;
  float playerX, playerY;
  PImage background;

  Level(Coin[] cn, Platform[] pf, Cover[] cv, ButtonItem[] bt, Enemy[] em, Player pl, Cthulhu ct, float x, float y, String path) {
    coins = cn;
    platforms = pf;
    covers = cv;
    buttonItem = bt;
    enemies = em;
    player = pl;
    cthulhu = ct;
    playerX = x;
    playerY = y;
    background = loadImage(path);
  }

  //Display the Level
  void display() {
    background(background);
    cthulhu.display();

    for (int i = 0; i < platforms.length; i++) {
      platforms[i].display();
    }

    for (int i = 0; i < covers.length; i++) {
      covers[i].display();
    }

    for (int i = 0; i < coins.length; i++) {
      coins[i].display();
    }

    for (int i = 0; i < buttonItems.length; i++) {
      buttonItems[i].display();
      buttonItems[i].getDoor().display();
    }

    for (int i = 0; i < enemies.length; i++) {
      enemies[i].display();
    }

    player.display();
  }
};
