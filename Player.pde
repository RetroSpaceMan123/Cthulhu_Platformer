//This is the object that the player controls throughout the game
class Player {
  int lives, coins;
  int f = 0; //frame counter for idle
  int g; //frame counter for walk
  int h; //frame counter for jump
  boolean walking = false, jumping = false, isOnPlatform;
  float xPos, yPos, vx = 0, vy = 0, ax = 0, ay = .25, speed = 2.5f, jumpForce = 7.5f;
  Sprite idle, walk, jump;

  // added variable for checking if Cthulhu is peaking
  boolean peeking = false;

  // Loading Sprites that are going to be used for the Player
  void loadSprites() {
    idle = new Sprite("player_idle_", 4);
    walk = new Sprite("player_walk_", 5);
    jump = new Sprite("player_jump_", 6);
  }

  //Default Constructor
  Player() {
    lives = 3;
    coins = 0;
    xPos = 0;
    yPos = 0;
    f = 0;
    g = 0;
    h = 0;
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
    if (jumping) {
      image(jump.get(h), xPos, yPos, 50, 50);
    } else if (walking) {
      image(walk.get(g), xPos, yPos, 50, 50);
    } else {
      image(idle.get(f), xPos, yPos, 50, 50);
    }
  }

  //Move the player
  void move() {
    if (key == 'a' || keyCode == LEFT) {
      vx = -speed;
      walking = true;
    } else if (key == 'd' || keyCode == RIGHT) {
      vx = speed;
      walking = true;
    } else if (key == ' ' && !jumping) {
      vy = -jumpForce;
    }
  }

  void checkPlatform(Platform platform) {
    boolean y = (yPos + 25 > platform.yPos - platform.platformHeight/2);
    boolean x = (xPos > platform.xPos - platform.platformWidth/2 && xPos < platform.xPos + platform.platformWidth/2);
    isOnPlatform = (x && y);
    if (isOnPlatform) yPos = platform.yPos - platform.platformHeight/2 - 25;
  }

  void physics() {
    vx += ax;
    vy += ay;

    if (isOnPlatform) {
      ay = 0;
      jumping = false;
    } else {
      ay = 0.25;
      jumping = true;
    }

    xPos += vx;
    yPos += vy;
  }

  // Notify GameManager class when the player is peaking
  void peeking(boolean peek) {
    peeking = peek;
  }

  boolean isPeeking() {
    return peeking;
  }
};
