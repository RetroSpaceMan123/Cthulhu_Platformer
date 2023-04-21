//This class is the representation of the game's levels in code
class Level {
  Coin[] coins;
  Platform[] platforms;
  Wall[] walls;
  Cover[] covers;
  PImage background;

  Level(Coin[] cn, Platform[] pf, Cover[] cv, Wall[] wl, int bg) {
    coins = cn;
    platforms = pf;
    covers = cv;
    walls = wl;
    background = loadImage("background"+bg+".png");
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

  }
}
