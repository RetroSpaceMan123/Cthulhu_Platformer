//This object is used to call a sprite animation using png frames in the data file

class Sprite{
  String name;
  int numFrames;
  PImage[] frames;
  
  Sprite(String img, int num){
    name = img;
    numFrames = num;
    frames = new PImage[numFrames];
    for(int i = 0; i < numFrames; i++){
      frames[i] = loadImage(name+i+".png");
    }
  }
  
  PImage get(int num){
    return frames[num];
  }
}
 
