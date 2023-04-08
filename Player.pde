//This is the object that the player controls throughout the game
class Player {
  int lives, coins;
  int f; //frame counter for idle
  int g; //frame counter for walk
  int h; //frame counter for jump
  boolean walking = false;
  float xPos, yPos, vx = 0, vy = 0, ax = 0, ay = 10, speed = 50f, jumpForce = 40.0f, dt = 1/frameRate;
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
    if (vy != 0) {
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
    } else if (key == ' ') {
      vy = -jumpForce;
    }
  }

  void physics() {
    vx += ax * dt;
    vy += ay * dt;
    xPos += vx * dt + ax * dt * dt/2;
    yPos += vy * dt + ay * dt * dt/2;
  }

  // Notify GameManager class when the player is peaking
  void peeking(boolean peek) {
    peeking = peek;
  }

  boolean isPeeking() {
    return peeking;
  }

  void jump() {
  }
};
