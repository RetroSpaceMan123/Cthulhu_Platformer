
//This is the object that the player controls throughout the game
class Player {
  int lives, coins;
  int f = 0; //frame counter for idle
  int g; //frame counter for walk
  int h; //frame counter for jump
  int j; //frame counter for run
  int k; //frame counter for death
  int defaultLives = 3;
  boolean walking = false, jumping = false, running = false, left = false, right = false, isOnPlatform = false, isOnWall = false, isInCover = false, isDead = false;
  float xPos, yPos, vx = 0, vy = 0, ax = 0, ay = .25, speed = 1.5f, jumpForce = 7.5f;
  Sprite idle, walk, jump, run, death;

  // added variable for checking if Cthulhu is peaking
  boolean peeking = false;

  // Loading Sprites that are going to be used for the Player
  void loadSprites() {
    idle = new Sprite("player_idle_", 4);
    walk = new Sprite("player_walk_", 5);
    jump = new Sprite("player_jump_", 6);
    run = new Sprite("player_run_", 8);
    death = new Sprite("player_death_", 5);
  }

  //Default Constructor
  Player() {
    lives = 3;
    coins = 0;
    xPos = width/2;
    yPos = height/2;
    f = 0;
    g = 0;
    h = 0;
    j = 0;
    k = 0;
    loadSprites();
  }


  //Displays the player
  void display() {
    imageMode(CENTER);
    if (jumping) {
      image(jump.get(h), xPos, yPos, 50, 50); 
    } else if(running){
        image(run.get(j), xPos, yPos, 50, 50);
    } else if (walking) {
      image(walk.get(g), xPos, yPos, 50, 50);
    } 
    else if(isDead){
    image(death.get(k), xPos, yPos, 50, 50);
  }
  else {
      image(idle.get(f), xPos, yPos, 50, 50);
    }
  }


  //Move the player
  void move() {
    
    if(left) {
      if(right) {
        walking = false;
        vx = 0;
      } else {
        walking = true;
        vx = -speed;
      }
    } else if(right) {
      walking = true;
      vx = speed;
    } else {
      walking = false;
      vx = 0;
    }
    
    if(jumping) {
      walking = false;
      running = false;
    }
  }

  boolean checkPlatform(Platform platform) {
    boolean y = (yPos + 25 > platform.yPos - platform.platformHeight/2 && yPos - 25 < platform.yPos - platform.platformHeight/2);
    boolean x = (xPos > platform.xPos - platform.platformWidth/2 && xPos < platform.xPos + platform.platformWidth/2);
    isOnPlatform = (x && y);
    if (isOnPlatform) yPos = platform.yPos - platform.platformHeight/2 - 25;
    return isOnPlatform;
  }
  
  boolean checkWall(Wall wall) {
    boolean y = (yPos + 25 > wall.yPos - wall.wallHeight/2 && yPos - 25 < wall.yPos - wall.wallHeight/2);
    boolean x = (xPos > wall.xPos - wall.wallWidth/2 && xPos < wall.xPos + wall.wallWidth/2);
    isOnWall = (x && y);
    if (isOnWall) yPos = wall.yPos - wall.wallHeight/2 - 25;
    return isOnWall;
  }

  void physics() {
    vx += ax;
    vy += ay;

    if (isOnPlatform || isOnWall) {
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
