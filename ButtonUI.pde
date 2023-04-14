//This is a UI element a player can press
class ButtonUI {
  float xPos, yPos, ButtonWidth, ButtonHeight;
  color Color;
  PImage sprite;
  Textbox textbox;

  //Constructor
  ButtonUI(float x, float y, float w, float h, color c, PImage i, Textbox t) {
    xPos = x;
    yPos = y;
    ButtonWidth = w;
    ButtonHeight = h;
    Color = c;
    sprite = i;
    textbox = t;
  }

  //Display Button
  void display() {
    rectMode(CENTER);
    fill(Color);
    rect(xPos, yPos, ButtonWidth, ButtonHeight);
    fill(255);
    imageMode(CENTER);
    image(sprite, xPos, yPos);
    textbox.display();
  }

  //Detect if the button is pressed
  boolean isPressed() {
    if (mouseY >= xPos - ButtonWidth/2 && mouseY <= xPos + ButtonWidth/2) {
      if (mouseY >= yPos - ButtonHeight/2 && mouseY <= yPos + ButtonHeight/2) {
        return true;
      }
    }
    return false;
  }
};
