import processing.sound.*;
float timer;

//Appears in random intervals in order to force player into cover
class Cthulhu {
  float xPos, yPos;
  boolean active, ascend, descend, holdStare;
  Sprite ascending;
  Sprite descending;
  PImage staring;
  int a, d;
  

  void loadSprites(){
    ascending = new Sprite("Cthulhu Ascending-", 12);
    descending = new Sprite("Cthulhu (Descending)-", 13);
    staring = loadImage("Cthulhu_Stare.png");
  }
  
  Cthulhu() {
    xPos = player.xPos;
    yPos = height/2 - 100;
    a = 0;
    d= 0;
    active = false;
    loadSprites();
    ascend = false;
    descend = false;
    holdStare = false;
  }

  void display() {
    
    if(a == 11 && !descend){
       music.pause();
      if(!stareSound.isPlaying()){
      stareSound.play(1.5);

      }
    }
    
    if(ascend){
    imageMode(CENTER);
    image(ascending.get(a), xPos, yPos, 600, 600);
    }
    else if(descend) {
      image(descending.get(d), xPos, yPos, 600, 600);
      stareSound.stop();
      if(!music.isPlaying() && d == 2){
      music.play();
      }
    }

    }
}
