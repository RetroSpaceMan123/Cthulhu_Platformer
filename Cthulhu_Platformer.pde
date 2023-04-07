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
