//Main File

Player player;
Platform platform;

void setup() {
  size(800, 600);
  player = new Player(3, 0, width/2, height/2);
  platform = new Platform(width/2, 3 * height/4, 100, 100, color(155));
}

void draw() {
  background(255);
  platform.display();
  player.physics();
  player.display();
}

void keyPressed() {
  player.move();
}

void keyReleased() {
  player.vx = 0;
}
