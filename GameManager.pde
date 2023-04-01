//This class is responsible for switching in between levels, and determining game states
class GameManager {
  Level[] levels;
  UI[] uis;
  boolean paused, gameOver;
  int currentLevel, currentUI;

  GameManager(Level[] l, UI[] u) {
    levels = l;
    uis = u;
    paused = false;
    gameOver = false;
  }

  void display() {
    levels[currentLevel].display();
    uis[currentUI].display();
  }

  //Switch between levels
  void switchLevels(int level) {
    currentLevel = level;
  }

  //Swap UI
  void switchUIs(int ui) {
    currentUI = ui;
  }
};
