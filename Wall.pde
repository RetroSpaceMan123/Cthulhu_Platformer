//This is a wall that has all-around collision detection
class Wall {
  float xPos, yPos, wallWidth, wallHeight;
  PImage wallImage;

  //Constructor
  Wall(float x, float y, float w, float h, int num) {
    xPos = x;
    yPos = y;
    wallWidth = w;
    wallHeight = h;
    wallImage = loadImage("wall"+num+".png");
  }

  void display() {
    imageMode(CENTER);
    image(wallImage, xPos, yPos, wallWidth, wallHeight);
  }
};
