//Main File
import processing.sound.*;
SoundFile music, coinSound, roar1, roar2, jump, stareSound, loseSound;

Player player;
Cthulhu cthulhu;
PImage bckg;
Coin[] coins;
Platform[] platforms;
Cover[] cover;
Wall[] walls;
boolean covered;
int time;
UI gameUI;
boolean paused;

int savedTime;
int totalTime = 5000;
float reachedPoint; // randomizer to start cthulhu animation

int x = 0;
float startTime;
float currTime = 0;          // initialize the timer
float interval = 0;       // initialize the interval
boolean pointReached; // cthulhu
boolean gameOver;
boolean recentDeath;

void loseLife() {
  player.coins = 0;
  player.lives--;
  player.xPos = width/2;
  player.yPos = height/2;
  player.vy = 1.5f;
  time = 0;
  
  cthulhu.active = false;
  recentDeath = true;
  if(!loseSound.isPlaying()){
  loseSound.play();
  }
        
  player.isDead = true;
  for (int i = 0; i < coins.length; i++) {
    coins[i].isCollected = false;
}

  cthulhu.a = 0;
  cthulhu.d = 0;
  cthulhu.descend = false;
  cthulhu.ascend = false;
  startTime = millis();
  interval = random(4000, 8000);
  cthulhu.active = false;
  cthulhu.holdStare = false;
  stareSound.stop();
  if(!music.isPlaying()){
    music.play();
  }
}


void setup() {
  size(800, 800);
  music = new SoundFile(Cthulhu_Platformer.this, "theme.mp3");
  coinSound = new SoundFile(this, "coin_collect.wav");
  roar1 = new SoundFile(this, "roar1.wav");
  roar2 = new SoundFile(this, "roar2.wav");
  stareSound = new SoundFile(this, "cthulhu_stare.wav");
  jump = new SoundFile(this, "jump.wav");
  loseSound = new SoundFile(this, "lose_sound1.wav");
  player = new Player(3, 0, width/2, height/2);
  cthulhu = new Cthulhu();
  frameRate(50);
  bckg = loadImage("background1.png");
  bckg.resize(800, 800);
  coins = new Coin[6];
  time = millis();
  
  //init
  coins[0] = new Coin(400, 525);
  coins[1] = new Coin(255, 650);
  coins[2] = new Coin(100, 265);
  coins[3] = new Coin(600, 360);
  coins[4] = new Coin(200, 360);
  coins[5] = new Coin(700, 265);
  platforms = new Platform[6];
  platforms[0] = new Platform(400, 600, 200, 100, 1);
  platforms[1] = new Platform(600, 450, 200, 50, 1);
  platforms[2] = new Platform(200, 450, 200, 50, 1);
  platforms[3] = new Platform(100, 350, 100, 50, 1);
  platforms[4] = new Platform(250, 700, 100, 50, 1);
  platforms[5] = new Platform(700, 350, 100, 50, 1);

  cover  = new Cover[3];
  //cover[0] = new Cover(450, 470, 40, 80, 155);
  cover[0] = new Cover(300, 470, 60, 80, 1);
  cover[1] = new Cover(240, 345, 60, 80, 1);
  cover[2] = new Cover(500, 345, 60, 80, 1);
  
  walls = new Wall[1];
  walls[0] = new Wall(425, 440, 100, 100, 4);

//interval creation
  interval = random(5000, 6000); // generate a random interval between 2 and 5 seconds
  startTime = 0;
  savedTime = 0;

//UIs and textboxes
  Textbox[] textboxes = new Textbox[2];
  textboxes[0] = new Textbox(500, 50, 32, "Constantia-Bold-32.vlw", "Coins: ");
  textboxes[1] = new Textbox(670, 50, 32, "Constantia-Bold-32.vlw", "Lives: ");
  Textbox textbox = new Textbox(65, 50, 32, "Constantia-Bold-32.vlw", "Pause");
  ButtonUI mainMenu = new ButtonUI(113, 40, 200, 42, color(100), new PImage(), textbox);
  ButtonUI[] buttons = new ButtonUI[1];
  buttons[0] = mainMenu;
  gameUI = new UI(buttons, textboxes, new PImage[0], new float[0], new float[0]);
  gameOver = false;
  recentDeath = false;
  music.loop();
}

