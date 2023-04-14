//Main File
import processing.sound.*;
SoundFile music;
SoundFile coinSound;
SoundFile roar1;
SoundFile jump;

Player player;
Cthulhu cthulhu;
PImage bckg;
Coin[] coins;
Platform platform;
Cover[] cover;
boolean covered;
int time;

void setup() {
  size(800, 800);
  music = new SoundFile(this, "mystery.mp3");
  coinSound = new SoundFile(Cthulhu_Platformer.this, "coin_collect.wav");
  roar1 = new SoundFile(Cthulhu_Platformer.this, "roar1.wav");
  jump = new SoundFile(Cthulhu_Platformer.this, "jump.wav");
  player = new Player(3, 0, width/2, height/2);
  cthulhu = new Cthulhu();
  frameRate(50);
  bckg = loadImage("background1.png");
  bckg.resize(800, 800);
  coins = new Coin[3];
  time = 3000;
  coins[0] = new Coin(400, 525);
  coins[1] = new Coin(500, 525);
  coins[2] = new Coin(550, 525);
  platform = new Platform(400, 600, 300, 100, color(155));
  cover  = new Cover[1];
  //cover[0] = new Cover(450, 470, 40, 80, 155);
  cover[0] = new Cover(300, 470, 40, 80, 155);
}

void draw() {
  /*if(!music.isPlaying()){
  music.play(1); }
  */
  background(bckg);
  
time = 0;

   if(millis() > time + 10*1000){
      // 10 seconds has elapsed
      time = millis();
      cthulhu.ascend = true;
      cthulhu.display();
   }
  
  player.checkPlatform(platform);
  player.physics();
  //System.out.println("vy: " + player.vy);
  for (int i = 0; i < coins.length; i++) {
    if (frameCount % 6 == 0) {
      coins[i].i = (coins[i].i+1)%10;
    }
    coins[i].display();
  }
  
  platform.display();
  for(int i = 0; i < cover.length; i++) {
    cover[i].display();
  }
  player.display();
  if (player.walking == false && player.running == false && player.isOnPlatform) {
  
  if(frameCount % 40 == 0) {
    cthulhu.h = (cthulhu.h+1)%12;
  }
  
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
}
  //cover logic
  covered = false;
 
  for(int i = 0; i < cover.length; i++) {
    boolean temp = player.xPos + 10 <= cover[i].xPos + cover[i].coverWidth && player.xPos - 15 >= cover[i].xPos;
    temp &= player.yPos - 18 >= cover[i].yPos && player.yPos + 10 <= cover[i].yPos + cover[i].coverHeight;
    covered |= temp;
  }
  
  player.isInCover = covered;
  //System.out.println(player.isInCover);
  
  //death reset
  if(player.yPos > 850 && player.lives > 1) {
    player.coins = 0;
    player.lives--;
    player.xPos = width/2;
    player.yPos = height/2;
    player.vy = 1.5f;
    //time = 0;
    //cthulhu.ascend = false;
   
    for(int i = 0; i < coins.length; i++) {
      coins[i].isCollected = false;
    }
  } else if(player.yPos > 850 && player.lives == 1) {
    player.lives--;
  }
  
  textSize(30);
  fill(#FFFF00);
  text("coins: " + player.coins, 25, 100);
  fill(#FF0000);
  text("lives: " + player.lives, 25, 130);
  noFill();
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
      //jump.play();
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
