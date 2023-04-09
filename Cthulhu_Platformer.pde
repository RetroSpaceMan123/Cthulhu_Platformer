//Main File


Player player;
PImage bckg;
Coin[] coins;
Platform platform;

void setup() {
  size(800, 800);
  player = new Player(3, 0, width/2, height/2);
  frameRate(50);
  bckg = loadImage("background1.png");
  coins = new Coin[3];
  coins[0] = new Coin(50, 50);
  coins[1] = new Coin(150, 50);
  coins[2] = new Coin(250, 50);
  platform = new Platform(400, 600, 300, 100, color(155));
}

void draw() {
  background(255);
  player.checkPlatform(platform);
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
  else if (player.vy != 0) {
      if (frameCount % 10 == 0) {
        player.h = (player.h+1)%6;
      }
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