void draw() {
  background(bckg);

  //Game State
  if (player.lives == 0 || player.coins == coins.length) {
    gameOver = true;
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

  cthulhu.display();

//Platform checks and physics
  for (int i = 0; i < platforms.length; i++) {
    boolean landed = player.checkPlatform(platforms[i]);
    if (landed) break;
  }
  
//Wall checks and physics
  for(int i = 0; i < walls.length; i++) {
    boolean landed = player.checkWall(walls[i]);
    if(landed) break;
  }
  

  player.physics();
  //System.out.println("vy: " + player.vy);
  
  //Coins and platforms display
  for (int i = 0; i < coins.length; i++) {
    if (frameCount % 6 == 0) {
      coins[i].i = (coins[i].i+1)%10;
    }
    coins[i].display();
  }

  for (int i = 0; i < platforms.length; i++) {
    platforms[i].display();
  }
  for (int i = 0; i < cover.length; i++) {
    cover[i].display();
  }
  walls[0].display();
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

  for (int i = 0; i < cover.length; i++) {
    boolean temp = player.xPos + 10 <= cover[i].xPos + cover[i].coverWidth && player.xPos - 15 >= cover[i].xPos;
    temp &= player.yPos - 18 >= cover[i].yPos && player.yPos + 10 <= cover[i].yPos + cover[i].coverHeight;
    covered |= temp;
  }

  player.isInCover = covered;
  //System.out.println(player.isInCover);
  
  
  //wall collision
  for(int i = 0; i < walls.length; i++) {
    boolean temp = player.xPos + 10 > walls[i].xPos - walls[i].wallWidth/2 && player.xPos - 12 < walls[i].xPos + walls[i].wallWidth/2;
    temp &= player.yPos - 19 < walls[i].yPos + walls[i].wallHeight/2 && player.yPos + 16 > walls[i].yPos - walls[i].wallHeight/2;

    /*
    if(temp) {
      stroke(#00FF00);
      //line(player.xPos, player.yPos, walls[0].xPos - walls[0].wallWidth/2 - 11, player.yPos);
      stroke(#FF0000);
      //line(player.xPos, player.yPos, walls[0].xPos + walls[0].wallWidth/2 + 12, player.yPos);
      stroke(#FF00FF);
      //line(player.xPos, player.yPos, player.xPos, walls[0].yPos - walls[0].wallHeight/2 - 16.75);
      stroke(#FFFF00);
      //line(player.xPos, player.yPos, player.xPos, walls[0].yPos + walls[0].wallHeight/2 + 19.25);
    }
    */
    
    float leftSide = dist(player.xPos, player.yPos, walls[i].xPos - walls[i].wallWidth/2 - 11, player.yPos);
    float topSide = dist(player.xPos, player.yPos, player.xPos, walls[i].yPos - walls[i].wallHeight/2 - 16.75);
    float rightSide = dist(player.xPos, player.yPos, walls[i].xPos + walls[i].wallWidth/2 + 12, player.yPos);
    float bottomSide = dist(player.xPos, player.yPos, player.xPos, walls[i].yPos + walls[i].wallHeight/2 + 19.25);
  
    if(temp) {
      if(leftSide < topSide && leftSide < rightSide && leftSide < bottomSide) {
        player.xPos = walls[i].xPos - walls[i].wallWidth/2 - 11;
      } else if(topSide < leftSide && topSide < rightSide && topSide < bottomSide) {
        player.vy = 0;
        player.yPos = walls[i].yPos - walls[i].wallHeight/2 - 16.75;
      } else if(rightSide < leftSide && rightSide < topSide && rightSide < bottomSide) {
        player.xPos = walls[i].xPos + walls[i].wallWidth/2 + 12;
      } else if(bottomSide < leftSide && bottomSide < topSide && bottomSide < rightSide) {
        player.vy = 0;
        player.yPos = walls[i].yPos + walls[i].wallHeight/2 + 19;
      }
    }
  }
  
  //death reset
  if (player.yPos > 850) {
    loseLife();
  }

  //Update the in-game UI
  gameUI.textboxes[0].Text = "Coins: " + player.coins + '/' + coins.length;
  gameUI.textboxes[1].Text = "Lives: " + player.lives;
  //Display the in-game UI
  gameUI.display();

  if (gameOver) {
    if (player.lives == 0) {
      text("You Lose", width/3 + 65, height/2);
    } else if (player.coins == coins.length) {
      text("You Win", width/3 + 65, height/2);
    }

    text("Click Anywhere to Restart", width/3 - 65, height/2 + 42);
    paused = true;
    noLoop();
  }
  else if (!gameOver) {
    player.isDead = false;
  }
}



void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    player.left = true;
  }
  if (key == 'd' || keyCode == RIGHT) {
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
    if(!music.isPlaying()){
      music.play();
    }
  }
}

void keyReleased() {
  if (key == 'a' || keyCode == LEFT) {
    player.left = false;
  }
  if (key == 'd' || keyCode == RIGHT) {
    player.right = false;
  }
  if (keyCode == SHIFT) {
    player.running = false;
    player.speed = 1.5f;
  }

  player.move();
  if (!paused) player.move();
}

void mousePressed() {
  if (gameOver) {
    gameOver = false;
    paused = false;
    player.coins = 0;
    player.lives = 3;
    player.xPos = width/2;
    player.yPos = height/2;
    player.vy = 1.5f;
    startTime = millis();
    cthulhu.ascend = false;
    cthulhu.descend = false;
    cthulhu.holdStare = false;
    cthulhu.active = false;
    cthulhu.a = 0;
    cthulhu.d = 0;


    for (int i = 0; i < coins.length; i++) {
      coins[i].isCollected = false;
    }

    loop();
  } else if (gameUI.buttons[0].isPressed()) {
    paused = !paused;
    if (paused) {
      text("Paused", width/2 - 60, height/2);
      music.pause();
      if(stareSound.isPlaying()){
      stareSound.pause();
      }
      roar1.stop();
      roar2.stop();
      noLoop();
    } else loop();
  }
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
