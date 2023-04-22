//Main File //<>// //<>// //<>//
import processing.sound.*;
SoundFile music, menuMusic, coinSound, jump, stareSound, loseSound, gameOverMusic, fanfare, confirm;

Player player;
PImage bckg;
Coin[] coins;
Platform platform;


enum Difficulty {
  TUTORIAL,
    EASY,
    HARD
}
Difficulty diff;

int savedTime;
int totalTime = 5000;
float reachedPoint; // randomizer to start cthulhu animation

int x = 0;
float startTime;
float currTime = 0;          // initialize the timer
float interval = 0;       // initialize the interval
boolean pointReached; // cthulhu





void loseLife() {
  player.coins = 0;
  player.lives--;
  player.xPos = levels[diffType].initX;
  player.yPos = levels[diffType].initY;
  player.vy = 1.5f;
  time = 0;

  cthulhu.active = false;
  recentDeath = true;
  loseSound.play();

  player.isDead = true;
  for (int i = 0; i < levels[diffType].coins.length; i++) {
    levels[diffType].coins[i].isCollected = false;
  }

  cthulhu.a = 0;
  cthulhu.d = 0;
  cthulhu.descend = false;
  cthulhu.ascend = false;
  startTime = millis();
  if (diff == Difficulty.TUTORIAL){
    interval = random(7000,7000);
  }
  else{
  interval = random(4000, 8000);
  }
  
  cthulhu.active = false;
  cthulhu.holdStare = false;
  stareSound.stop();
  if (!music.isPlaying()) {
    music.play();
  }
}


