//This is where it's safe for the player to hide in order to avoid Cthulhu's stare
class Cover {
  float xPos, yPos, coverWidth, coverHeight;
  PImage coverImage;

  //Constructor
  Cover(float x, float y, float w, float h, int num) {
    xPos = x;
    yPos = y;
    coverWidth = w;
    coverHeight = h;
    coverImage = loadImage("cover"+num+".png");
    
  }

  void display() {
    imageMode(CENTER);
    image(coverImage, xPos, yPos, coverWidth, coverHeight);
  }
};
