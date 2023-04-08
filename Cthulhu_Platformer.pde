//Main File


Player player;
PImage bckg;

void setup() {
  size(800, 800);
  player = new Player(3, 0, width/2, height/2);
  frameRate(50);
  bckg = loadImage("background1.png");
}

void draw() {
  background(255);
  player.physics();
  player.display();
  if (player.walking == false || keyPressed == false) {
    player.display();
    if (frameCount % 15 == 0) {
      player.f = (player.f+1)%4;
    }
  } else if (player.walking == true) {
    if (frameCount % 8 == 0) {
      player.g = (player.g+1)%5;
    } else if (player.vy != 0) {
      if (frameCount % 10 == 0) {
        player.h = (player.h+1)%6;
      }
    }
  }
}

void keyPressed() {
  player.move();
}

void keyReleased() {
  if (key == 'a' || key == 'd' || key == LEFT || key == RIGHT) {
    player.walking = false;
    player.vx = 0;
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
