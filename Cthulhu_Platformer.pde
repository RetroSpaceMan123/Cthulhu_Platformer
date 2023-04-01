//Main File

Player player;

void setup() {
  size(800, 600);
  player = new Player(3, 0, width/2, height/2);
}

void draw() {
  background(255);
  player.display();
}

void keyPressed() {
  player.move();
}
