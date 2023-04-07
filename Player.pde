//This is the object that the player controls throughout the game
class Player {
  int lives, coins;
  int f; //frame counter for idle
  int g; //frame counter for walk
  int h; //frame counter for jump
  boolean walking = false;
  float xPos, yPos, speed = 4f, jumpForce = 20.0f;
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
  void idleDisplay() {
    imageMode(CENTER);
      image(idle.get(f), xPos, yPos, 50, 50);
    }

  void walkDisplay(){
    imageMode(CENTER);
    image(walk.get(g), xPos, yPos, 50, 50);
  }
  
  //Move the player
  void move() {
    if (key == 'a' || keyCode == LEFT) {
      xPos -= speed;
      walking = true;
    } else if (key == 'd' || keyCode == RIGHT) {
      xPos += speed;
      walking = true;
    }
    else {
      walking = false;
    }
  }

  // Notify GameManager class when the player is peaking
  void peeking(boolean peek){
    peeking = peek;
  }

  boolean isPeeking(){
    return peeking;
  }

  void jump(){

  }

};
