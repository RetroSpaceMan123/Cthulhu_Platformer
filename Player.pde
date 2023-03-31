class Player {
  int lives, coins;
  float xPos, yPos, speed = 2.5f, jumpForce = 20.0f;
  PImage sprite;
  PImage[] sprites;
  
  // Loading Sprites that are going to be used for the Player
  void loadSprites() {
    sprites = new PImage[3];
    sprites[0] = loadImage("player_idle.gif");
    sprites[1] = loadImage("player_walk.gif");
    sprites[2] = loadImage("player_death.gif");
  }
  
  //Default Constructor
  Player() {
    lives = 3;
    coins = 0;
    xPos = 0;
    yPos = 0;
    loadSprites();
  }
  
  //Constructor for starting levels
  Player(int L, int C, int x, int y) {
    lives = L;
    coins = C;
    xPos = x;
    yPos = y;
  }
};
