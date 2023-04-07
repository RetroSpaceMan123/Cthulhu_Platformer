//This class handles the UI for the game
class UI {
  ButtonUI[] buttons;
  Textbox[] textboxes;
  PImage[] sprites;
  float[] spritesX;
  float[] spritesY;

  //Constructor
  UI(ButtonUI[] b, Textbox[] t, PImage[] s, float[] x, float[] y) {
    buttons = b;
    textboxes = t;
    sprites = s;
    spritesX = x;
    spritesY = y;
  }

  //Display UI
  void display() {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].display();
    }
    for (int i = 0; i < textboxes.length; i++) {
      textboxes[i].display();
    }
    imageMode(CENTER);
    for (int i = 0; i < sprites.length; i++) {
      image(sprites[i], spritesX[i], spritesY[i]);
    }
  }
  
  //Check to see if a button is pressed 
  void checkButtons() {
    for(int i = 0; i < buttons.length; i++) {
      // For now, the buttons only print to console when pressed
      // In future, perhaps I can implement Runnables, or an interface that allows GameManager functions to be called from the button itself
      if(buttons[i].isPressed()) print("Button " + i + " has been pressed");
    }
  }
};
