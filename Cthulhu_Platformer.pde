//Main File

/*
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
  if (player.walking == false || keyPressed == false) {
    player.idleDisplay();
    if (frameCount % 15 == 0) {
      player.f = (player.f+1)%4;
    } 
  }
    else if (player.walking == true) {
    player.walkDisplay();
    if (frameCount % 8 == 0) {
      player.g = (player.g+1)%5;
    }
    }
}

void keyPressed() {
  player.move();
  player.jump();
}
*/

Player player;
GameManager gameManager;

void setup() {
size(800, 600);
player = new Player(3, 0, width/2, height/2);
gameManager = new GameManager(new Level[]{new Level()}, new UI[]{new UI()});
}

void draw() {
background(255);
player.display();
GameManager.display();

// Check for peaking
if (player.isPeaking()) {
GameManager.setPeaking(true);
}
else{
  GameManager.setPeaking(false;)
}

// Check for cover
if (gameManager.isInCover(player)) {
// Do something
}

// Check for game over
if (gameManager.isGameOver()) {
// Do something
}

// Check for pause screen
if (gameManager.isPaused()) {
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