void drawGame() {
  if(menuMusic.isPlaying()){
    menuMusic.stop();
  }
  if (!music.isPlaying()) {
    music.loop();
  }
  //Game State
  if (player.lives == 0 || player.coins == levels[diffType].coins.length) {
    gameOver = true;
    if (player.coins == levels[diffType].coins.length) {
      win = true;
    }
  }


  //Cthulhu states
  currTime = millis();
  if (!cthulhu.active || recentDeath) {
    // check if the timer has reached the interval
    if (currTime >= startTime + interval) {
      cthulhu.active = true;
      cthulhu.ascend = true;
    }
  }

  if (cthulhu.active) {
    // reset the timer and generate a new random interval
    if (frameCount % 20 == 0) {

      if (cthulhu.a == 10) {
        savedTime = millis();
      }

      if (cthulhu.a == 11) {
        cthulhu.holdStare = true;
        cthulhu.descend = false;
        cthulhu.ascend = true;

        //Player looses a life if they are not in cover, and have not been hit by Cthulu's stare
        if (!player.isInCover) {
          loseLife();
          recentDeath = true;
          savedTime = millis();
        }

        int passedTime = millis() - savedTime;
        // Has five seconds passed?
        if (passedTime > totalTime) {
          cthulhu.holdStare = false;
          // 5 seconds has passed
          cthulhu.ascend = false;
          cthulhu.descend = true;
          savedTime = millis(); // Save the current time to restart the timer!
          recentDeath = false;
        }
      }

      if (cthulhu.ascend && !cthulhu.holdStare) {
        cthulhu.d = 0;
        cthulhu.a = (cthulhu.a+1)%12;
      } else if (cthulhu.descend && !cthulhu.holdStare) {
        cthulhu.a = 0;
        cthulhu.d = (cthulhu.d+1)%13;
      }
      if (cthulhu.d == 12) {
        cthulhu.descend = false;
        startTime = millis();
        interval = random(4000, 8000);
        cthulhu.active = false;
      }
    }
  }


  //Platform checks and physics
  for (int i = 0; i < levels[diffType].platforms.length; i++) {
    boolean landed = player.checkPlatform(levels[diffType].platforms[i]);
    if (landed) break;
  }

  //Wall checks and physics
  for (int i = 0; i < levels[diffType].walls.length; i++) {
    boolean landed = player.checkWall(levels[diffType].walls[i]);
    if (landed) break;
  }


  player.physics();
  System.out.println("vy: " + player.vy);
  for (int i = 0; i < coins.length; i++) {
    if (frameCount % 6 == 0) {
      coins[i].i = (coins[i].i+1)%10;
    }
    coins[i].display();
  }
  platform.display();
  player.display();
  if (player.walking == false && player.running == false && player.isOnPlatform) {
    player.display();
    if (frameCount % 15 == 0) {
      player.f = (player.f+1)%4;
    }
  } 
  else if (player.running == true) {
    if(frameCount % 10 == 0){
      player.j = (player.j+1)%8;
    }
  }
  else if (player.walking == true) {
    if (frameCount % 8 == 0) {
      player.g = (player.g+1)%5;
    } 
  }


  //cover logic
  covered = false;

  for (int i = 0; i < levels[diffType].covers.length; i++) {
    boolean temp = player.xPos + 10 <= levels[diffType].covers[i].xPos + levels[diffType].covers[i].coverWidth && player.xPos - 15 >= levels[diffType].covers[i].xPos;
    temp &= player.yPos - 18 >= levels[diffType].covers[i].yPos && player.yPos + 10 <= levels[diffType].covers[i].yPos + levels[diffType].covers[i].coverHeight;
    covered |= temp;
  }

  player.isInCover = covered;


  //wall collision
  for (int i = 0; i < levels[diffType].walls.length; i++) {
    boolean temp = player.xPos + 10 > levels[diffType].walls[i].xPos - levels[diffType].walls[i].wallWidth/2 && player.xPos - 12 < levels[diffType].walls[i].xPos + levels[diffType].walls[i].wallWidth/2;
    temp &= player.yPos - 19 < levels[diffType].walls[i].yPos + levels[diffType].walls[i].wallHeight/2 && player.yPos + 16 > levels[diffType].walls[i].yPos - levels[diffType].walls[i].wallHeight/2;


    float leftSide = dist(player.xPos, player.yPos, levels[diffType].walls[i].xPos - levels[diffType].walls[i].wallWidth/2 - 11, player.yPos);
    float topSide = dist(player.xPos, player.yPos, player.xPos, levels[diffType].walls[i].yPos - levels[diffType].walls[i].wallHeight/2 - 16.75);
    float rightSide = dist(player.xPos, player.yPos, levels[diffType].walls[i].xPos + levels[diffType].walls[i].wallWidth/2 + 12, player.yPos);
    float bottomSide = dist(player.xPos, player.yPos, player.xPos, levels[diffType].walls[i].yPos + levels[diffType].walls[i].wallHeight/2 + 19.25);

    if (temp) {
      if (leftSide < topSide && leftSide < rightSide && leftSide < bottomSide) {
        player.xPos = levels[diffType].walls[i].xPos - levels[diffType].walls[i].wallWidth/2 - 11;
      } else if (topSide < leftSide && topSide < rightSide && topSide < bottomSide) {
        player.vy = 0;
        player.yPos = levels[diffType].walls[i].yPos - levels[diffType].walls[i].wallHeight/2 - 16.75;
      } else if (rightSide < leftSide && rightSide < topSide && rightSide < bottomSide) {
        player.xPos = levels[diffType].walls[i].xPos + levels[diffType].walls[i].wallWidth/2 + 12;
      } else if (bottomSide < leftSide && bottomSide < topSide && bottomSide < rightSide) {
        player.vy = 0;
        player.yPos = levels[diffType].walls[i].yPos + levels[diffType].walls[i].wallHeight/2 + 19;
      }
  }
  if(diff == Difficulty.TUTORIAL && inGame){
   textSize(20);
   text("Use arrow keys to move!", 50, height/2 + 100); 
   
  
   text("Press spacebar to jump", 420, height/2 + 50);
   text("and collect coins!", 430, height/2 + 70);
   
   text("take cover to avoid Cthulhu!", 660, height/2 - 80);
   textSize(50);
   text ("<--", 840, height/2 - 20);
   
   textSize(20);
   text("Collect all coins", 900, height/2 + 150);
   text("to win!!", 950, height/2 + 170);
   
  }
}

void drawMainMenu() {
  mainMenu.display();
  if (music.isPlaying()) {
    music.stop();
  }
  if (!menuMusic.isPlaying()) {
    menuMusic.play();
  }
  
}

void setup() {
  size(1200, 800);
  music = new SoundFile(Cthulhu_Platformer.this, "theme.mp3");
  menuMusic = new SoundFile(this, "mystery.mp3");
  confirm = new SoundFile(this, "menu_confirm.wav");
  coinSound = new SoundFile(this, "coin_collect.wav");
  stareSound = new SoundFile(this, "cthulhu_stare.wav");
  jump = new SoundFile(this, "jump.wav");
  loseSound = new SoundFile(this, "lose_sound1.wav");
  gameOverMusic = new SoundFile(this, "game_over_music.mp3");
  fanfare = new SoundFile(this, "fanfare.wav");

  player = new Player();
  cthulhu = new Cthulhu();
  frameRate(50);
  bckg = loadImage("background1.png");
  bckg.resize(1200, 800);
  time = millis();
  win = false;
  diff = Difficulty.TUTORIAL;
  inGame = false;

  // level initialization
  levels = new Level[3];
  
   // initialize tutorial level
  // ========================== TUTORIAL =================================
  
  Coin[] coinsTutorial = new Coin[3];
  Textbox[] tutorialText = new Textbox[1];
  tutorialText[0] = new Textbox(90, (height/2) - 60, 32, "Constantia-Bold-32.vlw", "Use arrow keys to move!");
  coinsTutorial[0] = new Coin(500, 500); 
  coinsTutorial[1] = new Coin(width/2 + 200, 380);
  coinsTutorial[2] = new Coin(width/2 + 380, 600);
  Platform[] platformsTutorial = new Platform[1];
  //PLATFORM INFO  PLATFORM(float xPos, float yPos, float width, float height, int num)
  platformsTutorial[0] = new Platform(width / 2 + 80,550,100,30,1);
  Cover[] coverTutorial = new Cover[1];
  //COVER INFO  Cover(float xPos, float yPos, float width, float height, int num)
  coverTutorial[0] = new Cover(width / 2 + 200, 380, 70, 70, 1);
  Wall[] wallsTutorial = new Wall[2];
  // WALL INFO  Wall(float xPos, float yPos, float width, float height, int num)
  wallsTutorial[0] = new Wall(width / 2, 700, width, 100, 1); 
  wallsTutorial[1] = new Wall(width / 2 + 200, 530, 150, 240, 1);
  
  levels[0] = new Level(coinsTutorial, platformsTutorial, coverTutorial, wallsTutorial,1, 100, (float)(height/2));
  player.xPos = levels[diffType].initX;
  player.yPos = levels[diffType].initY;
  
  
  
 
  
  // initialize easy level
  // ================================= EASY ======================================
  
  Coin[] coinsEasy = new Coin[6];
  
  Wall[] wallsEasy = new Wall[8];
  
  Cover[] coverEasy = new Cover[10];
  
  Platform[] platformEasy = new Platform[13];
  
  
  levels[1] = new Level(coinsEasy, platformEasy, coverEasy, wallsEasy, 3, (float)(width/2), (float)(height/2));
  

  
  //interval creation
  
  interval = random(5000, 6000); // generate a random interval between 5 and 6 seconds
  
  startTime = 0;
  savedTime = 0;

  //UIs and textboxes

  //Game UI
  Textbox[] textboxes = new Textbox[2];
  textboxes[0] = new Textbox(width - 330, 50, 32, "Constantia-Bold-32.vlw", "Coins: ");
  textboxes[1] = new Textbox(width - 130, 50, 32, "Constantia-Bold-32.vlw", "Lives: ");
  Textbox textbox = new Textbox(65, 50, 32, "Constantia-Bold-32.vlw", "Pause");
  ButtonUI pauseButton = new ButtonUI(113, 40, 200, 42, color(100), new PImage(), textbox);
  ButtonUI[] buttons = new ButtonUI[1];
  buttons[0] = pauseButton;
  gameUI = new UI(buttons, textboxes, new PImage[0], new float[0], new float[0]);

  //Pause UI
  Textbox[] pauseText = new Textbox[1];
  pauseText[0] = new Textbox(width/2 - 60, 100, 32, "Constantia-Bold-32.vlw", "Paused");
  ButtonUI[] pauseButtons = new ButtonUI[2];
  Textbox unpause = new Textbox(width/2 - 120, 210, 32, "Constantia-Bold-32.vlw", "Return to Game");
  pauseButtons[0] = new ButtonUI(width/2, 200, 300, 42, color(100), new PImage(), unpause);
  Textbox back = new Textbox(width/2 - 120, 310, 32, "Constantia-Bold-32.vlw", "Return to Menu");
  pauseButtons[1] = new ButtonUI(width/2, 300, 300, 42, color(100), new PImage(), back);
  pauseMenu = new UI(pauseButtons, pauseText, new PImage[0], new float[0], new float[0]);


  //Main Menu
  Textbox[] menuText = new Textbox[1];
  menuText[0] = new Textbox(width/2 - 210, 120, 48, "Constantia-Bold-32.vlw", "Cthulhu Platformer");
  ButtonUI[] menuButtons = new ButtonUI[4];
  Textbox startText = new Textbox(width/2 - 85, 210, 32, "Constantia-Bold-32.vlw", "Start Game");
  menuButtons[0] = new ButtonUI(width/2, 200, 300, 42, color(100), new PImage(), startText);
  Textbox diffText = new Textbox(width/2 - 145, 310, 32, "Constantia-Bold-32.vlw", "Difficulty: Tutorial");
  menuButtons[1] = new ButtonUI(width/2, 300, 300, 42, color(100), new PImage(), diffText);
  Textbox credText = new Textbox(width/2 - 52, 410, 32, "Constantia-Bold-32.vlw", "Credits");
  menuButtons[2] = new ButtonUI(width/2, 400, 300, 42, color(100), new PImage(), credText);
  Textbox quitText = new Textbox(width/2 - 40, 510, 32, "Constantia-Bold-32.vlw", "Quit");
  menuButtons[3] = new ButtonUI(width/2, 500, 300, 42, color(100), new PImage(), quitText);
  mainMenu = new UI(menuButtons, menuText, new PImage[0], new float[0], new float[0]);


  gameOver = false;
  recentDeath = false;
}

void draw() {
  if (inGame) {
    
    if (diff == Difficulty.TUTORIAL){
    
    diffType = 0;
    drawGame();
    }
    else if (diff == Difficulty.EASY){
      diffType = 1;
      drawGame();
    }
    else if(diff == Difficulty.HARD){
      diffType = 2;    
      drawGame();
    }
  } else {
    background(bckg);
    drawMainMenu();
  }
}



void keyPressed() {
  if(key == 'a' || keyCode == LEFT) {
    player.left = true;
  }
  if(key == 'd' || keyCode == RIGHT) {
    player.right = true;
  }
 if(keyCode == SHIFT && !player.jumping) {
   player.running = true;
   player.speed = 3f;
 }
 if (key == ' ' && !player.jumping) {
      player.vy = -player.jumpForce;
      player.jumping = true;
 }
 
 player.move();
}

void keyReleased() {
  if(key == 'a' || keyCode == LEFT) {
    player.left = false;
  }
  if(key == 'd' || keyCode == RIGHT) {
    player.right = false;
  }
  if(keyCode == SHIFT) {
    player.running = false;
    player.speed = 1.5f;
  }
  
  player.move();
}
/*Player player;
 GameManager gameManager;
 
 void setup() {
 size(800, 600);
 player = new Player(3, 0, width/2, height/2);
 gameManager = new GameManager(new Level[]{}, new UI[]{});
 }
 
 void draw() {
 background(255);
 //gameManager.display();
 player.physics();
 player.display();
 
 // Check for peeking
 if (player.isPeeking()) {
 gameManager.setPeeking(true);
 } else {
 gameManager.setPeeking(false);
 }
 
 // Check for cover
 if (player.isPeeking()) {
 // Do something
 }
 
 // Check for game over
 if (gameManager.gameOver) {
 // Do something
 }
 
 // Check for pause screen
 if (gameManager.paused) {
 // Do something
 }
 }
 
 void keyPressed() {
 player.move();
 
 // Handle pause screen
 if (key == 'p' || keyCode == ESC) {
 gameManager.togglePause();
 }
 }
 
 void keyReleased() {
 if (key == 'a' || key == 'd' || key == LEFT || key == RIGHT) {
 player.walking = false;
 player.vx = 0;
 }
 else if (key == ' ') {
 //player.vy /= 2; //Mess with this later
 }
 }*/
