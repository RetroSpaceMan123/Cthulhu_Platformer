//This is the object that the player controls throughout the game
class Player {
  int lives, coins;
  float xPos, yPos, vx = 0, vy = 0, ax = 0, ay = 98.1, dt = 1/frameRate, speed = 25f, jumpForce = 20.0f;
  PImage sprite;
  PImage[] sprites;
  // added variable for checking if Cthulhu is peaking
  boolean peaking = false;

  // Loading Sprites that are going to be used for the Player
  void loadSprites() {
    sprites = new PImage[3];
    sprites[0] = loadImage("player_idle.gif");
    sprites[1] = loadImage("player_walk.gif");
    sprites[2] = loadImage("player_death.gif");
    sprite = sprites[0];
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
    loadSprites();
  }

  //Displays the player
  void display() {
    imageMode(CENTER);
    image(sprite, xPos, yPos);
  }

  //Move the player
  void move() {
    if (key == 'a' || keyCode == LEFT) {
      vx = -speed;
    } else if (key == 'd' || keyCode == RIGHT) {
      vx = speed;
    } else if (key == ' ') {
      vy = -jumpForce;
    }
  }

  // Notify GameManager class when the player is peaking
  void peaking(boolean peak) {
    peaking = peak;
  }

  boolean isPeaking() {
    return peaking;
  }

  //Physics for Player
  void physics() {
    vx += ax * dt;
    vy += ay * dt;
    xPos += vx * dt + (ax * dt * dt * 0.5);
    yPos += vy * dt + (ay * dt * dt * 0.5);
  }
};
