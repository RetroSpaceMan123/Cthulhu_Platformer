//This class is responsible for switching in between levels, and determining game states
class GameManager {
  Level[] levels;
  UI[] uis;
  boolean paused, gameOver;
  int currentLevel, currentUI;

  // if player is in cover
  boolean inCover;

  // if Cthulhu is peaking
  boolean cthulhuPeaking;

  GameManager(Level[] l, UI[] u) {
    levels = l;
    uis = u;
    paused = false;
    gameOver = false;
    inConver = false;
    cthulhuPeaking = false;
  }

  void display() {
    levels[currentLevel].display();
    uis[currentUI].display();

    //check to see if player is in cover
    // have to check if implemented isPlayerInCover function
   // inCover = levels[currentLevel].isPlayerInCover(player.xPos, player.yPos);
   if(inCover){
    // haven't implemented the showCoverMessage func yet
   // uis[currentUI].showCoverMessage();
   }
   else {
    // same for this one, as abpve
    //uis[currentUI].hideCoverMessage();
   }
  
  }

  //Switch between levels
  void switchLevels(int level) {
    currentLevel = level;

    // reset player pos
    // haven't implemented the get player start x func
    //player.xPos = levels[currentLevel].getPlayerStartX();
    // same for this one, as above
    //player.yPos = levels[currentLevel].getPlayerStartY();
  }

  //Swap UI
  void switchUIs(int ui) {
    currentUI = ui;
  }

  // Pause Screen Handler
  void togglePause(){
    pause = !paused;
    if (paused){
      // haven't implemented func yet but this is the idea
      uis[currentUI].showPauseScreen();
    }
    else{
      // same situation as comment above
      //uis[currentUI].hidePauseScreen();
    }

  }

  // Game State Handler
  void gameOver(){
    gameOver = true;
    // haven't implemented func yet but this is the idea
    //uis[currentUI].showGameOverScreen();
  }

  // in cover condition if player's position is taking cover.
  void setInCover(boolean cover){
    inCover = cover;
  }

  // peaking condition if Cthulhu is peaking or not
  void setPeaking(boolean p){
    cthulhuPeaking = p;
  }

};
