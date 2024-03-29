//Main File //<>// //<>// //<>// //<>// //<>//
import processing.sound.*;
SoundFile music, menuMusic, coinSound, jump, stareSound, loseSound, gameOverMusic, fanfare, confirm;

Player player;
Cthulhu cthulhu;
PImage bckg;
Level[] levels;
boolean covered, paused, gameOver, recentDeath, win, inGame, inCredits;
int time;
UI gameUI;
UI pauseMenu;
UI mainMenu;
UI credits;
int diffType;


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
  if (diff == Difficulty.TUTORIAL) {
    interval = random(6000, 7000);
  }
  interval = random(4000, 8000);
  cthulhu.active = false;
  cthulhu.holdStare = false;
  stareSound.stop();
  if (!music.isPlaying()) {
    music.play();
  }
}


void drawGame(int diffType) {
  if (menuMusic.isPlaying()) {
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
        if(diff == Difficulty.HARD) interval = random(2000, 4000);
        else interval = random(5000, 8000);
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


  for (int i = 0; i < levels[diffType].coins.length; i++) {
    if (frameCount % 6 == 0) {
      levels[diffType].coins[i].i = (levels[diffType].coins[i].i+1)%10;
    }
    levels[diffType].coins[i].display();
  }


  levels[diffType].display();

  player.display();


  if (player.vy != 0 || player.jumping == true) {
    if (frameCount % 10 == 0) {
      player.h = (player.h+1)%6;
    }
  }
  if (player.walking == false && player.running == false) {

    player.display();
    if (frameCount % 15 == 0) {
      player.f = (player.f+1)%4;
    }
  } else if (player.running == true) {
    if (frameCount % 10 == 0) {
      player.j = (player.j+1)%8;
    }
  } else if (player.walking == true) {
    if (frameCount % 8 == 0) {
      player.g = (player.g+1)%5;
    }
  }


  //cover logic
  covered = false;

  for (int i = 0; i < levels[diffType].covers.length; i++) {
    covered = abs(player.xPos - (levels[diffType].covers[i].xPos)) <= levels[diffType].covers[i].coverWidth/2;
    covered &= abs(player.yPos - (levels[diffType].covers[i].yPos)) <= levels[diffType].covers[i].coverHeight/2;
    //println("Player X: " + player.xPos + " Player Y: " + player.yPos + " Cover X: " levels
    if (covered) {
      break;
    }
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
  }

  //death reset
  if (player.yPos > 850) {
    loseLife();
  }

  //Update the in-game UI
  gameUI.textboxes[0].Text = "Coins: " + player.coins + '/' + levels[diffType].coins.length;
  gameUI.textboxes[1].Text = "Lives: " + player.lives;
  //Display the in-game UI
  gameUI.display();

  if (gameOver) {
    if (player.lives == 0) {
      text("You Lose", width/2 - 65, height/2);
      music.stop();
      gameOverMusic.play();
    } else if (player.coins == levels[diffType].coins.length) {
      text("You Win", width/2 - 65, height/2);
      music.stop();
      fanfare.play();
    }

    text("Click Anywhere to Return to the Main Level", width/2 - 265, height/2 + 42);
    paused = true;
    noLoop();
  } else if (!gameOver) {
    player.isDead = false;
  }

  if (diff == Difficulty.TUTORIAL && inGame) {
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
  background(bckg);

  if (inCredits) {
    credits.display();
  } else {
    mainMenu.display();
  }

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


  coinsTutorial[0] = new Coin(500, 500);
  coinsTutorial[1] = new Coin(width/2 + 200, 380);
  coinsTutorial[2] = new Coin(width/2 + 380, 600);
  Platform[] platformsTutorial = new Platform[1];
  //PLATFORM INFO  PLATFORM(float xPos, float yPos, float width, float height, int num)
  platformsTutorial[0] = new Platform(width / 2 + 80, 550, 100, 30, 1);
  Cover[] coverTutorial = new Cover[1];
  //COVER INFO  Cover(float xPos, float yPos, float width, float height, int num)
  coverTutorial[0] = new Cover(width / 2 + 200, 380, 70, 70, 1);
  Wall[] wallsTutorial = new Wall[2];
  // WALL INFO  Wall(float xPos, float yPos, float width, float height, int num)
  wallsTutorial[0] = new Wall(width / 2, 700, width, 100, 1);
  wallsTutorial[1] = new Wall(width / 2 + 200, 530, 150, 240, 1);
  levels[0] = new Level(coinsTutorial, platformsTutorial, coverTutorial, wallsTutorial, 1, 100, (float)(height/2));
  player.xPos = levels[diffType].initX;
  player.yPos = levels[diffType].initY;

  // initialize easy level
  // ================================= EASY ======================================

  Wall[] wallsEasy = new Wall[6];
  Coin[] coinsEasy = new Coin[9];
  Cover[] coversEasy = new Cover[6];
  Platform[] platformsEasy = new Platform[4];

  wallsEasy[0] = new Wall(100, 750, 300, 50, 1);
  wallsEasy[1] = new Wall(500, 750, 300, 50, 1);
  wallsEasy[2] = new Wall(900, 750, 300, 50, 1);
  wallsEasy[3] = new Wall(900, 550, 300, 50, 1);
  wallsEasy[4] = new Wall(500, 550, 300, 50, 1);
  wallsEasy[5] = new Wall(width/2, 400, 300, 50, 1);


  coinsEasy[0] = new Coin(125, 700);
  coinsEasy[1] = new Coin(525, 700);
  coinsEasy[2] = new Coin(925, 700);
  coinsEasy[3] = new Coin(875, 500);
  coinsEasy[4] = new Coin(475, 500);
  coinsEasy[5] = new Coin(width/2 + 25, 500);
  coinsEasy[6] = new Coin(200, 550);
  coinsEasy[7] = new Coin(width/2, 300);
  coinsEasy[8] = new Coin(3 * width/4, 250);

  platformsEasy[0] = new Platform(200, 600, 200, 25, 1);
  platformsEasy[1] = new Platform(width/2, 250, 200, 25, 1);
  platformsEasy[2] = new Platform(3 * width/4, 300, 200, 25, 1);
  platformsEasy[3] = new Platform(250, 300, 200, 25, 1);

  coversEasy[0] = new Cover(100, 715, 60, 80, 1);
  coversEasy[1] = new Cover(500, 715, 60, 80, 1);
  coversEasy[2] = new Cover(900, 715, 60, 80, 1);
  coversEasy[3] = new Cover(900, 515, 60, 80, 1);
  coversEasy[4] = new Cover(500, 515, 60, 80, 1);
  coversEasy[5] = new Cover(width/2, 350, 60, 80, 1);
  


  levels[1] = new Level(coinsEasy, platformsEasy, coversEasy, wallsEasy, 3, 100, 700);
  player.xPos = levels[diffType].initX;
  player.yPos = levels[diffType].initY;

  // Hard Level
  levels[2] = new Level(coinsEasy, platformsEasy, coversEasy, wallsEasy, 2, 100, 700);

  //interval creation
  interval = random(6000, 7000); // generate a random interval between 2 and 5 seconds
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

  //Credits
  Textbox[] creditText = new Textbox[7];
  creditText[0] = new Textbox(width/2 - 90, 60, 48, "Constantia-Bold-32.vlw", "Credits");
  creditText[1] = new Textbox(width/2 - 125, 160, 48, "Constantia-Bold-32.vlw", "Created By:");
  creditText[2] = new Textbox(200, 210, 24, "Constantia-Bold-32.vlw", "Carlos Avila, Eugene Gurary, Peter Luchhino, Bryan Torreblanca");
  creditText[3] = new Textbox(width/2 - 75, 310, 48, "Constantia-Bold-32.vlw", "Art by:");
  creditText[4] = new Textbox(100, 360, 24, "Constantia-Bold-32.vlw", "Penzilla, morgan3d, David G, Eugene Gurary, vkramnik, and some unnamed artists");
  creditText[5] = new Textbox(width/2 - 100, 460, 48, "Constantia-Bold-32.vlw", "Music by:");
  creditText[6] = new Textbox(100, 510, 24, "Constantia-Bold-32.vlw", "Erich Izdepski, Tausdei, Cabled Mess, Soundreality, Mixkit, AntumDeluge, ricniclas");
  ButtonUI[] creditButton = new ButtonUI[1];
  Textbox backText = new Textbox(width/2 - 40, 710, 32, "Constantia-Bold-32.vlw", "Back");
  creditButton[0] = new ButtonUI(width/2, 700, 300, 42, color(100), new PImage(), backText);
  credits = new UI(creditButton, creditText, new PImage[0], new float[0], new float[0]);


  gameOver = false;
  recentDeath = false;
}

void draw() {
  if (inGame) {

    if (diff == Difficulty.TUTORIAL) {
      player.lives = 10000;
      diffType = 0;
      drawGame(0);
    } else if (diff == Difficulty.EASY) {
      diffType = 1;
      drawGame(1);
    } else if (diff == Difficulty.HARD) {
      diffType = 2;
      drawGame(2);
    }
  } else {
    drawMainMenu();
  }
}



void keyPressed() {
  if (inGame) {
    if (key == 'a' || key == 'A' || keyCode == LEFT) {
      player.left = true;
    }
    if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      player.right = true;
    }

    if (keyCode == SHIFT && !player.jumping) {
      player.running = true;
      player.speed = 3f;
    }
    if (key == ' ' && !player.jumping) {
      player.vy = -player.jumpForce;
      player.jumping = true;
      jump.play();
    }

    if (keyCode == SHIFT && !player.jumping) {
      player.running = true;
      player.speed = 3f;
    }
    if (key == ' ' && !player.jumping) {
      player.vy = -player.jumpForce;
      player.jumping = true;
    }


    player.move();
    if (keyCode == SHIFT && !player.jumping) {
      player.running = true;
      player.speed = 3f;
    }
    if (key == ' ' && !player.jumping) {
      player.vy = -player.jumpForce;
      player.jumping = true;
      jump.play();
    }

    if (!paused) {
      player.move();
      if (!music.isPlaying()) {
        music.play();
      }
    }
  }
}

void keyReleased() {
  if (inGame) {
    if (key == 'a' || key == 'A' || keyCode == LEFT) {
      player.left = false;
    }
    if (key == 'd' || key == 'D' || keyCode == RIGHT) {
      player.right = false;
    }
    if (keyCode == SHIFT) {
      player.running = false;
      player.speed = 1.5f;
    }

    player.move();
  }
}

void mousePressed() {
  if (inGame) {
    if (gameOver) {
      gameOver = false;
      paused = false;
      inGame = false;
      player.coins = 0;
      player.lives = 3;
      player.xPos = levels[diffType].initX;
      player.yPos = levels[diffType].initY;
      player.vy = 1.5f;
      startTime = millis();
      cthulhu.ascend = false;
      cthulhu.descend = false;
      cthulhu.holdStare = false;
      cthulhu.active = false;
      cthulhu.a = 0;
      cthulhu.d = 0;
      gameOverMusic.stop();
      // test rpa

      for (int i = 0; i < levels[diffType].coins.length; i++) {
        levels[diffType].coins[i].isCollected = false;
      }

      loop();
    } else if (gameUI.buttons[0].isPressed()) {
      paused = !paused;
      if (stareSound.isPlaying()) {
        stareSound.pause();
      }
      if (!music.isPlaying() && !stareSound.isPlaying()) {
        music.play();
      }
    }
    if (paused && pauseMenu.buttons[0].isPressed()) {
      paused = false;
      /*if (stareSound.isPlaying()) {
       stareSound.pause();
       }*/
      if (!music.isPlaying() && !stareSound.isPlaying()) {
        music.play();
      }
    } else if (paused && pauseMenu.buttons[1].isPressed()) {
      inGame = false;
      paused = false;
      loseLife();
      if (diff != Difficulty.TUTORIAL) {
        player.lives = 3;
      }
      /*if (stareSound.isPlaying()) {
       stareSound.pause();
       }*/
      if (!music.isPlaying() && !stareSound.isPlaying()) {
        music.play();
      }
    }
    if (paused) {
      music.pause();
      if (stareSound.isPlaying()) {
        stareSound.pause();
      }
      pauseMenu.display();
      noLoop();
    } else {
      loop();
    }
  } else if (inCredits) {
    if (credits.buttons[0].isPressed()) {
      inCredits = false;
    }
  } else {
    if (mainMenu.buttons[0].isPressed()) {
      confirm.play();
      inGame = true;
      confirm.play();
      startTime = millis();
    } else if (mainMenu.buttons[1].isPressed()) {
      if (diff == Difficulty.TUTORIAL) {
        diff = Difficulty.EASY;
        player.lives = 3;
        mainMenu.buttons[1].textbox.Text = "Difficulty: Easy";
      } else if (diff == Difficulty.EASY) {
        diff = Difficulty.HARD;
        mainMenu.buttons[1].textbox.Text = "Difficulty: Hard";
      } else if (diff == Difficulty.HARD) {
        diff = Difficulty.TUTORIAL;
        mainMenu.buttons[1].textbox.Text = "Difficulty: Tutorial";
      }
    } else if (mainMenu.buttons[2].isPressed()) {
      inCredits = true;
      confirm.play();
    } else if (mainMenu.buttons[3].isPressed()) {
      exit();
    }
  }
}
